{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      dynamic_padding = true;
      opacity = 0.85;
      size = 8;
    };
  };
}
