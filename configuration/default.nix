{ config
, nixpkgs
, pkgs
, pkgs-newest
, hyprland
, ...
}:
let
  pkgs-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./common.nix
    ./hardware-configuration.nix
  ];

  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };

  age.identityPaths = [ "/home/pascal/.ssh/id_rsa" ];

  catppuccin.enable = true;

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking.hostName = "pascal-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # user password
  age.secrets.password.file = ../secrets/password.age;
  users.users.pascal.hashedPasswordFile = config.age.secrets.password.path;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable snowflake for repressed friends
  services.snowflake-proxy.enable = true;

  environment.variables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
    VISUAL = "vim";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [
      "${XDG_BIN_HOME}"
      "/home/pascal/.cabal/bin"
    ];
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      # clis
      idris2
      pandoc
      texlive.combined.scheme-full
      ghc
      stack
      nordic
      nixpkgs-fmt
      ntfs3g
      adwaita-icon-theme
      nautilus
      sushi
      clipboard-jh
      waybar
      hyprlock
      hyprpaper
      rofi-wayland
      wireplumber
      dunst
      playerctl
      # GUI Apps
      alacritty
      pkgs-newest.discord
      firefox
      thunderbird
      discord
      mumble
      pavucontrol
      signal-desktop
      slack
      vlc
      vscode
      zoom-us
      zathura
      obs-studio
      catppuccin-sddm
      # Python
      (
        let
          my-python-packages =
            python-packages: with python-packages; [
              bottle
              psycopg2
              pygments
            ];
          python-with-my-packages = python3.withPackages my-python-packages;
        in
        python-with-my-packages
      )
    ]
    ++
    # Haskell
    (with haskellPackages; [
      haskell-language-server
      hlint
      ormolu
    ]);


  programs.steam.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  age.secrets.wgProton.file = ../secrets/wgProton.age;
  networking.wg-quick.interfaces = {
    wgProton = {
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];
      privateKeyFile = config.age.secrets.wgProton.path;
      peers = [
        { # NL-FREE#38
          publicKey = "3H83oJvvo4pMX9Lisc1/wNPhnGXoTe6FTubLo8JknSs=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "190.2.153.215:51820";
        }
        { # JP-FREE#25
          publicKey = "FUnwfgDQWcuTC3BacXUv9hZhkNWywecdsJz2c4FZJCI=";
          allowedIPs = [ ];
          endpoint = "91.207.174.2:51820";
        }
        { # US-FREE#79
          publicKey = "igHNlAQgaI70R0w0OdWC9XR11xagXRcib1V4tPuU4RQ=";
          allowedIPs = [ ];
          endpoint = " 149.22.84.139:51820";
        }
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
