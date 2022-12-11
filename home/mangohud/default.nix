{ pkgs, ... }:

{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      toggle_hud = "Shift_R+F12";
      vram = true;
      ram = true;
      gamemode = true;
      vkbasalt = true;
      no_display = true;
    };
  };
}
