{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "vi-mode"
        "per-directory-history"
        "pass"
      ];
    };
    shellAliases = {
      ll = "ls -la";
      "." = "cd ..";
      ".." = "cd ../..";
      "..." = "cd ../../..";
      "...." = "cd ../../../..";
      emacs = ''emacsclient -c -a "emacs"'';
      nix-shell = ''nix-shell --run zsh'';
      nixos-config = ''code ~/nixos-config/.'';
    };
    initExtra = ''
      # Display $1 in terminal title.
      function set-term-title() {
        emulate -L zsh
        if [[ -t 1 ]]; then
          print -rn -- $'\e]0;'${"$"}{(V)1}$'\a'
        elif [[ -w $TTY ]]; then
          print -rn -- $'\e]0;'${"$"}{(V)1}$'\a' >$TTY
        fi
      }
      # When a command is running, display it in the terminal title.
      function set-term-title-preexec() {
        if (( P9K_SSH )); then
          set-term-title ''${(V%):-"%n@%m: "}$1
        else
          set-term-title $1
        fi
      }
      # When no command is running, display the current directory in the terminal title.
      function set-term-title-precmd() {
        if (( P9K_SSH )); then
          set-term-title ''${(V%):-"%n@%m: %~"}
        else
          set-term-title ''${(V%):-"%~"}
        fi
      }
    '';
  };
}
