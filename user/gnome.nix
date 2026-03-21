{ pkgs, ...}:

{
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.gnome-tweaks
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
