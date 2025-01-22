{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "d20";
  home.homeDirectory = "/home/d20";
   home.pointerCursor = {
    gtk.enable = true;
    name = "rose-pine-cursor";
    package = pkgs.rose-pine-cursor;
    size = 32;
  };
    
   


   
    # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

    home.packages = [
      ];

    home.file = {
      };

    home.sessionVariables = {
    TERMINAL = "alacritty";
  };

   programs.home-manager.enable = true;
}
