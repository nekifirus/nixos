{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.emacs;
  emacsCfg = config.programs.emacs;
  emacsBinPath = "${emacsCfg.finalPackage}/bin";

  captureDesktopItem = pkgs.makeDesktopItem rec {
    name = "emacscapture";
    desktopName = "Emacs Capture";
    genericName = "Text Editor";
    comment = "Edit text";
    mimeType ="x-scheme-handler/org-protocol";
    exec = "${emacsBinPath}/emacsclient -u";
    icon = "emacs";
    type = "Application";
    terminal = "false";
    categories = "Utility;TextEditor;";
    extraEntries = ''
      StartupWMClass=Capture
    '';
   };
in {

  # imports = [./emacs-overlay.nix];
  home.packages = [ captureDesktopItem];

  services.emacs.enable = true;
  # services.emacs.client.enable = true;
  programs.emacs.enable = true;
  # programs.emacs.package = pkgs.emacsUnstable;
  programs.emacs.extraPackages = epkgs:
    with epkgs; [
      # explain-pause-mode
      mood-line
      pdf-tools
      try
      ibuffer-vc
      xresources-theme
      frames-only-mode
      modus-vivendi-theme
      modus-operandi-theme
      org-bullets
      multiple-cursors
      lsp-mode
      company-lsp
      # notmuch
      pkgs.mu
      exwm
      clojure-mode-extra-font-locking
      darkroom
      csv-mode
      pkgs.gnupg
      lua-mode
      # magit-gh-pulls
      ace-window
      ag
      alchemist
      all-the-icons
      all-the-icons-dired
      all-the-icons-ivy
      avy
      avy-zap
      base16-theme
      bind-key
      cider
      clojure-mode
      clojure-snippets
      company
      company-statistics
      copy-as-format
      counsel
      counsel-projectile
      counsel-tramp
      diff-hl
      diminish
      direnv
      dired-du
      docker
      docker-compose-mode
      docker-tramp
      dockerfile-mode
      elixir-mode
      elpy
      epl
      eredis
      exec-path-from-shell
      expand-region
      flycheck
      # flycheck-mix
      # forge
      gh
      gist
      gitignore-mode
      google-this
      google-translate
      haml-mode
      haskell-mode
      ht
      htmlize
      ivy
      json-mode
      json-reformat
      json-snatcher
      logito
      magit
      magit-popup
      # magithub
      markdown-mode
      marshal
      memoize
      nix-mode
      no-littering
      org-plus-contrib
      parseclj
      parseedn
      pcache
      pkg-info
      plantuml-mode
      projectile
      ibuffer-projectile
      py-autopep8
      py-isort
      python-mode
      rainbow-delimiters
      rainbow-identifiers
      rainbow-mode
      restart-emacs
      reverse-im
      sesman
      smart-comment
      smartparens
      swiper
      system-packages
      tablist
      toc-org
      use-package
      use-package-ensure-system-package
      vue-mode
      wakatime-mode
      which-key
      whole-line-or-region
      yaml-mode
      yasnippet
      yasnippet-snippets
      company-box
      lsp-ui
      lsp-ivy
      pkgs.lua53Packages.lua-lsp
      pkgs.rnix-lsp
      pkgs.nodePackages_latest.typescript-language-server
      pkgs.nodePackages_latest.vue-cli
      pkgs.nodePackages_latest.vue-language-server
      pkgs.nodePackages_latest.vscode-css-languageserver-bin
      pkgs.nodePackages_latest.vscode-html-languageserver-bin
      pkgs.nodePackages_latest.vscode-json-languageserver-bin
      pkgs.nodePackages_latest.eslint
      pkgs.nodePackages_latest.csslint
      pkgs.python-language-server
      (pkgs.python38.withPackages (ps: with ps; [python-language-server[all] elpy jedi flake8 autopep8 isort pip setuptools redis flask ]))
    ];
  # ]));
}
