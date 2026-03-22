{ config, pkgs, lib, ... }:

let
  exwmStartup = pkgs.writeShellScript "exwm-startup" ''
    # Fix Java AWT (Swing apps would otherwise appear grey/broken)
    export _JAVA_AWT_WM_NONREPARENTING=1
    # Signal emacs config to activate EXWM
    export EXWM_ENABLED=1
    # Force X11 backend for GTK/Qt apps running under EXWM
    export GDK_BACKEND=x11
    export QT_QPA_PLATFORM=xcb
    # Set default X cursor (otherwise it's an ugly X)
    ${pkgs.xsetroot}/bin/xsetroot -cursor_name left_ptr
    # Merge .Xresources if present
    [ -f "$HOME/.Xresources" ] && ${pkgs.xrdb}/bin/xrdb -merge "$HOME/.Xresources"
    # Start user's home-manager emacs (with all packages) as the window manager
    exec /home/nekifirus/.nix-profile/bin/emacs
  '';
in
{
  # Disable the NixOS EXWM module — it builds a separate stripped-down emacs
  # that doesn't have the user's packages. We use a custom session instead.
  services.xserver.windowManager.exwm.enable = lib.mkForce false;

  # Custom EXWM session that uses the user's fully-configured emacs
  services.xserver.windowManager.session = [{
    name = "emacs-exwm";
    start = ''exec ${exwmStartup}'';
  }];

  environment.systemPackages = with pkgs; [
    xinit
    xsetroot
    xrdb
    xrandr
    autorandr     # automatic monitor layout switching
    maim          # screenshots
    xdotool       # X window automation
    xclip         # clipboard
  ];
}
