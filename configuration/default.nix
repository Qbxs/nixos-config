{
  config,
  nixpkgs,
  pkgs,
  pkgs-newest,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./common.nix
    # Include the results of the hardware scan.
    ../hardware-configuration.nix
    # Include the home manager configuration
    ../home/default.nix
  ];

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

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # programs.hyprland.enable = true;

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

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    setLdLibraryPath = true;
  };

  # Override nvidia drivers with unstable branch
  # boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
  # nixpkgs.config.packageOverrides = pkgs: {
  #   # Swap out all of the linux packages
  #   linuxPackages_latest = pkgs-unstable.linuxPackages_latest;
  #   # Make sure x11 will use the correct package as well
  #   nvidia_x11 = pkgs-unstable.nvidia_x11;
  # };

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # user password
  age.secrets.password.file = ../secrets/password.age;
  users.users.pascal.passwordFile = config.age.secrets.password.path;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable snowflake for repressed friends
  services.snowflake-proxy.enable = true;

  environment.variables = rec {
    XDG_CACHE_HOME = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    TERMINAL = "alacritty";
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
      vscode
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
