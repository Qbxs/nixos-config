{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mskelton.one-dark-theme
      james-yu.latex-workshop
      yzhang.markdown-all-in-one
      justusadam.language-haskell
      haskell.haskell
      bbenoist.nix
      brettm12345.nixfmt-vscode
      vscodevim.vim
      mkhl.direnv
    ];
  };
}
