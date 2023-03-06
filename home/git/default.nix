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
    signing = {
      gpgPath = "/run/current-system/sw/bin/gpg";
      key = "4CAB911AED307462D14E23E6B7FC7F03E3C8EE74";
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
