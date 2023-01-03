{ pkgs, ... }:


{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:win_space_toggle, grp_led:caps, ctrl:swapcaps, terminate:ctr_alt_bksp";
    windowManager.awesome.enable = true;
    windowManager.stumpwm.enable = true;
    windowManager.dwm.enable = true;
    windowManager.exwm.enable = true;
  };
  home-manager.users.nekifirus.home.packages = with pkgs; [
    electrum
    inkscape
    dmenu
    skypeforlinux
    slack
    tdesktop
    zoom-us
    wl-clipboard
  ];
}
