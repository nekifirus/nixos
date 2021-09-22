{ pkgs, config, lib, ... }: {
  console.font = "cyr-sun16";
  console.keyMap = "ruwin_cplk-UTF-8";

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us,ru";
    XKB_DEFAULT_OPTIONS =
      "grp:caps_toggle,grp_led:caps";
    LANG = lib.mkForce "en_GB.UTF-8";
  };

  time.timeZone = "Asia/Aqtobe";
  time.hardwareClockInLocalTime = false;
  home-manager.users.nekifirus = {
    home.language = let
      en = "en_GB.UTF-8";
      ru = "ru_RU.UTF-8";
    in {
      address = ru;
      monetary = ru;
      paper = ru;
      time = en;
      base = en;
    };
  };
}
