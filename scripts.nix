{ pkgs, ... }:
let
  skse = pkgs.writeShellScriptBin "skse" (builtins.readFile scripts/skse.sh);
  mo2 = pkgs.writeShellScriptBin "mo2" (builtins.readFile scripts/mo2.sh);
in
{
  environment.systemPackages = [
    skse
    mo2
  ];
}