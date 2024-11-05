{ pkgs, ... }:

let
  email = "pascalengel@posteo.de";
in
{
  imports = [ ./common.nix ];
  programs.git = {
    userEmail = email;
    signing.key = "4CAB911AED307462D14E23E6B7FC7F03E3C8EE74";
  };
}
