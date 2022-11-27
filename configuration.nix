# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-newest, ... }:

# unused font, may be removed
let sf-mono = pkgs.fetchFromGitHub
  {
    owner = "johnae";
    repo = "nixos-configuration";
    rev = "0a18ecf1a1626791f69de349530a536bd6c2f646";
    sha256 = "KZgBGWHYqbdRgIZj8kn58LWgtA89a+RazXKfZsGYRxw=";
  } + "/pkgs";

in

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
      ./zsh.nix
    ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Set shorter timout for stop jobs on shutdown.
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  networking.hostName = "pascal-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.enp42s0.useDHCP = true;

  # Enable snowflake for repressed friends
  services.snowflake-proxy.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable KDE Plasma5 Desktop Enivronment
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  # security.wrappers.kcheckpass.source = "/run/wrappers/bin/kcheckpass";

  # Configure keymap in X11
  services.xserver.layout = "us,de";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "altgr-intl";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  age.secrets.pass.file = ./pass.age;
  age.identityPaths = [ "/root/.ssh/id_rsa" ];

  # Define a user account.
  users.users.pascal = {
    isNormalUser = true;
    home = "/home/pascal";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    passwordFile = config.age.secrets.pass.path;
    # "/etc/nixos/.pass.conf";
  };

  users.mutableUsers = false;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # (import ./emacs.nix { inherit pkgs; })
    (
      let
        my-python-packages = python-packages: with python-packages; [
          bottle
          psycopg2
          pygments
        ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in
      python-with-my-packages
    )
    # CLI tools
    wget
    gnumake
    gnupg
    pinentry
    gcc
    git
    idris2
    pandoc
    texlive.combined.scheme-full
    ghc
    stack
    nordic
    nixpkgs-fmt
    # GUI Apps
    pkgs-newest.discord
    firefox
    steam
    signal-desktop
    slack
    zoom-us
  ] ++
  (with haskellPackages; [
    haskell-language-server
    hlint
    hls-hlint-plugin
    brittany
    hls-brittany-plugin
  ]);

  # Enable Postgres
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_13;
  # services.postgresql.extraPlugins = [pkgs.postgresql_13.pkgs.pg_logparser];

  # Overlays
  # nixpkgs.overlays = [
  #   (_: prev: {
  #     # Include pg_extension for LogParser.
  #     postgresql_temp = prev.postgresql_13 // {
  #       pkgs = prev.postgresql_13.pkgs // {
  #         pg_logparser = prev.stdenv.mkDerivation {
  #           pname = "pg_logparser";
  #           version = "0.1";
  #           buildInputs = [ prev.postgresql_13 ];
  #           # src = /home/pascal/Documents/HowProv/PgQueryHauler/pg_extension-parse_query;
  #           src = builtins.fetchGit {
  #             url = "ssh://git@dbworld.informatik.uni-tuebingen.de:PgQueryHauler.git";
  #             rev = "78777f3157f46660fd160fb6a30368bdbd183480";
  #             ref = "master";
  #           } + "/pg_extension-parse_query";
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
  #     # Include Apple SF fonts.
  #     # san-francisco-mono-font = prev.callPackage (sf-mono+"/san-francisco-mono-font") { };
  #     # system-san-francisco-mono-font = prev.callPackage (sf-mono+"/system-san-francisco-font") { };
  #     # san-francisco-mono-font = prev.callPackage ./san-francisco-mono-font { };
  #   })
  # ];

  # fonts.fonts = with pkgs; [
  #   san-francisco-mono-font
  #   system-san-francisco-mono-font
  # ];

  # services.postgresql.extraPlugins = [ pkgs.postgresql.pkgs.pg_logparser ];
  # services.postgresql.initialScript = ''psql -c "CREATE EXTENSION parse_query"'';

  # Set ZSH shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.opengl.driSupport32Bit = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Set local time zone (for consistency with windows on the same machine)
  services.localtime.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

