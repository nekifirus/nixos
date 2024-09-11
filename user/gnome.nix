{ pkgs, ...}:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.gnome-tweaks
    pkgs.gnomeExtensions.cpufreq
  ];

  environment.gnome.excludePackages = [
    pkgs.cheese
    pkgs.gnome-photos
    pkgs.gnome-music
    pkgs.gnome-terminal
    pkgs.gedit
    pkgs.epiphany
    pkgs.evince
    pkgs.gnome-characters
    pkgs.totem
    pkgs.tali
    pkgs.iagno
    pkgs.hitori
    pkgs.atomix
    pkgs.gnome-tour
    # pkgs.gnome.geary I like it yet
  ];
}
