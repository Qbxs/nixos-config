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

      nixpkgs.config.allowUnfree = true;

      home = {
        stateVersion = "22.05";

        packages = with pkgs; [
          # Terminal
          starship
          fastfetch
        ];
      };

    };
  };

}
