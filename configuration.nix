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
    ];

  services.yggdrasil = {
    enable = false;
    persistentKeys = false;
    # The NixOS module will generate new keys and a new IPv6 address each time
    # it is started if persistentKeys is not enabled.

    config = {
      Peers = [
        # Yggdrasil will automatically connect and "peer" with other nodes it
        # discovers via link-local multicast annoucements. Unless this is the
        # case (it probably isn't) a node needs peers within the existing
        # network that it can tunnel to.
        "tcp://ygg-nl.incognet.io:8883"
        "tls://65.21.57.122:61995"
        "tcp://1.2.3.4:1024"
        "tcp://1.2.3.5:1024"
        # Public peers can be found at
        # https://github.com/yggdrasil-network/public-peers
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "coretemp" "igc" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # try to disable swap
  swapDevices = lib.mkForce [];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.dhcpcd.denyInterfaces = [ "docker*" "ve*" "br*" ];
  services.avahi.ipv4 = false;

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

  nixpkgs.config.allowUnfree = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  programs.slock.enable = true;
  programs.nm-applet.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";
  services.dbus.enable = true;

  services.emacs.enable = true;
  services.emacs.install = true;
  services.emacs.defaultEditor = true;

  systemd.extraConfig = "DefaultStartLimitIntervalSec=2\nDefaultStartLimitBurst=20";

  networking.firewall.connectionTrackingModules = [ "pptp" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--data-root /home/nekifirus/docker";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm;

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

  # Enable autoupgrade
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
