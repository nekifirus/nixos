{ pkgs, ... }:

{
  home-manager.users.nekifirus.programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 2; y = 2; };
        dynamic_padding =  true;
        decorations = "none";
        opacity =  0.85;
      };
      font.size = 13;
    };
  };
}
