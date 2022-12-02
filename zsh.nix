{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "vi-mode" "per-directory-history" "pass" ];
    };
    shellAliases = {
      ll = "ls -la";
      "." ="cd ..";
      ".." = "cd ../..";
      "..." = "cd ../../..";
      "...." = "cd ../../../..";
      emacs = ''emacsclient -c -a "emacs"'';
      nix-shell = ''nix-shell --run zsh'';
      nixos-config = ''code ~/nixos-config/.'';
      mo2 = ''STEAM_COMPAT_CLIENT_INSTALL_PATH=/usr/games/steam STEAM_COMPAT_DATA_PATH=~/.steam/steam/steamapps/compatdata/489830/ steam-run ~/.steam/steam/steamapps/common/Proton\ 7.0/proton run ~/.steam/steam/steamapps/compatdata/489830/pfx/drive_c/Modding/MO2/ModOrganizer.exe'';
    };
    shellInit = ''
        export PATH=/home/pascal/.local/bin:$PATH
        export PATH=/home/pascal/.cabal/bin/:$PATH
      '';
  };
}