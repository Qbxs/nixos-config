let
  wsl_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGAHcqar+k/8/K1bSQ3TqZtenUSZjW9lWWA4lfx1oSM pascal@nixos";
  # TODO add desktop key and encrypted password
in
{
  "github-token.age".publicKeys = [ wsl_key ];
}
