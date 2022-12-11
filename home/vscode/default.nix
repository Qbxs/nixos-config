{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      james-yu.latex-workshop
      yzhang.markdown-all-in-one
      justusadam.language-haskell
      haskell.haskell
      bbenoist.nix
      brettm12345.nixfmt-vscode
      vscodevim.vim
    ];
  };
}
