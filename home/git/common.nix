{ pkgs, ... }:

let
  real-name = "Pascal Engel";
  email = "pascalengel@posteo.de";
in
{
  programs.git = {
    enable = true;
    userName = real-name;
    userEmail = email;
    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = true;
      pull.rebase = false;
      tag.ForceSignAnnotated = true;
    };
  };
}
