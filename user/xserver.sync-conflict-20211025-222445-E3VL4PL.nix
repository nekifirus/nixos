{ pkgs, ... }:


{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:caps_toggle, grp_led:caps, terminate:ctr_alt_bksp";
    windowManager.awesome.enable = true;
  };
  home-manager.users.nekifirus.home.packages = with pkgs; [
    conky
    electrum
    inkscape
    abiword
    dmenu
    scrot
    skype
    slack
    zoom-us
  ];
}