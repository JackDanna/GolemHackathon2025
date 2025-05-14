{
  pkgs ? import <nixpkgs> { },
}:

(pkgs.buildFHSEnv {
  name = "simple-x11-env";
  targetPkgs =
    pkgs:
    (with pkgs; [
      udev
      alsa-lib
      openssl

    ])
    ++ (with pkgs.xorg; [
      
      libX11
      libXcursor
      libXrandr
    ]);
  multiPkgs =
    pkgs:
    (with pkgs; [
      udev
      alsa-lib
    ]);
  runScript = "bash";
}).env
