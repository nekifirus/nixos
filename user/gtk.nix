{ pkgs, ... }:

{
  home-manager.users.nekifirus.gtk = {
    enable = true;
    theme = {
      name = "Materia-dark-compact";
      package = pkgs.materia-theme;
    };
  };
}
