{ pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  home-manager.users.nekifirus.home.packages = with pkgs; [
    vlc
    pavucontrol
    pulsemixer
    
  ];
}
