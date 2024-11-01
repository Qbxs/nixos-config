{ config
, nixpkgs
, pkgs
, pkgs-newest
, pkgs-unstable
, hyprland
, ...
}:

{
  imports = [
    ./common.nix
    ./hardware-configuration.nix
    ../home/default.nix
  ];

  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };

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

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts =  [ "FiraMono" ]; })];

  programs.steam = {
    enable = true;
    # protontricks.enable = true;
  }; 

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  boot.kernelParams = [
    "nvidia_drm.fbdev=1"
    "nvidia_drm.modeset=1"
  ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.nvidia.modesetting.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    setLdLibraryPath = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable =  true;
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
      gnome3.adwaita-icon-theme
      # GUI Apps
      alacritty
      pkgs-newest.discord
      firefox
      thunderbird
      discord
      mumble
      signal-desktop
      slack
      vlc
      zoom-us
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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
