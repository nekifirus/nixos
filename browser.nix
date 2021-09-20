{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    qutebrowser
    surf
    chromium
    elinks
    firefox
  ];
  home-manager.users.nekifirus.programs.browserpass = {
    enable = true;
    browsers = [ "firefox" "chromium" ];
  };
}
