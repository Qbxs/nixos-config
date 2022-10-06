{ config, pkgs, home-manager, ... }:

let
  real-name = "Pascal Engel";
  email = "ip4ssi@gmail.com";
in
{
  # imports = [ (import "${home-manager}/nixos") ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.pascal = {
    home.stateVersion = "22.05";
    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    nixpkgs.config.allowUnfree = true;

    systemd.user.services.mpris-proxy = {
      Unit.Description = "Mpris proxy";
      Unit.After = [ "network.target" "sound.target" ];
      Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      Install.WantedBy = [ "default.target" ];
    };

    # Enable emacs server
    services.emacs.enable = true;

    programs = {
      git = {
        enable = true;
        userName = real-name;
        userEmail = email;
        signing = {
          gpgPath = "/run/current-system/sw/bin/gpg";
          key = "3FFB5E924B624E438AA13488FDE0094719249572";
          signByDefault = true;
        };
        extraConfig = {
          color.ui = "auto";
          commit.gpgsign = true;
          pull.rebase = false;
          tag.ForceSignAnnotated = true;
        };
      };
      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          arcticicestudio.nord-visual-studio-code
          james-yu.latex-workshop
          yzhang.markdown-all-in-one
          haskell.haskell
          bbenoist.nix
        ];
      };
    };
  };
}
