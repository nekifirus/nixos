{ pkgs, config, lib, ... }: {
  console.font = "cyr-sun16";
  console.keyMap = "ruwin_cplk-UTF-8";

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS = "grp:toggle, grp_led:caps, ctrl:swapcaps, ctrl:nocaps, terminate:ctr_alt_bksp";
    LANG = lib.mkForce "en_GB.UTF-8";
  };

  time.timeZone = "CET";
  time.hardwareClockInLocalTime = false;
  home-manager.users.nekifirus = {
    home.language = let
      en = "en_US.UTF-8";
      ru = "ru_RU.UTF-8";
    in {
      address = en;
      monetary = en;
      paper = en;
      time = en;
      base = en;
    };
  };
}
