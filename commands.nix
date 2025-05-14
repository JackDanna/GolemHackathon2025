{ pkgs ? import <nixpkgs> {}
, prefix ? "b2n"
}:
let 

  commands = pkgs.lib.fix (self: pkgs.lib.mapAttrs pkgs.writeShellScript
  {

    golem = ''
      ../golem-x86_64-unknown-linux-gnu app build
    '';

  
    default = "ls commands.nix | ${self.entr} -r nix run .#start";
});
in pkgs.symlinkJoin rec {
  name = prefix;
  passthru.set = commands;
  passthru.bin = pkgs.lib.mapAttrs (name: command: pkgs.runCommand "${prefix}-${name}" {} '' 
    mkdir -p $out/bin
    ln -sf ${command} $out/bin/${
        if name == "default" then prefix else prefix+"-"+name
    }
  '') commands;
  paths = pkgs.lib.attrValues passthru.bin;
}
