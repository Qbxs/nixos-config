{ config, ... }:

{
  programs.rofi = {
    enable = true;
    catppuccin.enable = false;
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
        bg0 = mkLiteral "#313244";
        bg1 = mkLiteral "#45475a";
        bg2 = mkLiteral "#585b70";
        bg3 = mkLiteral "#fab387";
        fg0 = mkLiteral "#b4befe";
        fg1 = mkLiteral "#000000";
        fg2 = mkLiteral "#a6adc8";
        fg3 = mkLiteral "#bac2de";
      in
      {
        "configuration" = {
          modi = "drun";
          show-icons = true;
          display-drun = "❯";
          drun-display-format = "{name}";
          hover-select = true;
          me-select-entry = "";
          me-accept-entry = map mkLiteral [ "MousePrimary" "MouseSecondary" "MouseDPrimary" ];
        };
        "*" = {
          font = "Roboto 12";

          background-color = mkLiteral "transparent";
          text-color = fg0;

          margin = mkLiteral "0px";
          padding = mkLiteral "0px";
          spacing = mkLiteral "0px";
        };

        window = {
          location = mkLiteral "north";
          y-offset = mkLiteral "calc(50% - 176px)";
          width = 480;
          border-radius = mkLiteral "24px";

          background-color = bg0;
        };

        mainbox = {
          padding = mkLiteral "12px";
        };

        inputbar = {
          background-color = bg1;
          border-color = bg3;

          border = mkLiteral "2px";
          border-radius = mkLiteral "16px";

          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          children = map mkLiteral [
            "prompt"
            "entry"
          ];
        };

        prompt = {
          text-color = fg2;
        };

        entry = {
          placeholder = "Search";
          placeholder-color = fg3;
        };

        message = {
          margin = mkLiteral "12px 0 0";
          border-radius = mkLiteral "16px";
          border-color = bg2;
          background-color = bg2;
        };

        textbox = {
          padding = mkLiteral "8px 24px";
        };

        listview = {
          background-color = mkLiteral "transparent";

          margin = mkLiteral "12px 0 0";
          lines = 8;
          columns = 1;

          fixed-height = false;
        };

        element = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "8px";
          border-radius = mkLiteral "16px";
        };

        "element selected active" = {
          text-color = fg1;
        };

        "element-text selected" = {
          text-color = fg1;
          text-style = mkLiteral "bold";
        };

        "element normal active" = {
          text-color = fg1;
        };

        "element alternate active" = {
          text-color = fg1;
        };

        "element selected normal, element selected active" = {
          background-color = bg3;
        };

        element-icon = {
          size = mkLiteral "1em";
          vertical-align = mkLiteral "0.5";
        };

        element-text = {
          text-color = mkLiteral "inherit";
        };
      };
  };
}
