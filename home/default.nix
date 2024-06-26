{ inputs, lib, config, pkgs, pkgs-unstable, home-manager, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.pascal = {
    home.stateVersion = "22.05";

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      # Terminal
      starship
      fastfetch

      # Launchers & Tools
      gamemode
      pkgs-unstable.protontricks
      steam
      steam-run
      lutris
      wine
      dxvk
      gnome.zenity
      
      # Games
      prismlauncher
      superTuxKart

      # Overlay & Post-Processing
      mangohud
      vkBasalt
    ];

    imports = [
      ./alacritty
      ./git
      ./mangohud
      ./scripts
      ./starship
      ./vscode
      ./zsh
    ];

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    # Enable emacs server
    services.emacs.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
