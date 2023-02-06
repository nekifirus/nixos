{ pkgs, ... }:


{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us, ru";
    xkbOptions = "grp:toggle, grp_led:caps, ctrl:swapcaps, ctrl:nocaps, terminate:ctr_alt_bksp";
    libinput.touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      additionalOptions = ''
             Option "TappingButtonMap" "lrm"
                 '';                        

    };
    windowManager.awesome.enable = true;
    windowManager.stumpwm.enable = true;
    windowManager.i3.enable = true;
    windowManager.dwm.enable = true;
    windowManager.exwm.enable = true;
  };
  home-manager.users.nekifirus.services.screen-locker = {
    enable = true;
    lockCmd = "\${pkgs.i3lock}/bin/i3lock -n -c 000000";
    xautolock.enable = true;
    
  };
  
  home-manager.users.nekifirus.home.packages = with pkgs; [
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
