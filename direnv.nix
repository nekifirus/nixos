{ ... }:

{
  home-manager.users.nekifirus.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };
}
