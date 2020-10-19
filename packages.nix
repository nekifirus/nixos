{ pkgs, ... }:


{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inkscape
    # gimp-with-plugins
    gnutar
    mu
    nixui
    abiword
    # adobe-reader
    ag
    chromium
    direnv
    dmenu
    docker-compose
    edbrowse
    elinks
    epiphany
    firefox
    fortune
    gcc
    git
    gitAndTools.git-extras
    gmrun
    gnumake
    gnupg
    heroku
    home-manager
    htop
    ispell
    jupyter
    libffi.dev
    lm_sensors
    lxappearance
    networkmanagerapplet
    ntfs3g
    openssl.dev
    pass
    pavucontrol
    postgresql
    pptp
    pulsemixer
    qutebrowser
    redis
    scrot
    skype
    slack
    surf
    surfraw
    tdesktop
    traceroute
    telnet
    tmux
    unzip
    urlview
    usbutils
    vim
    wget
    xclip
    xmobar
    xsel
    zoom-us
  ];
}
