{ config, pkgs, lib, ... }:

{
  services.xserver.windowManager.dwm.enable = true;


  nixpkgs.config = {
    dwm.patches = [
      ./dwm/mod4.patch
      ./dwm/xterm.patch
      ./dwm/dragmfact.patch
      ./dwm/fakefullscreen.patch
      ./dwm/pertag.patch
      # ./dwm/nsystray.patch
    ];
  };
}
