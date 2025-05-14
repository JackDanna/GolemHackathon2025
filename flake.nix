{
  description = "A Python Dev Shell";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
          "vscode-with-extensions"
          "vscode"
          "vscode-extension-mhutchie-git-graph"
        ];
      };
    };
  in 
  {
    packages.${system} = {
      default = pkgs.writeShellScriptBin "run" ''
        nix develop -c -- codium .
      '';
    };
  devShells.${system}.default = (pkgs.buildFHSEnv rec {
    name = "golem";
    targetPkgs =
      pkgs:
      (with pkgs; [
        udev
        alsa-lib
        openssl
        uv


        (pkgs.python3.withPackages (python-pkgs: [
          python-pkgs.numpy
          python-pkgs.pandas
          python-pkgs.scipy
        ]))
        bashInteractive
        (vscode-with-extensions.override  {
          vscode = pkgs.vscodium;
          vscodeExtensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mhutchie.git-graph
            ms-python.python
            ms-toolsai.jupyter
            ms-python.debugpy
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              # {
              #   name = "vscode-dotnet-runtime";
              #   publisher = "ms-dotnettools";
              #   version = "2.0.5";
              #   sha256 = "sha256-acP3NULTNNyPw5052ZX1L+ymqn9+t4ydoCns29Ta1MU=";
              # }

              {
               name = "vscode-wasm";
               publisher = "dtsvet";
               version = "1.4.1";
               sha256 = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
              }
              # {
              #   name = "vscode-edit-csv";
              #   publisher = "janisdd";
              #   version = "0.8.2";
              #   sha256 = "sha256-DbAGQnizAzvpITtPwG4BHflUwBUrmOWCO7hRDOr/YWQ=";
              # }
            ];
        })



      ])
      ++ (with pkgs.xorg; [
        
        libX11
        libXcursor
        libXrandr
      ]);
      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the Golem Hackaton 2025 Shell!"
      '';

    multiPkgs =
      pkgs:
      (with pkgs; [
        udev
        alsa-lib
      ]);
    runScript = "bash";
  }).env;
  }; 

}


