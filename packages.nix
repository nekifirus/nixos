{ pkgs, ... }:


{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.variables = { GOROOT = [ "${pkgs.go.out}/share/go" ]; };

  environment.systemPackages = with pkgs; [
    conky
    gnutar
    electrum
    cryptsetup
    inkscape
    gnutar
    mu
    abiword
    ag
    chromium
    direnv
    dmenu
    docker-compose
    elinks
    firefox
    fortune
    gcc
    git
    gitAndTools.git-extras
    gmrun
    gnumake
    gnupg
    heroku
    # home-manager
    htop
    ispell
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
    redis
    scrot
    skype
    slack
    tdesktop
    tmux
    unzip
    usbutils
    vim
    wget
    zoom-us
  ];
}
