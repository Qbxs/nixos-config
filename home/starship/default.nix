{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    catppuccin.enable = true;
#     settings = {
#       add_newline = false;
#       format = "
# [┌─](57)$nix_shell$directory$git_branch$git_status[](57) $cmd_duration$fill[](57)$username$hostname[](57)
# [└─](57)$time[─](57)$character";
#       username = {
#         style_user = "bright-white";
#         style_root = "bright-red bold";
#         format = "[$user]($style)";
#         disabled = true;
#       };
#       hostname = {
#         style = "bright-green bold";
#         format = "@[$hostname]($style)";
#         ssh_only = true;
#       };
#       nix_shell = {
#         format = "[$symbol$name]($style) ";
#         symbol = "❄";
#         style = "bright-purple bold";
#       };
#       git_branch = {
#         only_attached = true;
#         format = " [$symbol$branch]($style) ";
#         symbol = "";
#         style = "bright-yellow bold";
#       };
#       git_commit = {
#         only_detached = true;
#         format = "[±$hash]($style) ";
#         style = "bright-yellow bold";
#       };
#       git_state = {
#         style = "bright-purple bold";
#       };
#       git_status = {
#         format = "([$all_status$ahead_behind]($style))";
#         style = "bright-green bold";
#       };
#       directory = {
#         style = "125";
#         format = "[$path]($style)[$read_only]($read_only_style)";
#         disabled = false;
#       };
#       cmd_duration = {
#         format = "[$duration]($style) ";
#         style = "bright-blue";
#       };
#       jobs = {
#         style = "bright-green bold";
#       };
#       character = {
#         success_symbol = "[❯](57)";
#         error_symbol = "[✘](red)";
#         vicmd_symbol = "[❯](green)";
#       };
#     };
  };
}
