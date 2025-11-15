{
  description = "Flake for nixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # for frequent updates, only update this input:
    nixpkgs-newest.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    # nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    agenix.url = "github:ryantm/agenix";
    hyprland.url = "github:hyprwm/Hyprland";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-newest
    , nixpkgs-unstable
    , home-manager
    , nixos-hardware
    , nixos-wsl
    , agenix
    , hyprland
    , catppuccin
    ,
    }:
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
    in
    {
      nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            nixpkgs
            pkgs
            pkgs-newest
            pkgs-unstable
            agenix
            hyprland
            catppuccin
            ;
          defaultShell = "zsh";
        };
        modules = (with nixos-hardware.nixosModules; [
          common-pc
          common-pc-ssd
          common-cpu-amd
          common-gpu-amd
        ]) ++ [
          ./configuration/default.nix
          ./home/default.nix
          nixpkgs.nixosModules.notDetected
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          {
            home-manager.users.pascal =
              { config, ... }:
              {
                # imports = [ nix-doom-emacs.hmModule ];
                # programs.doom-emacs = {
                #   enable = true;
                #   doomPrivateDir = ./doom.d;
                # };
                xdg = {
                  enable = true;
                  configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
                };
                home.sessionVariables.NIX_PATH = "nixpkgs=${config.xdg.configHome}/nix/inputs/nixpkgs\${NIX_PATH:+:$NIX_PATH}";
                nix.registry.nixpkgs.flake = nixpkgs;
              };

          }
        ];
      };
      nixosConfigurations.wsl-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            nixpkgs
            pkgs
            pkgs-newest
            pkgs-unstable
            agenix
            catppuccin
            ;
          defaultShell = "zsh";
        };
        modules = [
          nixos-wsl.nixosModules.default
          ./configuration/wsl.nix
          ./home/wsl.nix
          nixpkgs.nixosModules.notDetected
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
