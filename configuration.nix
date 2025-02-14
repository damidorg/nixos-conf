# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  #    --nvidia-driver--    #
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = true;

    powerManagement.finegrained = true;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  #    --System-conf--    #
  imports = [
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
    inputs.home-manager.nixosModules.default

  ];

  #    --Bootloader--    #
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #    --netnetworking--    #
  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;
  #    --time--    #
  time.timeZone = "Asia/Jerusalem";
  #    --language--    #
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IL";
    LC_IDENTIFICATION = "en_IL";
    LC_MEASUREMENT = "en_IL";
    LC_MONETARY = "en_IL";
    LC_NAME = "en_IL";
    LC_NUMERIC = "en_IL";
    LC_PAPER = "en_IL";
    LC_TELEPHONE = "en_IL";
    LC_TIME = "en_IL";
  };
  #    --programs-conf--    #
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicePkgs.themes.default;
      colorScheme = "default";
    };

  #    --programs.enable--    #

  # programs.firefox.enable = true;

  programs.fish.enable = true;

  environment.variables.TERMINAL = "ghostty";

  services.logmein-hamachi.enable = true;

  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  services.cloudflare-warp.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #    --user-d20--    #
  users.defaultUserShell = pkgs.fish;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  users.users.d20 = {
    isNormalUser = true;
    description = "20";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #    --games--    #
      steam
      lutris
      qbittorrent
      bottles
      haguichi
      logmein-hamachi
      prismlauncher
      #    --must-have--    #
      wget
      curl
      unzip
      git
      #    --System--    #
      rose-pine-cursor
      pavucontrol
      easyeffects
      home-manager
      dconf-editor
      gnome-tweaks
      coreutils-full
      gnome-common
      desktop-file-utils
      nh
      #    --shell--    #
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.forgit
      fishPlugins.hydro
      fzf
      fishPlugins.grc
      grc
      oh-my-fish
      #    --programing--    #
      rust-analyzer
      nixd
      evil-helix
      nixfmt-rfc-style
      clang
      lldb
      rustup
      #    --other--    #
      cloudflare-warp
      ciscoPacketTracer8
      fastfetch
      obsidian
      localsend
      libreoffice
      telegram-desktop
      pinta
      discord-canary
      obs-studio
      spicetify-cli
      ghostty
      nvitop
      calibre
      linssid
      btop
      kismet
      vlc
      firefox-beta
      #    --gnomeExtensions--    #
      gnomeExtensions.blur-my-shell
      gnomeExtensions.user-themes
      gnomeExtensions.clipboard-history
      gnomeExtensions.gsconnect
      gnomeExtensions.appindicator
      gnomeExtensions.color-picker
      gnomeExtensions.forge
      gnomeExtensions.invert-window-color
      gnomeExtensions.highlight-focus
      gnomeExtensions.tiling-assistant

    ];
  };
  services.xserver.excludePackages = [
    pkgs.xterm
    pkgs.helix
  ];

  nixpkgs.config.allowUnfree = true;

  #    --gnome-sesettings--    #
  environment.gnome.excludePackages = with pkgs; [
    orca
    evince
    # file-roller
    #geary
    #gnome-disk-utility
    seahorse
    # sushi
    # gnome-shell-extensions
    #
    # adwaita-icon-theme
    # nixos-background-info
    # gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    # gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    #baobab
    epiphany
    gnome-text-editor
    #gnome-calculator
    #gnome-calendar
    #gnome-characters
    # gnome-clocks
    #gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    gnome-weather
    # loupe
    # nautilus
    gnome-connections
    simple-scan
    #snapshot
    #totem
    yelp
    #gnome-software
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    wqy_zenhei
  ];
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'variable-refresh-rate', 'kms-modifiers']
    '';
  };

  environment.systemPackages = with pkgs; [

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
