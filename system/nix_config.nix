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
    # Фикс: emacsql пытается скомпилировать C-расширение sqlite, но в nix-сборке
    # нет директории sqlite/. Создаём её вручную и подключаем системный sqlite.
    # org-roam настроен на sqlite-builtin (встроенный в Emacs 29), C-расширение не нужно.
    (final: prev: {
      emacsPackagesFor = emacs:
        (prev.emacsPackagesFor emacs).overrideScope (_: eprev: {
          emacsql = eprev.emacsql.overrideAttrs (old: {
            preBuild = ''
              mkdir -p sqlite
              echo "all:" > sqlite/Makefile
              touch sqlite/emacsql-sqlite
              chmod +x sqlite/emacsql-sqlite
            '';
            buildInputs = (old.buildInputs or []) ++ [ prev.sqlite ];
          });
        });
    })
    (final: prev:
      let
        slackPkgs = import inputs.slackpkgs {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in {
        slack = slackPkgs.slack;
      })
    (final: prev:
      let
        claudePkgs = import inputs.claudepkgs {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in {
        claude-code = claudePkgs.claude-code;
      })
    (final: prev:
      let
        zoomPkgs = import inputs.zoompkgs {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in {
        zoom-us = zoomPkgs.zoom-us;
      })
    (final: prev:
    let
      firefoxPkgs = import inputs.firefoxpkgs {
        system = prev.stdenv.hostPlatform.system;
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
