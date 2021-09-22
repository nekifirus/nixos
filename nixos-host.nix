# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "kvm-intel" "coretemp" "igc" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  };

   fileSystems."/" =
    { device = "/dev/disk/by-uuid/4e5b84fc-1f0b-4c2f-80a3-38a9db939c0f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/095D-CC9E";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/a987429c-ff67-47b2-8788-c0223b881057";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/9d939830-d432-4deb-b407-e3737159c0f9"; }
    ];

  networking = {
    hostName = "nixos"; # Define your hostname.
    nameservers = ["8.8.8.8"];
  };
  
  services.avahi.ipv4 = false;
  services.dbus.enable = true;
  
  systemd.extraConfig = "DefaultStartLimitIntervalSec=2\nDefaultStartLimitBurst=20";
  powerManagement.cpuFreqGovernor = "ondemand";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
