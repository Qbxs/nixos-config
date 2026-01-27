{ pkgs
, ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkup";

    users.pascal = {

      imports = [
        # ./alacritty
        # ./starship
        ./vscode
        ./zsh
      ];

      home = {
        stateVersion = "22.05";

        packages = with pkgs; [
          # Terminal
          starship
          fastfetch
        ];
      };

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };

    };
  };

}
