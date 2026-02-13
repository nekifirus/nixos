{ pkgs, inputs, ... }:
{
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.package = pkgs.nixVersions.latest;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  home-manager.useGlobalPkgs = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlay
    (final: prev:
      let
        slackPkgs = import inputs.slackpkgs {
          system = prev.system;
          config.allowUnfree = true;
        };
      in {
        slack = slackPkgs.slack;
      })
    (final: prev:
    let
      firefoxPkgs = import inputs.firefoxpkgs {
        system = prev.system;
        # allowUnfree не нужен, но можно оставить как есть, если хочешь единообразия
        config = {};
      };
    in {
      firefox = firefoxPkgs.firefox;
      # Если ты используешь именно wayland-вариант:
      # firefox-wayland = firefoxPkgs.firefox-wayland or firefoxPkgs.firefox;
    })
  ];
}
