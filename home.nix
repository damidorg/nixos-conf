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
    x11.enable = true;
    name = "rose-pine-cursor";
    package = pkgs.rose-pine-cursor;
    size = 32;
  };
  programs.fish = {
    interactiveShellInit = "";
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }

    ];
  };

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [
  ];

  home.file = { };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
