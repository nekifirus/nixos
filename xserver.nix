{ config, pkgs, lib, ... }:


{
  imports = [ ./dwm.nix ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:caps_toggle, grp_led:caps, terminate:ctr_alt_bksp";
    videoDrivers = ["nvidia" "noveau"];
    windowManager = {
      exwm = {
        enable = true;
      };
      awesome.enable = true;
      stumpwm.enable = true;
    };

  };
}
