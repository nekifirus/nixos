{ pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + shift + p" = "passmenu";
      "super + p" = "rofi -show combi -theme dmenu";
      "super + a" = "emacsclient -nc";
      "Print" = "sleep 0.5 && scrot -s '%Y-%m-%d-%H:%M:%S_$wx$h_scrot.png' -e 'mv -n $f ~/scshots/'";
      "super + Print" = "scrot '%Y-%m-%d-%H:%M:%S_scrot.png' -e 'mv -n $f ~/scshots/'";
    };
  };
}
