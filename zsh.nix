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
      # emacs = "emacsclient -c";
      ll = "ls -la";
      "." ="cd ..";
      ".." = "cd ../..";
      "..." = "cd ../../..";
      "...." = "cd ../../../..";
      e = ''emacsclient -c'';
      nix-shell = ''nix-shell --run zsh'';
    };
    shellInit = ''
        export PATH=/home/pascal/.local/bin:$PATH
      '';
  };
}
