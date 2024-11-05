{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
        modules-right = [ "custom/music" "wireplumber" "custom/clock" "backlight" "battery" "tray" ];
        "hyprland/workspaces" = {
          format = " ";
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
          exec = "${pkgs.playerctl}/bin/playerctl metadata --format='{{ artist }} {{ title }}'";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          max-length = 40;
        };
        "custom/clock" = {
          exec = "${pkgs.coreutils}/bin/date +'%H:%M'";
          on-hover = "${pkgs.coreutils}/bin/date +'%H:%M, %A, %d.%m.%Y'";
          interval = 5;
          format = "  {}";
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
        wireplumber = {
          scroll-step = 1;
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = [ "" "" " " ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-middle = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0.5s; ${pkgs.hyprlock}/bin/hyprlock)' & disown";
          format = "";
        };
        "custom/power" = {
          tooltip = false;
          on-click = "${pkgs.wlogout}/bin/wlogout &";
          format = "⏻";
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
        margin-right: 1rem;
      }

      #workspaces button {
        color: @peach;
        border-radius: 1rem;
      }

      #workspaces button.active {
        color: @peach;
        border-radius: 1rem;
        font-weight: bold;
      }

      #workspaces button:hover {
        color: @peach;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #custom-clock,
      #battery,
      #wireplumber,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }

      #custom-clock {
        color: @lavender;
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

      #wireplumber {
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
