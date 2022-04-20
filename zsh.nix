{ config, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    # syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "vi-mode" "per-directory-history" "pass" ];
    };
    shellAliases = {
      # emacs = "emacsclient -c";
      # ls = "ls -lh --color=auto";
      please = "sudo";
      ll = "ls -a";
      rtv = ''export BROWSER=linkopen; export EDITOR=vim; export PAGER=less;rtv'';
      vimread = "vim -RNu ~/.vimreadrc";
      randomYoutube = "mpv (shuf /var/tmp/youtubeVideos)";
      "." ="cd ..";
      ".." = "cd ../..";
      "..." = "cd ../../..";
      "...." = "cd ../../../..";
      poweroff = "closeAllWindows; poweroff";
      reboot = "closeAllWindows; reboot";
      e = ''emacsclient -c'';
      nix-shell = ''nix-shell --run zsh'';
    };
  };
}