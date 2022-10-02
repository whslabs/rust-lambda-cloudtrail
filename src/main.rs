use aws_config::meta::region::RegionProviderChain;
use aws_lambda_events::event::cloudwatch_logs::LogsEvent;
use aws_sdk_sns::Client;
use lambda_runtime::{run, service_fn, Error, LambdaEvent};
use serde_json::Value;

/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
/// - https://github.com/aws-samples/serverless-rust-demo/
async fn function_handler(event: LambdaEvent<LogsEvent>) -> Result<(), Error> {
    // Extract some useful information from the request

    let (event, _) = event.into_parts();

    let data = event.aws_logs.data;

    let region_provider = RegionProviderChain::default_provider().or_else("us-east-1");

    let config = aws_config::from_env().region(region_provider).load().await;

    let client = Client::new(&config);

    for e in data.log_events.iter() {
        let v: Value = serde_json::from_str(&e.message).unwrap();

        println!("{:?}", v);

        let arn = v["requestParameters"]["tagSpecificationSet"]["items"]
            .as_array()
            .unwrap()
            .iter()
            .filter(|x| x["resourceType"] == "image")
            .map(|x| &x["tags"])
            .next()
            .unwrap()
            .as_array()
            .unwrap()
            .iter()
            .filter(|x| x["key"] == "Ec2ImageBuilderArn")
            .map(|x| &x["value"])
            .next()
            .unwrap()
            .as_str()
            .unwrap();

        let rsp = client
            .publish()
            .topic_arn(std::env::var("TOPIC_ARN").unwrap())
            .message(format!(
                "{} {}",
                arn,
                v["responseElements"]["imageId"].as_str().unwrap()
            ))
            .send()
            .await?;

        println!("{:?}", rsp);
    }

    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    run(service_fn(function_handler)).await
}
