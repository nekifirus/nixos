# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
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

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Aqtobe";
  time.hardwareClockInLocalTime = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    usbutils tmux wget vim git gnupg htop ntfs3g docker-compose lm_sensors home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  services.redshift = {
    enable = true;
    provider = "geoclue2";
    # latitude = "51.395777";
    # longitude = "58.127907";
    temperature = {
      night = 4200;
    };
    brightness = {
      night = "0.97";
    };
  };


  services.openvpn.servers = {
    zenmateVPN  = {
      config = ''
        client
        remote 4-15-cz.cg-dialup.net 443
        dev tun
        proto udp

        resolv-retry infinite
        redirect-gateway def1
        persist-key
        persist-tun
        nobind
        cipher AES-256-CBC
        auth SHA256
        ping 5
        ping-exit 60
        ping-timer-rem
        explicit-exit-notify 2
        script-security 2
        remote-cert-tls server
        route-delay 5
        tun-mtu 1500
        fragment 1300
        mssfix 1200
        verb 4
        comp-lzo

        ca /vpn/ca.crt
        cert /vpn/client.crt
        key /vpn/client.key
        auth-user-pass /vpn/auth.cred
      '';
      autoStart = false;
      updateResolvConf = true;
    };
  };

  # open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us, ru";
  services.xserver.xkbOptions = "grp:caps_toggle, grp_led:caps, terminate:ctr_alt_bksp";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;
  # services.xserver.desktopManager.deepin.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  # services.xserver.windowManager.stumpwm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  # services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  # services.xserver.desktopManager.default = "none";

  virtualisation.docker.enable = true;

  services.emacs.enable = true;
  services.emacs.install = true;
  services.emacs.defaultEditor = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = [
              {name = "nekifirus";
               isNormalUser = true;
               uid = 1000;
               extraGroups = [ "docker" "postgres" ];
               }
               { name = "nut";
               uid = 84;
               home = "/var/lib/nut";
               createHome = true;
               group = "nut";
               description = "UPnP A/V Media Server user";
               }
  ];

  users.groups = [
      { name = "nut";
        gid = 84;
      }
    ];



  # containers block
  containers.ps96 =
    { config =
      { config, pkgs, ... }:
      { services.postgresql.enable = true;
      services.postgresql.package = pkgs.postgresql_9_6;
      services.postgresql.authentication = lib.mkForce ''
    # Generated file; do not edit!
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            trust
    host    all             all             ::1/128                 trust
    '';
      };
  };
  containers.ps96.autoStart = false;

  powerManagement.cpuFreqGovernor = "ondemand";

  power.ups = {
    enable = true;
    ups.cyberpower = {
      driver = "powerpanel";
      port = "auto";
    };
  };

  # Enable autoupgrade
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
