# Cargo
```sh
cargo lambda build
cargo lambda deploy --iam-role <my role>
```

# Nix (musl)
```sh
nix build
mkdir -p target/lambda/rust-lambda-cloudtrail/
cp result-bin/bin/rust-lambda-cloudtrail target/lambda/rust-lambda-cloudtrail/bootstrap
cargo lambda deploy --iam-role <my role>
```
