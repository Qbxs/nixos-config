{ pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "pascal";

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  age.identityPaths = [ "/home/pascal/.ssh/id_ed25519" ];

  environment.systemPackages = with pkgs; [ docker docker-compose ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  system.stateVersion = "24.05";

}
