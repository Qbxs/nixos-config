{
  description = "Flake for nixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    # for frequent updates, only update this input:
    nixpkgs-newest.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-newest, nixpkgs-unstable, home-manager, nix-doom-emacs, nixos-hardware }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-newest = import nixpkgs-newest {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-newest pkgs-unstable;
          defaultShell = "zsh";
        };
        modules = with nixos-hardware.nixosModules; [
          common-pc
          common-pc-hdd
          common-pc-ssd
          common-cpu-amd
          common-gpu-nvidia-nonprime
          ./configuration.nix
          nixpkgs.nixosModules.notDetected
          home-manager.nixosModules.home-manager
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

