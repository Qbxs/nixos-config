{ pkgs, ... }:

{
  imports = [ ./common.nix ];
  programs.git = {
    userEmail = "engel@itestra.com";
    signing = {
      gpgPath = "/run/current-system/sw/bin/gpg";
      key = "316B3057427BB2B9CDBF8DF95BC89F7EC068CBCF";
      signByDefault = true;
    };
  };
}
