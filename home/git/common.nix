{ pkgs, ... }:

let
  real-name = "Pascal Engel";
in
{
  programs.git = {
    enable = true;
    userName = real-name;
    signing = {
      signer = "${pkgs.gnupg}/bin/gpg";
      signByDefault = true;
    };
    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = true;
      pull.rebase = false;
      tag.ForceSignAnnotated = true;
    };
  };
}
