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


