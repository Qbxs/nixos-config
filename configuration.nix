# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  real-name = "Pascal Engel";
  email = "ip4ssi@gmail.com";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./emacs.nix
      # ./postgres.nix
      ./zsh.nix
      (import "${home-manager}/nixos")
    ];

  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # the sad part
  nixpkgs.config.allowUnfree = true;

  home-manager.users.pascal = {
    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    programs = {
      git = {
        enable = true;
        userName  = real-name;
        userEmail = email;
        extraConfig = {
          color = {
            ui = "auto";
          };
          user = {
            signingkey = "3FFB5E924B624E438AA13488FDE0094719249572";
          };
          gpg = {
            program = "/run/current-system/sw/bin/gpg2";
          };
          commit = {
            gpgsign = true;
          };
          tag = {
            ForceSignAnnotated = true;
          };
        };
      };
 #     vscode = {
 #       enable = true;
 #       extensions = with pkgs.vscode-extensions; [
 #         yzhang.markdown-all-in-one
 #         arcticicestudio.nord-visual-studio-code
 #         haskell.haskell
 #         bbenoist.nix
 #       ];
 #     };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
 
  networking.hostName = "pascal-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp34s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Enable KDE Plasma5 Desktop Enivronment
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pascal = {
    isNormalUser = true;
    home = "/home/pascal";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    passwordFile = "/etc/nixos/.pass.conf";
  };

  users.mutableUsers = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # pkgs.gnome3.gnome-tweaks
    vim
    (import ./emacs.nix { inherit pkgs; })
    wget
    gnumake
    gnupg
    gcc
    git
    ghc
    haskellPackages.haskell-language-server
    haskellPackages.hlint
    haskellPackages.hls-hlint-plugin 
    haskellPackages.brittany
    haskellPackages.hls-brittany-plugin
    stack
    pandoc
    firefox
    steam
    signal-desktop
    slack
    discord
    vscode
    nordic
  ];

  # Enable Postgres
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;

  # Set ZSH shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

