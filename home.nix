{ config, pkgs, home-manager, ... }:

{
  # imports = [ (import "${home-manager}/nixos") ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.pascal = {
    home.stateVersion = "22.05";

    nixpkgs.config.allowUnfree = true;

    imports = [
      ./home/alacritty
      ./home/git
      ./home/mangohud
      ./home/starship
      ./home/vscode
      ./home/zsh
    ];

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    # Enable emacs server
    services.emacs.enable = true;

    home.packages = with pkgs; [
      # Games & Launchers
      protontricks
      steam
      steam-run
      superTuxKart

      # Tools
      dxvk
      protontricks
      gnome.zenity
      dotnet-sdk

      # Overlay & Post-Processing
      mangohud
      vkBasalt
    ];
  };
}
