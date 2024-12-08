{ pkgs
, catppuccin
, ...
}:

{
  imports = [
    ./common.nix
  ];

  home-manager.users.pascal = {

    imports = [
      catppuccin.homeManagerModules.catppuccin
      ./hyprland
      ./waybar
      ./rofi
      ./gtk
      ./git
      ./mangohud
      ./scripts
    ];

    home.packages = with pkgs; [
      # Launchers & Tools
      gamemode
      lutris
      wine
      dxvk
      zenity

      # Games
      prismlauncher
      superTuxKart

      # Overlay & Post-Processing
      mangohud
      vkBasalt
    ];

    catppuccin = {
      enable = true;
      accent = "peach";
      flavor = "mocha";
    };

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [
        "network.target"
        "sound.target"
      ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    services = {
      emacs.enable = true;
      blueman-applet.enable = true;
      dunst = {
        enable = true;
        catppuccin.enable = true;
      };
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      freetube = {
        enable = true;
        catppuccin.enable = true;
      };
    };

  };

}
