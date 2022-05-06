# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.blacklistedKernelModules = [ "rtw88_8821ce" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl8821ce ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."crypted".device = "/dev/disk/by-uuid/2a8b58b1-b6db-4b58-ac39-4f2b8eca375e";
  fileSystems."/".device = "/dev/mapper/crypted";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/80A1-AA09";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/03ac5413-fe6f-4985-99b4-c9ce458e9dfa"; }
    ];

  boot.loader.systemd-boot.enable = true;	
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos-asus"; # Define your hostname.
  };
 
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

}
