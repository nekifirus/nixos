# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  
  boot.extraModulePackages = [ ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/cc3511ae-8a9f-4a2b-82b5-5c419b4671fc";
  
  fileSystems."/".device = "/dev/mapper/crypted";
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AED2-EC75";
      fsType = "vfat";
    };

  swapDevices = [ ];

  boot.loader.systemd-boot.enable = true;	
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos-thinkpad"; # Define your hostname.
  };
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.11"; # Did you read the comment?

}
