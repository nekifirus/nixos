{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.connectionTrackingModules = [ "pptp" ];
  programs.nm-applet.enable = true;
}
