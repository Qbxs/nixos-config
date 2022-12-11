{ pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings.toggle_hud = "Shift_R+F12";
  };
}
