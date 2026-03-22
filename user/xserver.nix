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
  };
  # xautolock отключён — не уважает XSS inhibition (fullscreen видео).
  # В GNOME блокировкой управляет сам GNOME.
  home-manager.users.nekifirus.services.screen-locker.enable = false;
  
  home-manager.users.nekifirus.home.packages = with pkgs; [
    remmina
    inkscape
    blueman
    dmenu
    slack
    telegram-desktop
    zoom-us
    wl-clipboard
  ];
}
