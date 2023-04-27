{ config, pkgs, lib, ... }:

with lib;
with builtins;

let
  nurTarball = builtins.fetchTarball {
    # Commit from master branch (Sep-18-2020)
    # To update: replace the commit with the latest one from https://github.com/nix-community/NUR/
    url = "https://github.com/nix-community/NUR/archive/d4620041b6083df6673553a0b7112146c133cbe1.tar.gz";
    sha256 = "1gbwb4n2ijgr89fqc1wwp6f07f7dkmxwgf3fygnjkj7ch21kjgpq";

  };

  unstableTarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
    sha256 = "0093drxn7blw4hay41zbqzz1vhldil5sa5p0mwaqy5dn08yn4y3q";
  };

in
{
  system.stateVersion = "20.03";

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import nurTarball {
        inherit pkgs;
      };

      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  networking.hostName = "hades";

  # This includes support for suspend-to-RAM and power-save features on laptops.
  powerManagement = {
    enable = true;
  };

  # https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
  services.tlp = {
    enable = true;
    # Example: https://gist.github.com/pauloromeira/787c75d83777098453f5c2ed7eafa42a
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=70
      STOP_CHARGE_THRESH_BAT0=85
    '';
  };

  services.logind.extraConfig = ''
    # Controls how logind shall handle the system power and sleep keys.
    HandlePowerKey=suspend
  '';

  networking.wireless = {
    enable = true;
    # wpa_passphrase ESSID PSK
    networks = {
      # HOME
      "MOVISTAR_8348" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };
      "MOVISTAR_8348_Extender" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };
      # SECOND HOME
      "Arlandiswifi-5G" = {
        pskRaw = "656f0d41f49450feeddeb8a475586c6a91998a559bd1fd6d37f1c808e33f49af";
      };
      # CALAFAT
      "MOVISTAR_7B1B" = {
        pskRaw = "6a1d731b3e07251fed01072b0e2d088c5f2388442b0a30745164dbc2e4069946";
      };
      # UNIVERSITY
      # TODO password should be encrypted
       "eduroam" = {
        auth = ''
          ssid="eduroam"
          key_mgmt=WPA-EAP
          eap=TTLS
          group=CCMP
          phase2="auth=PAP"
          anonymous_identity="anonymous@upc.edu"
          identity="arnau.abella"
          password=""
          ca_cert="/etc/nixos/upc_eduroam.crt"
          priority=10
        '';
      };
      # TODO wpa broken??
      # ANDROID HOT-SPOT
      #"Monad" = {
        #pskRaw = "00b2a451d1f5658f910b65dc3bac3dd949c62194e8179dbe08ae090aaca7ff6";
      #};
    };
    extraConfig = ''
      ctrl_interface=/run/wpa_supplicant
      ctrl_interface_group=wheel
    '';
  };

  hardware = {
    trackpoint.enable = true;
    trackpoint.emulateWheel = true; # While holding middle button
    trackpoint.speed = 97; # Kernel default
    trackpoint.sensitivity = 128; # Kernel default
  };

  # https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true; # GUI for bluetooth

  # https://nixos.wiki/wiki/ALSA
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Touchpad
  services.xserver.libinput = {
    enable = true;
    tapping = false;
    middleEmulation = false;
    additionalOptions = ''
      Option "AccelSpeed" "0.3"        # Mouse sensivity
      Option "TapButton2" "0"          # Disable two finger tap
      Option "VertScrollDelta" "-180"  # scroll sensitivity
      Option "HorizScrollDelta" "-180"
      Option "FingerLow" "40"          # when finger pressure drops below this value, the driver counts it as a release.
      Option "FingerHigh" "70"
    '';
  };

  imports = [ <home-manager/nixos> ];

  # Use the latest kernel - This solver suspend and bright issue.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.cleanTmpDir = true;

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  location.latitude = 41.3828939;
  location.longitude = 2.1774322;

  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };

  services.autorandr.enable = true;

  # https://rycee.gitlab.io/home-manager/
  home-manager.users.arnau = import ./home.nix { inherit pkgs config lib; };

  services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf ];

  # Only keep the last 500MiB of systemd journal.
  services.journald.extraConfig = "SystemMaxUse=500M";

  nix = {
    # Collect nix store garbage and optimise daily.
    gc.automatic = true;
    optimise.automatic = true;

    trustedUsers = [ "root" "arnau" ];

    # Cachix works but not using `nix-build`
    # You can test it by calling:
    #   $ nix-build -E '(import <nixpkgs> {}).writeText "example" (builtins.toString 2)' | cachix push monadplus
    #   $ rm -r result && nix-store --delete /nix/store/ah0c4mb6qixs6jyc10mdgpf3qn2s14iy-example
    #   $ nix-store --realise /nix/store/ah0c4mb6qixs6jyc10mdgpf3qn2s14iy-example
    # TODO missing keys
    binaryCaches = [
      "https://monadplus.cachix.org"
    ];

    binaryCachePublicKeys = [
      "monadplus.cachix.org-1:+XFtvxGut8gfIXJtrA3plN9mZkgIHIDvYPCf+NEVd3c="
    ];
  };

  # Enable the OpenSSH daemon (allow secure remote logins)
  services.openssh.enable = true;
  programs.ssh.startAgent = true; # Start ssh-agent as systemd service

  # Battery info
  services.upower.enable = true;

  services.printing = {
    enable = true;
    # drivers = (with pkgs; [ gutenprint cups-bjnp hplip cnijfilter2 ]);
  };

  console = {
    keyMap = "us";
  };

  i18n = lib.mkForce {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ typing-booster ]; # includes emoji-picker
    };
  };

  time.timeZone = "Europe/Madrid";

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      powerline-fonts
      noto-fonts-emoji
    ];
  };

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us-custom,us";
    xkbOptions = "terminate:ctrl_alt_bksp"; # TODO not working
    xkbVariant = ""; # default
    xkbModel = "pc104"; # default
    extraLayouts."us-custom" = {
      description = "US + Math + Greek";
      languages = [ "eng" ];
      symbolsFile = ./dotfiles/keyboard/us-custom;
    };

    desktopManager = {
       xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+xmonad";
      # Shell commands executed just before the window or desktop manager is started. These commands are not currently sourced for Wayland sessions.
      sessionCommands = ''
        stalonetray &
        xscreensaver -no-splash &
        blueman-manager &
        wpa_gui &
        nitrogen --restore &
        picom & # Careful, errors do not show

        # Mouse repetition key input speed
        ${pkgs.xorg.xset}/bin/xset r rate 265 40

        # Unfortunately since the HM autorandr module is not set up to detect hardware events, that is, it won't react to simply inserting the HDMI cable. It would be sweet to fix so that it does and if anybody know udev or something well enough to figure out how to do it that would be great.I suspect it's not doable without hooking it up in the system level configuration, though. Something like what the autorandr Makefile does.
        # ${pkgs.autorandr}/bin/autorandr -c
      '';
      lightdm = {
        enable = true;
        # doesn't work
        # background = "/home/arnau/wallpaper.jpeg";
        greeters.gtk.indicators = [ "~host" "~spacer" "~clock" "~spacer" "~a11y" "~session" "~power"];
      };
    };

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = /etc/nixos/dotfiles/xmonad/xmonad.hs;
        extraPackages = haskellPackages : [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad-wallpaper
          haskellPackages.xmobar
          haskellPackages.X11
        ];
      };
    };
  };

  users = {
    mutableUsers = false; # Don't allow imperative style
    extraGroups.vboxusers.members = [ "arnau" ];
    extraUsers =
      { arnau =
         { createHome = true;
           home = "/home/arnau";
           group = "users";
           extraGroups = [
             "wheel"
             "networkmanager"
             "video"
             "audio"
             "docker"
             "transmission"
           ];
           isNormalUser = true;
           uid = 1000;
           useDefaultShell = false;
           shell = "/run/current-system/sw/bin/zsh";
           # mkpasswd
           hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
         };
      };
  };

  # /etc/hosts
  networking.extraHosts =
    ''
      127.0.0.1 pornhub.com
      127.0.0.1 www.pornhub.com
      127.0.0.1 xvideos.com
      127.0.0.1 www.xvideos.com
      127.0.0.1 xnxx.com
      127.0.0.1 www.xnxx.com

      # 127.0.0.1 youtube.com
      # 127.0.0.1 www.youtube.com
    '';

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  documentation = {
    man.enable = true;
  };

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    # Doesn't work, it clashes with the static .zsh file :(
    #promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
  };

  # BitTorrent client:
  services.transmission = {
    enable = true;
    user = "transmission";
    group = "transmission";
    port = 9091;
    #settings = {
      #download-dir = "/var/lib/transmission/Downloads";
      #incomplete-dir = "/var/lib/transmission/.incomplete";
      #incomplete-dir-enabled = true;
    #};
  };

  # https://nixos.wiki/wiki/Actkbd
  services.actkbd = {
      enable = true;
      # sudo lsinput # Find the input device (be aware that not all devices are mapped to one input..)
      # nix-shell -p actkbd --run "sudo actkbd -n -s -d /dev/input/event#" # Replace '#' by event ID
      bindings =
        let
          toggleVol      = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master toggle'"; };
          incrVol        = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%- unmute'"; };
          decrVol        = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%+ unmute'"; };
          toggleMic      = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer set Capture toggle'"; };
          incrBrightness = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set 10%-"; };
          decrBrightness = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set +10%"; };
        in concatLists [
          # audio (fix: https://github.com/NixOS/nixpkgs/issues/24297)
          #( map toggleVol [ [ 59 ] [ 113 ] ] )
          #( map incrVol [ [ 60 ] [ 114 ] ] )
          #( map decrVol [ [ 61 ] [ 115 ] ] )

          ( map toggleMic [ [ 62 ] [ 190 ] ] )

          #( map incrBrightness [ [ 224 ] ] )
          #( map decrBrightness [ [ 225 ] ] )
        ];
    };

  # It clashes with docker postgres
  #services.postgresql = {
    #enable = true;
    #package = pkgs.postgresql_11;
    #enableTCPIP = true;
    #authentication = pkgs.lib.mkOverride 10 ''
      #local all all trust
      #host all all ::1/128 trust
    #'';
    #initialScript = pkgs.writeText "backend-initScript" ''
      #CREATE DATABASE example;
    #'';
  #};

  # http://localhost:8080
  services.hoogle = {
    enable = true;
    packages = (hpkgs: with hpkgs; [text lens]);
    haskellPackages = pkgs.haskellPackages;
    port = 8080;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    # Virtualbox
    virtualbox.host.enable = true;
  };
}
