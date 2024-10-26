{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bkup";

  home-manager.users.pascal = {

    imports = [
      ./alacritty
      ./git
      ./starship
      ./zsh
    ];

    home.stateVersion = "22.05";

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      # Terminal
      starship
      fastfetch
    ];

  };

}
