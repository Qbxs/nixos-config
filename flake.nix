{
  inputs = {
    nix-pkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    agenix.url = "github:ryantm/agenix";
  };
  outputs = { self, nix-pkgs, home-manager, agenix }: {
    nixosConfigurations.pascal-nixos = nix-pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # specialArgs = {
      #   inherit pkgs pkgs-unstable agenix;
      #   pkgs-master = mkPkgs (import nixpkgs-master) [ ];
      #   defaultShell = "zsh";
      # };
      modules = [
        nix-pkgs.nixosModules.notDetected
        home-manager.nixosModules.home-manager
        ./configuration.nix
        agenix.nixosModules.age
      ];
    };
  };
}
