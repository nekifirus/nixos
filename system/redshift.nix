{ config, pkgs, lib, ... }:


{
  location = {
    latitude = 51.395777;
    longitude = 58.127907;
  };

  services.redshift = {
    enable = true;
    # provider = "geoclue2";
    # latitude = "51.395777";
    # longitude = "58.127907";
    temperature = {
      night = 4200;
    };
    brightness = {
      night = "0.97";
    };
  };
}
