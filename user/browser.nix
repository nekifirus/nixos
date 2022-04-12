{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    nyxt
    qutebrowser
    surf
    #    chromium
    google-chrome
    elinks
    firefox
  ];
  home-manager.users.nekifirus.programs.browserpass = {
    enable = true;
    browsers = [ "firefox" "chromium" ];
  };
}
