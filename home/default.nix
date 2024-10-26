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
  imports = [ ./common.nix ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.pascal = {

    imports = [
      ./vscode
      ./mangohud
      ./scripts
    ];

    home.packages = with pkgs; [
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

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [
        "network.target"
        "sound.target"
      ];
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
