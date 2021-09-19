{ pkgs, ... }:


{
  environment.systemPackages = with pkgs; [
    cryptsetup
    gcc
    gnumake
    heroku
    libffi.dev
    lm_sensors
    ntfs3g
    openssl.dev
    pass
    postgresql
    redis
    usbutils
  ];
}
