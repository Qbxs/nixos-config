{ config
, pkgs
, agenix
, ...
}:

{
  age.secrets.github-token.file = ../secrets/github-token.age;
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      auto-optimise-store = true;
    };
    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      !include ${config.age.secrets.github-token.path}
    '';
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    zsh.enable = true;
  };

  fonts.packages = with pkgs; with nerd-fonts; [ fantasque-sans-mono fira-mono ];

  services = {
    openssh.enable = true;
    pcscd.enable = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "de_DE.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.utf8";
      LC_IDENTIFICATION = "de_DE.utf8";
      LC_MEASUREMENT = "de_DE.utf8";
      LC_MONETARY = "de_DE.utf8";
      LC_NAME = "de_DE.utf8";
      LC_NUMERIC = "de_DE.utf8";
      LC_PAPER = "de_DE.utf8";
      LC_TELEPHONE = "de_DE.utf8";
      LC_TIME = "de_DE.utf8";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # clis
      zsh-nix-shell
      vim
      wget
      gnumake
      gnupg
      pinentry
      git
      ripgrep
      fd
      nixfmt-rfc-style
      nixd
      unzip
      unrar
      p7zip
      agenix.packages.${system}.default
    ];
    variables = {
      EDITOR = "vim";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pascal = {
    isNormalUser = true;
    description = "Pascal";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
  };



}
