{ config, pkgs, home-manager, ... }:

let
  real-name = "Pascal Engel";
  email = "pascalengel@posteo.de";
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
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [
            "vi-mode"
            "per-directory-history"
            "pass"
          ];
        };
        shellAliases = {
          ll = "ls -la";
          "." = "cd ..";
          ".." = "cd ../..";
          "..." = "cd ../../..";
          "...." = "cd ../../../..";
          emacs = ''emacsclient -c -a "emacs"'';
          nix-shell = ''nix-shell --run zsh'';
          nixos-config = ''code ~/nixos-config/.'';
        };
        initExtra = ''
          # Display $1 in terminal title.
          function set-term-title() {
            emulate -L zsh
            if [[ -t 1 ]]; then
              print -rn -- $'\e]0;'${"$"}{(V)1}$'\a'
            elif [[ -w $TTY ]]; then
              print -rn -- $'\e]0;'${"$"}{(V)1}$'\a' >$TTY
            fi
          }
          # When a command is running, display it in the terminal title.
          function set-term-title-preexec() {
            if (( P9K_SSH )); then
              set-term-title ''${(V%):-"%n@%m: "}$1
            else
              set-term-title $1
            fi
          }
          # When no command is running, display the current directory in the terminal title.
          function set-term-title-precmd() {
            if (( P9K_SSH )); then
              set-term-title ''${(V%):-"%n@%m: %~"}
            else
              set-term-title ''${(V%):-"%~"}
            fi
          }
        '';
      };

      starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          add_newline = false;
          format = "
[┌─](57)$nix_shell$directory$git_branch$git_status[](57) $cmd_duration$fill[](57)$username$hostname[](57)
[└─](57)$time[─](57)$character";
          username = {
            style_user = "bright-white";
            style_root = "bright-red bold";
            format = "[$user]($style)";
            disabled = true;
          };
          hostname = {
            style = "bright-green bold";
            format = "@[$hostname]($style)";
            ssh_only = true;
          };
          nix_shell = {
            format = "[$symbol$name]($style) ";
            symbol = "❄";
            style = "bright-purple bold";
          };
          git_branch = {
            only_attached = true;
            format = " [$symbol$branch]($style) ";
            symbol = "";
            style = "bright-yellow bold";
          };
          git_commit = {
            only_detached = true;
            format = "[±$hash]($style) ";
            style = "bright-yellow bold";
          };
          git_state = {
            style = "bright-purple bold";
          };
          git_status = {
            format = "([$all_status$ahead_behind]($style))";
            style = "bright-green bold";
          };
          directory = {
            style = "125";
            format = "[$path]($style)[$read_only]($read_only_style)";
            disabled = false;
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style = "bright-blue";
          };
          jobs = {
            style = "bright-green bold";
          };
          character = {
            success_symbol = "[❯](57)";
            error_symbol = "[✘](red)";
            vicmd_symbol = "[❯](green)";
          };
        };
      };

      git = {
        enable = true;
        userName = real-name;
        userEmail = email;
        signing = {
          gpgPath = "/run/current-system/sw/bin/gpg";
          key = "3FFB5E924B624E438AA13488FDE0094719249572";
          signByDefault = false;
        };
        extraConfig = {
          color.ui = "auto";
          commit.gpgsign = false;
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
          justusadam.language-haskell
          haskell.haskell
          bbenoist.nix
          brettm12345.nixfmt-vscode
        ];
      };

      alacritty = {
        enable = true;
        settings = {
          dynamic_padding = true;
          opacity = 0.85;
          size = 8;
        };
      };

      mangohud = {
        enable = true;
        enableSessionWide = true;
      };
    };
  };
}
