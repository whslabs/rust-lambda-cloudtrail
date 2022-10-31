{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/unstable";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          crossSystem = {
            config = "x86_64-unknown-linux-musl";
          };

          overlays = [ cargo2nix.overlays.default ];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          packageFun = import ./Cargo.nix;
          rustVersion = "1.64.0";
          target = "x86_64-unknown-linux-musl";
        };

      in rec {
        packages = {
          lambda = (rustPkgs.workspace.rust-lambda-cloudtrail {}).bin;
          default = packages.lambda;
        };
        defaultPackage = packages.default;
      }
    );
}
