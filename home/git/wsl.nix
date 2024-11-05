{ pkgs, ... }:

{
  imports = [ ./common.nix ];
  programs.git = {
    userEmail = "engel@itestra.de";
    signing.key = "316B3057427BB2B9CDBF8DF95BC89F7EC068CBCF";
  };
}
