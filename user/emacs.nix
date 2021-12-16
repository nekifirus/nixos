{ config, pkgs, lib, ... }:

# with lib;

# let
#   cfg = config.services.emacs;
#   emacsCfg = config.programs.emacs;
#   emacsBinPath = "${emacsCfg.finalPackage}/bin";

#   captureDesktopItem = pkgs.makeDesktopItem rec {
#     name = "emacscapture";
#     desktopName = "Emacs Capture";
#     genericName = "Text Editor";
#     comment = "Edit text";
#     mimeType ="x-scheme-handler/org-protocol";
#     exec = "${emacsBinPath}/emacsclient -u";
#     icon = "emacs";
#     type = "Application";
#     terminal = "false";
#     categories = "Utility;TextEditor;";
#     extraEntries = ''
#       StartupWMClass=Capture
#     '';
#    };
# in {
{
  # home-manager.users.nekifirus.home.packages = [ captureDesktopItem ];
  home-manager.users.nekifirus.home.packages = with pkgs; [
     imagemagick
     ffmpeg-full
     x265
     sqlite
     ripgrep
     ag
     ispell
     unzip
     gnutar
     graphviz
  ];

  home-manager.users.nekifirus.services.emacs.enable = true;
  home-manager.users.nekifirus.programs.emacs.enable = true;
  # programs.emacs.package = pkgs.emacsUnstable;
  home-manager.users.nekifirus.programs.emacs.extraPackages = epkgs:
    with epkgs; [
      solidity-mode
      tide
      typescript-mode
      telega
      org-roam
      poporg
      go-mode
      protobuf-mode
      mood-line
      pdf-tools
      ibuffer-vc
      xresources-theme
      org-bullets
      multiple-cursors
      lsp-mode
      notmuch
      lua-mode
      ag
      all-the-icons
      all-the-icons-dired
      all-the-icons-ivy
      avy
      avy-zap
      base16-theme
      bind-key
      company
      copy-as-format
      counsel
      counsel-projectile
      counsel-tramp
      diff-hl
      diminish
      direnv
      dired-du
      dockerfile-mode
      docker
      elixir-mode
      epl
      expand-region
      flycheck
      # gitignore-mode
      google-this
      google-translate
      ivy
      magit
      magit-popup
      markdown-mode
      nix-mode
      no-littering
      # org-plus-contrib
      plantuml-mode
      projectile
      ibuffer-projectile
      py-autopep8
      py-isort
      python-mode
      rainbow-delimiters
      rainbow-identifiers
      rainbow-mode
      reverse-im
      smart-comment
      smartparens
      swiper
      system-packages
      toc-org
      use-package
      use-package-ensure-system-package
      vue-mode
      which-key
      whole-line-or-region
      yaml-mode
      yasnippet
      yasnippet-snippets
      company-box
      lsp-ui
      lsp-ivy
    ];
  # ]));
}
