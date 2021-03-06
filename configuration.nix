# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.blacklistedKernelModules = 
    [
      "cirrusfb"
      "i2c_piix4"
      "nouveau"
      "tpm_crb"
      "iTCO_wdt"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    #  grub = {
    #  enable = true;
    #  device = "nodev";
    #  efiSupport = true;
    # };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Luke-PC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    vim
    git
    fcitx
    fcitx-configtool
    neofetch
    firefox
    inetutils
    mtr
    sysstat
    paper-icon-theme
    papirus-icon-theme
    arc-theme
    adapta-kde-theme
    adapta-gtk-theme
    alacritty
    tilix
    stdenv
    rustup
    android-udev-rules
    openjdk
    fd
    ark
    inxi
    aria2
    google-chrome
    vscode
    dropbox
    jetbrains.clion
    jetbrains.jdk
    jetbrains.idea-ultimate
    kotlin
    jetbrains.pycharm-professional
    android-studio
    keepassxc
    rsync
    rclone
    rclone-browser
    steam
    ripgrep 
  ];

  fonts = {
    fontconfig.enable = true;
    fontconfig.penultimate.enable = false;
    fontconfig.defaultFonts.sansSerif = [
      "Roboto"
      "Noto Sans CJK SC"
    ];
    fontconfig.defaultFonts.monospace = [
      "Iosevka"
      "Sarasa Mono"    
    ];
    fontconfig.defaultFonts.serif = [
      "Source Han Serif CN"
    ];
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      sarasa-gothic
      iosevka-bin
      roboto
      roboto-mono
      roboto-slab
      source-han-serif-simplified-chinese
      source-serif-pro
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Privoxy
  services.privoxy.enable = true;
  services.privoxy.listenAddress = "127.0.0.1:8118";
  services.privoxy.extraConfig = ''
    forward-socks5 / 127.0.0.1:1080 .
  '';

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable Input Method.
  i18n.inputMethod = {
    enabled = "fcitx";
  };

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  networking.nameservers = [
    "192.168.1.1"
    "115.29.235.168"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luke = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/luke";
    description = "Luke Yue";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

  services.resolved = {
    enable = true;
    extraConfig = 
      "DNSOverTLS=opportunistic"
    ;
  };

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = ["git" "python" "man" ];
    theme = "ys";
  };
  programs.zsh.promptInit = "";
  users.extraUsers.luke = {
    shell = pkgs.zsh;
  };

  nixpkgs.config = {
    allowUnfree = true;
    packagesOverrides = pkgs:
    {
      unstable = import <nixos-unstable>
        {
          config = config.nixpkgs.config;
        };
    };
  };

}
