{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    catppuccin = {
      enable = true;
      mode = "prependImport";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "custom/power" "custom/lock" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "custom/music" "pulseaudio" "clock" "backlight" "battery" "tray" ];
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
    style = ''
      * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 16px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0.4rem;
      }

      #workspaces button.active {
        color: @red;
        border-radius: 1rem;
        font-weight: bold;
      }

      #workspaces button:hover {
        color: @red;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }

      #clock {
        color: @blue;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #battery {
          border-radius: 0;
      }

      #pulseaudio {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #custom-music {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
          border-radius: 0px 1rem 1rem 0px;
          color: @lavender;
      }

      #custom-power {
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 1rem;
          color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }

    '';
  };
}
