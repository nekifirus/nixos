# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./xserver.nix
      ./emacs.nix
      ./emacs-overlay.nix
      # ./emacs-with-use-package.nix
      ./packages.nix
      ./containers.nix
      ./redshift.nix
    ];

  # boot.loader.grub.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  #boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5001b448b9563d7d";
  boot.kernelModules = [ "coretemp" "it87"];

  # try to disable swap
  swapDevices = lib.mkForce [ ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.dhcpcd.denyInterfaces = [ "docker*" "ve*" "br*" ];
  services.avahi.ipv4 = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127..0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Aqtobe";
  time.hardwareClockInLocalTime = false;

  nixpkgs.config.allowUnfree = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  programs.slock.enable = true;
  programs.nm-applet.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  systemd.extraConfig = "DefaultStartLimitIntervalSec=2\nDefaultStartLimitBurst=20";
  # open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.connectionTrackingModules = [ "pptp" ];
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.extraConfig = ''
  #    default-sample-channels = 4
  # '';

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nekifirus = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "postgres" ];
    };
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  # Enable autoupgrade
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
