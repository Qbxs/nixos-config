{ pkgs, ... }:

{
  imports = [ ./common.nix ];
  programs.git = {
    userEmail = email;
    signing = {
      gpgPath = "/run/current-system/sw/bin/gpg";
      key = "4CAB911AED307462D14E23E6B7FC7F03E3C8EE74";
      signByDefault = true;
    };
  };
}
