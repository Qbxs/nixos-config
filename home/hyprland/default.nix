{ pkgs, config, ... }:

let
  wallpaper = "~/Pictures/wallpaper.png";
in
{
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  wayland.windowManager.hyprland = {
    enable = true; # TODO use package from flake
    xwayland.enable = true;
    catppuccin.enable = true;
    systemd.variables = [ "--all" ];
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "${pkgs.alacritty}/bin/alacritty";
      "$fileManager" = "${pkgs.gnome.nautilus}/bin/nautilus";
      "$menu" = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
      "$playerctl" = "${pkgs.playerctl}/bin/playerctl";
      "$wpctl" = "${pkgs.wireplumber}/bin/wpctl";
      exec-once = [
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.clipboard-jh}/bin/cb"
        "${pkgs.dunst}/bin/dunst"
        "systemctl --user start hyprpolkitagent"
      ];
      bind =
        [
          "$mod, F, exec, ${pkgs.firefox}/bin/firefox"
          "$mod, T, exec, $terminal"
          "$mod, C, killactive"
          "$mod, Q, exec, hyprlock"
          "$mod, W, exit"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating"
          "ALT, space, exec, $menu"
          "$mod, S, togglesplit"
          ", Print, exec, grimblast copy area"
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          "$mod, Tab, workspace, m+1"
          "$mod SHIFT, Tab, workspace, m-1"
        ]
        ++ (builtins.concatLists (
          builtins.genList
            (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
        ));
      bindel = [
        " , XF86AudioRaiseVolume, exec, $wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        " , XF86AudioLowerVolume, exec, $wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindl = [
        " , XF86AudioMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        " , XF86AudioPlay, exec, $playerctl play-pause"
        " , XF86AudioPrev, exec, $playerctl previous"
        " , XF86AudioNext, exec, $playerctl next"
      ];
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    catppuccin.enable = true;
    # settings = {
    #   general = {
    #     disable_loading_bar = true;
    #     grace = 300;
    #     hide_cursor = true;
    #     no_fade_in = false;
    #   };

    #   background = [
    #     {
    #       path = wallpaper;
    #       blur_passes = 3;
    #       blur_size = 8;
    #     }
    #   ];

    #   input-field = [
    #     {
    #       size = "200, 50";
    #       position = "0, -80";
    #       monitor = "";
    #       dots_center = true;
    #       fade_on_empty = false;
    #       font_color = "rgb(202, 211, 245)";
    #       inner_color = "rgb(91, 96, 120)";
    #       outer_color = "rgb(24, 25, 38)";
    #       outline_thickness = 5;
    #       # placeholder_text = '\'<span foreground="##cad3f5">Password...</span>'\';
    #       shadow_passes = 2;
    #     }
    #   ];
    # };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ wallpaper ];
      wallpaper = [ " , ${wallpaper}" ];
    };
  };

  programs.rofi = {
    enable = true;
    # theme =
    #   let
    #     inherit (config.lib.formats.rasi) mkLiteral;
    #     bg0 = mkLiteral "#212121F2";
    #     bg1 = mkLiteral "#2A2A2A";
    #     bg2 = mkLiteral "#3D3D3D80";
    #     bg3 = mkLiteral "#F57C00F2";
    #     fg0 = mkLiteral "#E6E6E6";
    #     fg1 = mkLiteral "#FFFFFF";
    #     fg2 = mkLiteral "#969696";
    #     fg3 = mkLiteral "#3D3D3D";
    #   in
    #   {
    #     "configuration" = {
    #       modi = "drun";
    #       show-icons = true;
    #       display-drun = "❯";
    #       drun-display-format = "{name}";
    #       hover-select = true;
    #       me-select-entry = "";
    #       me-accept-entry = map mkLiteral [ "MousePrimary" "MouseSecondary" "MouseDPrimary" ];
    #     };
    #     "*" = {
    #       font = "Roboto 12";

    #       background-color = mkLiteral "transparent";
    #       text-color = fg0;

    #       margin = mkLiteral "0px";
    #       padding = mkLiteral "0px";
    #       spacing = mkLiteral "0px";
    #     };

    #     window = {
    #       location = mkLiteral "north";
    #       y-offset = mkLiteral "calc(50% - 176px)";
    #       width = 480;
    #       border-radius = mkLiteral "24px";

    #       background-color = bg0;
    #     };

    #     mainbox = {
    #       padding = mkLiteral "12px";
    #     };

    #     inputbar = {
    #       background-color = bg1;
    #       border-color = bg3;

    #       border = mkLiteral "2px";
    #       border-radius = mkLiteral "16px";

    #       padding = mkLiteral "8px 16px";
    #       spacing = mkLiteral "8px";
    #       children = map mkLiteral [
    #         "prompt"
    #         "entry"
    #       ];
    #     };

    #     prompt = {
    #       text-color = fg2;
    #     };

    #     entry = {
    #       placeholder = "Search";
    #       placeholder-color = fg3;
    #     };

    #     message = {
    #       margin = mkLiteral "12px 0 0";
    #       border-radius = mkLiteral "16px";
    #       border-color = bg2;
    #       background-color = bg2;
    #     };

    #     textbox = {
    #       padding = mkLiteral "8px 24px";
    #     };

    #     listview = {
    #       background-color = mkLiteral "transparent";

    #       margin = mkLiteral "12px 0 0";
    #       lines = 8;
    #       columns = 1;

    #       fixed-height = false;
    #     };

    #     element = {
    #       padding = mkLiteral "8px 16px";
    #       spacing = mkLiteral "8px";
    #       border-radius = mkLiteral "16px";
    #     };

    #     "element normal active" = {
    #       text-color = bg3;
    #     };

    #     "element alternate active" = {
    #       text-color = bg3;
    #     };

    #     "element selected normal, element selected active" = {
    #       background-color = bg3;
    #     };

    #     element-icon = {
    #       size = mkLiteral "1em";
    #       vertical-align = mkLiteral "0.5";
    #     };

    #     element-text = {
    #       text-color = mkLiteral "inherit";
    #     };
    #   };
  };

  # home.pointerCursor = {
  #   gtk.enable = true;
  #   # x11.enable = true;
  #   package = pkgs.bibata-cursors;
  #   name = "Bibata-Modern-Classic";
  #   size = 16;
  # };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      accent = "peach";
      flavor = "mocha";
      icon = {
        enable = true;
        accent = "peach";
        flavor = "mocha";
      };
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
