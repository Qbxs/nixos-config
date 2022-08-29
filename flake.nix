{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs?rev=d17a56d90ecbd1b8fc908d49598fb854ef188461";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    agenix.url = "github:ryantm/agenix";
    emacs-overlay.url = "github:nix-community/emacs-overlay?rev=e007354fcc0f492878d85b85334ab3baa08a273b";
    doom-emacs = {
      url = "github:hlissner/doom-emacs?rev=35865ef5e89442e3809b8095199977053dd4210f";
      flake = false;
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs?rev=6860a32b4bb158db85371efd7df0fe35ebcecb9b";
      inputs = {
        doom-emacs.follows = "doom-emacs";
        nixpkgs.follows = "nixpkgs-old";
        emacs-overlay.follows = "emacs-overlay";
      };
    };
  };
  outputs = { self, nixpkgs, nixpkgs-old, home-manager, agenix, emacs-overlay, doom-emacs, nix-doom-emacs }: {
    nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nixpkgs.nixosModules.notDetected
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        {
          home-manager.users.pascal = { pkgs, ... }: {
            imports = [ nix-doom-emacs.hmModule ];
            programs.doom-emacs = {
              enable = true;
              doomPrivateDir = ./doom.d;
            };
          };
        }
      ];
    };
  };
}
