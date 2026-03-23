{ pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  networking.firewall.connectionTrackingModules = [ "pptp" ];
  programs.nm-applet.enable = true;
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    pptp
    openvpn
  ];
}
