{
  description = "A Python Dev Shell";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in 
  {
    packages.${system} = {
      default = pkgs.writeShellScriptBin "run" ''
        nix develop -c -- codium .
      '';
    };

    devShells.${system}.default = pkgs.mkShell rec {
      name = "PythonDevShell";
      buildInputs = with pkgs; [
        python3
        bashInteractive
        (vscode-with-extensions.override  {
          vscode = pkgs.vscodium;
          vscodeExtensions = with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mhutchie.git-graph
            ms-python.python
            ms-toolsai.jupyter
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # {
            #   name = "csharp";
            #   publisher = "ms-dotnettools";
            #   version = "2.30.28";
            #   sha256 = "sha256-+loUatN8evbHWTTVEmuo9Ups6Z1AfqzCyTWWxAY2DY8=";
            # }
          ];
        })
      ];

      shellHook = ''
        export PS1+="${name}> "
        echo "Welcome to the C Dev Shell!"
      '';
    };
  }; 

}


