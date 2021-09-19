{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    qutebrowser
    surf
    chromium
    elinks
    firefox
  ];
}
