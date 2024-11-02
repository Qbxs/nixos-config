{ pkgs
, catppuccin
, ...
}:

{
  imports = [
    ./common.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.pascal = {

    imports = [
      catppuccin.homeManagerModules.catppuccin
      ./hyprland
      ./waybar
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
      gnome.zenity

      # Games
      prismlauncher
      superTuxKart

      # Overlay & Post-Processing
      mangohud
      vkBasalt
    ];

    catppuccin = {
      enable  = true;
      accent = "peach";
      flavor = "mocha";
    };

    programs.freetube = {
      enable = true;
      catppuccin.enable = true;
    };

    programs.waybar = {
      enable = true;
      catppuccin.enable = true;
    };
    services.dunst = {
      enable = true;
      catppuccin.enable = true;
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

    # Enable emacs server
    services.emacs.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

}
