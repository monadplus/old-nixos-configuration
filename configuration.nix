{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # You should change this only after NixOS release notes say you should.
  system.stateVersion = "19.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # TODO popOS ?
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

  networking.hostName = "arnau";
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # support for bluetooth headsets

  i18n = lib.mkForce {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    consoleUseXkbConfig = true; # console kb settings = xserver kb settings
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      inconsolata
      fira-mono
      ubuntu_font_family
    ];
  };

  # Enable the OpenSSH daemon (allow secure remote logins)
  services.openssh.enable = true;

  # Start OpenSSH agent when you log in.
  # Use ssh-add to add a key to the agent.
  programs.ssh.startAgent = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    # drivers = (with pkgs; [ gutenprint cups-bjnp hplip cnijfilter2 ]);
  };


  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    # libinput.enable = true;

    # Enable the KDE Desktop Environment.
    # desktopManager.plasma5.enable = true;
    # desktopManager.defaul = "plasma5";
    # displayManager.sddm.enable = true;             

    desktopManager.default = "none";
    desktopManager.xterm.enable = false; # Enable a xterm terminal as a desktop manager
    displayManager.slim = {
      enable = true;
      defaultUser = "arnau";
      theme = pkgs.fetchurl {
        url    = "https://github.com/ylwghst/nixos-light-slim-theme/archive/1.0.0.tar.gz";
        sha256 = "0cc701k920zhy54srd1qwb5rcxqp5adjhnl154z7c0276csglzw9";
      }; 
    };

    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    #windowManager.xmonad.extraPackages = hpkgs : [
      # hpkgs.taffybar
      # hpkgs.xmonad-contrib
      # hpkgs.xmonad-extras
    #];

    # Not working for bash shell
    autoRepeatDelay = 200; # milliseconds
    autoRepeatInterval = 30; # milliseconds

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset r rate 265 40
    '';
  };

  # battery management
  # services.tlp.enable = true

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # Don't allow imperative style
    mutableUsers = false;
    extraUsers = [ 
      {
        name = "arnau";
        createHome = true; # Only if it does not exist.	
        home = "/home/arnau";
	group = "users";
	extraGroups = [ "wheel" "networkmanager" ]; # docker
	isNormalUser = true;
	useDefaultShell = false;
	shell = "/run/current-system/sw/bin/zsh";
        hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
      }
    ];
 };

 services.logind.extraConfig = ''
   # Controls how logind shall handle the system power and sleep keys.
   HandlePowerKey=suspend
 '';

 environment.variables = {
   EDITOR = "vim";
   VISUAL = "vim";
   BROWSER = "firefox";
 };
}
