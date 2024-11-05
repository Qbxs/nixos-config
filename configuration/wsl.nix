{ pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "pascal";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  system.stateVersion = "24.05";

}
