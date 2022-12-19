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
      key = "3FFB5E924B624E438AA13488FDE0094719249572";
      signByDefault = false;
    };
    extraConfig = {
      color.ui = "auto";
      commit.gpgsign = false;
      pull.rebase = false;
      tag.ForceSignAnnotated = true;
    };
  };
}
