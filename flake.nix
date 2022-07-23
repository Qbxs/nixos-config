let ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAqIyRbxrEAWwXj40Ie8DGeqDeLHKlDCkMhLmFs/y3KoXKiLj42e/JOIeE+as0P7xDG4KZY4nf8LjxL4V2TsnHSACLa6lewG4Gs6scrZdn0iI6Z2oHOAknLnzObiga62ux6FxnZ0QvRI8Nf132B50l78TGNi/kXRuS8PoiXWLw5HeXseDV4PK4gzRQEObbDZkMv+gY0jNuQJHM5lHbNjx1OM9rMDyzB8CwAC5AL2O2Y9hVDNgeXAlLRULd3mJNEwYFjN9mKp5Wq6g2K7Cs2fZlG4L4svLK/dQOKnngpPOtIEzj4fxzd6t+gTEMOWsFp7Kv+CA1CjE6RWmMMzUFAyCH10LgJ+wdXNo+plktPik2Vrmh35i/EBkBDDh8qUEo6I6DQC2scdM9Qr8bEULkfM+ODV5PnxUIuuIT83AnyZ0qAPaHcbRLspm374vrg4MoWZBp+P15AMc795wa3OxdidUvgA6UX5Ndp3IlOiG3flkhGqukEgJjBSNGbGQ2UW0r9i73lxGmcLfT8k+gC6a9EgJYbO6yFwtsUYqh5aVIdn68Xcbn/Ym6iUfzDIv7hXa0dgykPap6V1LWo/K7ABd/8GQDhzM7IRUAjNKy28b2aymUjsMNTFeZme/c0w+gNAWrzYaHwfmk7bJYfl88fEkPn1dkxqjLO4d6dmUZnygvXZIgtQ== ip4ssi@gmail.com";

in

{
  inputs = {
    nix-pkgs.src.url = "github:NixOS/nixpkgs/nixos-22.05";
    home-managersrc.url = "github:nix-community/home-manager/release-22.05";
    agenix.url = "github:ryantm/agenix";
  };
  outputs = { self, nix-pkgs, home-manager }: {
    nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
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
  }
    }
