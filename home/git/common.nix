{ pkgs, ... }:

let
  real-name = "Pascal Engel";
in
{
  programs.git = {
    enable = true;
    userName = real-name;
    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = true;
      pull.rebase = false;
      tag.ForceSignAnnotated = true;
    };
  };
}
