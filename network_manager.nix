{ pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.connectionTrackingModules = [ "pptp" ];
  programs.nm-applet.enable = true;
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    pptp
    
  ];
}
