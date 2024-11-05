{ ... }:

{
  imports = [ ./common.nix ];

  home-manager.users.pascal = {
    imports = [ ./git/wsl.nix ];
  };
}
