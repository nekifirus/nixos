{ config, pkgs, lib, ... }:


{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:caps_toggle, grp_led:caps, terminate:ctr_alt_bksp";
    videoDrivers = ["nvidia" "noveau"];
    windowManager = {
      exwm = {
        enable = false;
      };
      awesome.enable = true;
      stumpwm.enable = false;
    };

  };
}
