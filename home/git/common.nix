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
    settings = {
      color.ui = "auto";
      commit.gpgsign = true;
      pull.rebase = true;
      tag.ForceSignAnnotated = false;
    };
  };
}
