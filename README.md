# Cargo
```sh
cargo lambda build
cargo lambda deploy --iam-role <my role>
```

# Nix or make
```sh
nix build
# or
make # require docker

mkdir -p target/lambda/rust-lambda-cloudtrail/
cp result-bin/bin/rust-lambda-cloudtrail target/lambda/rust-lambda-cloudtrail/bootstrap
cargo lambda deploy --iam-role <my role>
```
