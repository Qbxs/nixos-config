{
  description = "Flake for nixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    # for frequent updates, only update this input:
    nixpkgs-newest.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-newest, home-manager, nixos-hardware }: 
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
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-newest;
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
        ];
      };
    };
  }

