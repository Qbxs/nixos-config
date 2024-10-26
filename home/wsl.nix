{
  inputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  home-manager,
  ...
}:

{
  imports = [ ./common.nix ];

  home-manager.users.pascal = {
    imports = [ ./git/wsl.nix ];
  };
}
