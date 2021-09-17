# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./xserver.nix
      ./packages.nix
      ./redshift.nix
      ./fonts.nix
      ./yggdrasil.nix
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "coretemp" "igc" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  };
  
  # swapDevices = lib.mkForce [];

  networking = {
    hostName = "nixos"; # Define your hostname.
    networkmanager.enable = true;
    dhcpcd.denyInterfaces = [ "docker*" "ve*" "br*" ];
    firewall.connectionTrackingModules = [ "pptp" ];
  };
  services.avahi.ipv4 = false;

  services.openvpn.servers = {
    firstVPN  = {
      config = '' config /root/vpn/first_vpn.conf '';
      updateResolvConf = true;
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  # Set your time zone.
  time.timeZone = "Asia/Aqtobe";
  time.hardwareClockInLocalTime = false;

  # nixpkgs.config.allowUnfree = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gtk2";
  # };

  programs.slock.enable = true;
  programs.nm-applet.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    dbus.enable = true;
  };
  
  services.emacs.enable = true;
  services.emacs.install = true;
  services.emacs.defaultEditor = true;

  systemd.extraConfig = "DefaultStartLimitIntervalSec=2\nDefaultStartLimitBurst=20";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--data-root /home/nekifirus/docker";
    };

    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nekifirus = {
      shell = pkgs.fish;
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "libvirtd"
        "postgres"
      ];
    };
  };
  home-manager.users.nekifirus = import ./home.nix;
  powerManagement.cpuFreqGovernor = "ondemand";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
