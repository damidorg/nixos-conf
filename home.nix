{ config, pkgs, ... }:

{
  
  home.username = "d20";
  home.homeDirectory = "/home/d20";
  programs.git = {
    enable = true;
    userName = "damidorg";
    userEmail = "andigo1316@gmail.com";
  };
  home.pointerCursor = {
    gtk.enable = true;
    name = "rose-pine-cursor";
    package = pkgs.rose-pine-cursor;
    size = 32;
  };
    home.stateVersion = "24.11"; # Please read the comment before changing.

    home.packages = [
    ];

    home.file = {
    };

    home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
