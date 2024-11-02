{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    catppuccin.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "custom/music" "pulseaudio" "clock" "backlight" "battery" "tray" "custom/lock" "custom/power" ];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        "custom/music" = {
          format = "  {}";
          escape = true;
          interval = 5;
          tooltip = false;
          exec = "${pkgs.playerctl}/bin/playerctrl metadata --format='{{ title }}'";
          on-click = "${pkgs.playerctl}/bin/playerctrl play-pause";
          max-length = 50;
        };
        clock = {
          timezone = "Europe/Berlin";
          tooltip-format = "<big>{=%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = " {=%d/%m/%Y}";
          format = " {=%H=%M}";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "";
          format-plugged = "";
          format-alt = "{icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" "" "" ];
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [ "" "" " " ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0.5s; ${pkgs.hyprlock}/bin/hyprlock)' & disown";
          format = "";
        };
        "custom/power" = {
          tooltip = false;
          on-click = "${pkgs.wlogout}/bin/wlogout &";
          format = "襤";
        };
      };
    };
  };
}
