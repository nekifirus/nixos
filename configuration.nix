# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "coretemp" "igc" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  };
  
  # swapDevices = lib.mkForce [];

  networking = {
    hostName = "nixos"; # Define your hostname.
  };
  services.avahi.ipv4 = false;
  services.dbus.enable = true;
  
  systemd.extraConfig = "DefaultStartLimitIntervalSec=2\nDefaultStartLimitBurst=20";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nekifirus = {
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
  powerManagement.cpuFreqGovernor = "ondemand";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
