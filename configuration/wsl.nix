{ config, nixpkgs, pkgs, pkgs-newest, pkgs-unstable, ... }:

{
  imports =
    [
      ./common.nix
      # Include the home manager configuration
      ../home/wsl.nix
    ];

  wsl.enable = true;
  wsl.defaultUser = "pascal";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  system.stateVersion = "24.05";

}
