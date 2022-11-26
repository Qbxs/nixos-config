{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    # for frequent updates, only update this input
    nixpkgs-newest.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs?rev=d17a56d90ecbd1b8fc908d49598fb854ef188461";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
  outputs = { self, nixpkgs, nixpkgs-newest, nixpkgs-old, home-manager, agenix, emacs-overlay, doom-emacs, nix-doom-emacs }:
    let
      system = "x86_64-linux";
      mkPkgs = pkgs: pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
(_: prev: { 
      # Include pg_extension for LogParser.
      postgresql_13 = prev.postgresql_13 // {
        pkgs = prev.postgresql_13.pkgs // {
          pg_logparser = prev.stdenv.mkDerivation {
            pname = "pg_logparser";
            version = "0.1";
            buildInputs = [ prev.postgresql_13 ];
            src = /home/pascal/Documents/HowProv/PgQueryHauler/pg_extension-parse_query;
            # src = builtins.fetchGit {
            #   url = "ssh://git@dbworld.informatik.uni-tuebingen.de:PgQueryHauler.git";
            #   rev = "78777f3157f46660fd160fb6a30368bdbd183480";
            #   ref = "master";
            # } + "/pg_extension-parse_query";
            preBuild = ''
              export DESTDIR=$out
            '';
            installPhase = ''
              mkdir -p $out/bin
              mkdir -p $out/{lib,share/postgresql/extension}
              cp *.so      $out/lib
              cp *.sql     $out/share/postgresql/extension
              cp *.control $out/share/postgresql/extension
            '';
          };
        };
      };
      # Include Apple SF fonts.
      # san-francisco-mono-font = prev.callPackage (sf-mono+"/san-francisco-mono-font") { };
      # system-san-francisco-mono-font = prev.callPackage (sf-mono+"/system-san-francisco-font") { };
      # san-francisco-mono-font = prev.callPackage ./san-francisco-mono-font { };
    })
];

      };
      pkgs = mkPkgs (import nixpkgs);
      pkgs-newest = mkPkgs (import nixpkgs-newest);

      lib = nixpkgs.lib;

    in
    {
      # homeManagerConfiguration = {
      #   pascal = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "pascal";
      #     homeDirectory = "/home/pascal";
      #     configuration = {
      #       imports = [ 
      #         ./home.nix
      #       ];
      #     };
      #   };
      # };


      nixosConfigurations.pascal-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs pkgs-newest agenix;
          defaultShell = "zsh";
        };
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
