{ pkgs, ... }:

{
  home-manager.users.nekifirus.programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "combi,window,drun,run,ssh,windowcd,keys";
      font = "mono 18";
      show-icons = true;
      combi-modi = "window,drun,run";
      theme = "gruvbox-dark-hard";
    };
  };
}
