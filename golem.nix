{ pkgs ? import <nixpkgs> {} }:
with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "golem";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "golemcloud";
    repo = "golem";
    tag = "v${version}";
    hash = "sha256-6AUUgXWlDaoI16p/Hrl115XMGYUIDD5YWHX6JfDk9SI=";
  };

  # Taker from https://github.com/golemcloud/golem/blob/v1.0.26/Makefile.toml#L399
  postPatch = ''
    grep -rl --include 'Cargo.toml' '0\.0\.0' | xargs sed -i "s/0\.0\.0/${version}/g"
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    (lib.getDev openssl)
  ];

  # Required for golem-wasm-rpc's build.rs to find the required protobuf files
  # https://github.com/golemcloud/wasm-rpc/blob/v1.0.6/wasm-rpc/build.rs#L7
  GOLEM_WASM_AST_ROOT = "../golem-wasm-ast-1.2.3";
  # Required for golem-examples's build.rs to find the required Wasm Interface Type (WIT) files
  # https://github.com/golemcloud/golem-examples/blob/v1.0.6/build.rs#L9
  GOLEM_WIT_ROOT = "../golem-wit-1.2.3";

  useFetchCargoVendor = true;
  cargoHash = "";

  # Tests are failing in the sandbox because of some redis integration tests
  doCheck = false;
  checkInputs = [ redis ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = [ "${placeholder "out"}/bin/golem-cli" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source durable computing platform that makes it easy to build and deploy highly reliable distributed systems";
    changelog = "https://github.com/golemcloud/golem/releases/tag/${src.tag}";
    homepage = "https://www.golem.cloud/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kmatasfp ];
    mainProgram = "golem-cli";
  };
}
