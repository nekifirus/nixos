{ pkgs, ... }:

{
  home-manager.users.nekifirus.gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };
}
