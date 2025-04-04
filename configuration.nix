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

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  #    --System-conf--    #
  imports = [
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
  ];

  #    --Bootloader--    #
  boot.loader = {
    timeout = 5;

    efi = {
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;

      efiSupport = true;
      efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
      devices = [ "nodev" ];
      extraEntriesBeforeNixOS = true;
    };
  };
  boot.loader.grub.extraInstallCommands = ''
    cat << EOF >> /boot/grub/grub.cfg

      # Shutdown
      menuentry "Shutdown" --class shutdown {
        halt
      }

      # Reboot
      menuentry "Reboot" --class restart{
        reboot
      }
      EOF
  '';
  boot.loader.grub2-theme = {
    enable = true;
    theme = "vimix";
    footer = true;
  };
  #    --netnetworking--    #
  networking.hostName = "damidorg-nix";
  services.gnome.gnome-keyring.enable = true; # Optional: For credential storage
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
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfersi
  };
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      theme = spicePkgs.themes.default;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
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
    jack.enable = true;

    #media-session.enable = true;
  };

  #    --user-d20--    #
  users.defaultUserShell = pkgs.fish;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", KERNEL=="wl*", GROUP="kismet", MODE="0660"
  '';
  boot.kernelModules = [
    "cfg80211"
    "mac80211"
  ];

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  users.users.damidorg = {
    isNormalUser = true;
    description = "👌";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  services.xserver.excludePackages = [
    pkgs.xterm
    pkgs.helix
  ];
  #    --tailscale--    #
  services.tailscale.enable = true;
  networking.firewall = {
    checkReversePath = "loose"; # Required for Tailscale
    trustedInterfaces = [ "tailscale0" ]; # Trust Tailscale interface
  };

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
 
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer', 'variable-refresh-rate', 'kms-modifiers']
    '';
  };
 /* environment.sessionVariables = {
    XCURSOR_THEME = "rose-pine-cursor";
    XCURSOR_PATH = [
      #  "/run/current-system/sw/share/icons"
      #  "~/.icons"
      #  "~/.local/share/icons"
      "${pkgs.rose-pine-cursor}/share/icons" # Path to your cursor package
      "$HOME/.icons"
      "/usr/share/icons"
    ];
  }; */
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
  ];

  environment.systemPackages = with pkgs; [

    #    --games--    #
    steam
    lutris
    qbittorrent
    bottles
    haguichi
    logmein-hamachi
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
    tailscale
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
    tree-sitter-grammars.tree-sitter-rust
    tree-sitter
    #    --other--    #
    cloudflare-warp
    fastfetch
    obsidian
    localsend
    libreoffice
    telegram-desktop
    discord-canary
    calibre
    vlc
    firefox
    #    --tools --    #
    ghostty
    nvitop
    obs-studio
    ciscoPacketTracer8
    pinta
    linssid
    btop-rocm
    kismet
    aircrack-ng
    pcre
    audacity
    reaper
    spicetify-cli
    jdk17
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
