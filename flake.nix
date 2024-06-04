{
  description = "Flake for nixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # for frequent updates, only update this input:
    nixpkgs-newest.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-newest, nixpkgs-unstable, home-manager, nix-doom-emacs, nixos-hardware }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # overlays = [
        #   (_: prev: {
        #     # Include pg_extension for LogParser.
        #     postgresql_13 = prev.postgresql_13 // {
        #       pkgs = prev.postgresql_13.pkgs // {
        #         pg_logparser = prev.stdenv.mkDerivation {
        #           pname = "pg_logparser";
        #           version = "0.1";
        #           buildInputs = [ prev.postgresql_13 ];
        #           src = /home/pascal/Documents/HowProv/PgQueryHauler/pg_extension-parse_query;
        #           # src = builtins.fetchGit {
        #           #   url = "ssh://git@dbworld.informatik.uni-tuebingen.de:PgQueryHauler.git";
        #           #   rev = "78777f3157f46660fd160fb6a30368bdbd183480";
        #           #   ref = "master";
        #           # } + "/pg_extension-parse_query";
        #           preBuild = ''
        #             export DESTDIR=$out
        #           '';
        #           installPhase = ''
        #             mkdir -p $out/bin
        #             mkdir -p $out/{lib,share/postgresql/extension}
        #             cp *.so      $out/lib
        #             cp *.sql     $out/share/postgresql/extension
        #             cp *.control $out/share/postgresql/extension
        #           '';
        #         };
        #       };
        #     };
        #   })
        # ];
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
          inherit nixpkgs pkgs pkgs-newest pkgs-unstable;
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
            home-manager.users.pascal = { pkgs, config, ... }: {
              imports = [ nix-doom-emacs.hmModule ];
              programs.doom-emacs = {
                enable = true;
                doomPrivateDir = ./doom.d;
              };
              xdg = {
                enable = true;
                configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
              };
              home.sessionVariables.NIX_PATH =
                "nixpkgs=${config.xdg.configHome}/nix/inputs/nixpkgs\${NIX_PATH:+:$NIX_PATH}";
              nix.registry.nixpkgs.flake = nixpkgs;
            };
            nix = {
              registry.nixpkgs.flake = nixpkgs;
              nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
            };
          }
        ];
      };
    };
}

