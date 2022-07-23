{ config, pkgs, home-manager, ... }:

let
  real-name = "Pascal Engel";
  email = "ip4ssi@gmail.com";
in
{
  # imports = [ (import "${home-manager}/nixos") ];

  home-manager.users.pascal = {
    home.stateVersion = "22.05";
    /* Here goes your home-manager config, eg home.packages = [ pkgs.foo ]; */
    nixpkgs.config.allowUnfree = true;

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
      emacs = {
        enable = true;
        extraPackages = epkgs: with epkgs; [
          zerodark-theme
          nix-mode
          nixos-options
          company-nixos-options
          haskell-mode
          flycheck
          elpy
          py-autopep8
          evil
          yasnippet
          ess
        ];
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
