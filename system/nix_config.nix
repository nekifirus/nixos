{ pkgs, inputs, ... }:
{
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.package = pkgs.nixVersions.latest;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
}
