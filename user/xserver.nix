{ pkgs, ... }:


{
  # Enable the X11 windowing system.
  services.libinput.touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      additionalOptions = ''
             Option "TappingButtonMap" "lrm"
                 '';                        

  };
  
  services.xserver = {
    enable = true;
    xkb.layout = "us, ru";
    xkb.options = "grp:toggle, grp_led:caps, ctrl:swapcaps, ctrl:nocaps, terminate:ctr_alt_bksp";
    windowManager.awesome.enable = true;
    windowManager.stumpwm.enable = false;
    windowManager.i3.enable = false;
    windowManager.dwm.enable = true;
    windowManager.exwm.enable = true;
  };
  home-manager.users.nekifirus.services.screen-locker = {
    enable = true;
    lockCmd = "\${pkgs.i3lock}/bin/i3lock -n -c 000000";
    xautolock.enable = true;
    
  };
  
  home-manager.users.nekifirus.home.packages = with pkgs; [
    remmina
    inkscape
    blueman
    dmenu
    skypeforlinux
    slack
    tdesktop
    zoom-us
    wl-clipboard
  ];
}
