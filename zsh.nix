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
      emacs = ''emacsclient -c'';
      nix-shell = ''nix-shell --run zsh'';
      nixos-config = ''code /etc/nixos/configuration.nix'';
    };
    shellInit = ''
        export PATH=/home/pascal/.local/bin:$PATH
        export PATH=/home/pascal/.cabal/bin/:$PATH
      '';
  };
}
