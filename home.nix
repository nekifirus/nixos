{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
    pkgs.direnv
    pkgs.slack
    pkgs.tdesktop
    pkgs.ispell
    pkgs.ag
    pkgs.skype
    pkgs.zoom-us
    pkgs.gnumake
  ];

  programs.emacs = {
    enable = true;
    extraPackages = ekpgs: [
      ekpgs.nix-mode
      ekpgs.magit
      ekpgs.ace-window
      ekpgs.ag
      ekpgs.alchemist
      ekpgs.all-the-icons
      ekpgs.all-the-icons-dired
      ekpgs.all-the-icons-ivy
      ekpgs.avy
      ekpgs.avy-zap
      ekpgs.base16-theme
      ekpgs.bind-key
      ekpgs.cider
      ekpgs.clojure-mode
      ekpgs.clojure-mode-extra-font-locking
      ekpgs.clojure-snippets
      ekpgs.company
      ekpgs.company-statistics
      ekpgs.copy-as-format
      ekpgs.counsel
      ekpgs.counsel-projectile
      ekpgs.csv-mode
      ekpgs.darkroom
      ekpgs.diff-hl
      ekpgs.diminish
      ekpgs.direnv
      ekpgs.docker
      ekpgs.docker-compose-mode
      ekpgs.dockerfile-mode
      ekpgs.docker-tramp
      ekpgs.elixir-mode
      ekpgs.epl
      ekpgs.exec-path-from-shell
      ekpgs.expand-region
      ekpgs.flycheck
      ekpgs.flycheck-mix
      ekpgs.gh
      ekpgs.gist
      ekpgs.gitignore-mode
      ekpgs.google-this
      ekpgs.google-translate
      ekpgs.haml-mode
      ekpgs.ht
      ekpgs.htmlize
      ekpgs.ivy
      ekpgs.json-mode
      ekpgs.json-reformat
      ekpgs.json-snatcher
      ekpgs.logito
      ekpgs.magit-popup
      ekpgs.markdown-mode
      ekpgs.marshal
      ekpgs.memoize
      ekpgs.no-littering
      ekpgs.parseclj
      ekpgs.parseedn
      ekpgs.pcache
      ekpgs.pkg-info
      ekpgs.plantuml-mode
      ekpgs.projectile
      ekpgs.queue
      ekpgs.rainbow-delimiters
      ekpgs.rainbow-identifiers
      ekpgs.rainbow-mode
      ekpgs.restart-emacs
      ekpgs.reverse-im
      ekpgs.sesman
      ekpgs.smart-comment
      ekpgs.smartparens
      ekpgs.spinner
      ekpgs.swiper
      ekpgs.system-packages
      ekpgs.tablist
      ekpgs.toc-org
      ekpgs.use-package
      ekpgs.use-package-ensure-system-package
      ekpgs.wakatime-mode
      ekpgs.which-key
      ekpgs.whole-line-or-region
      ekpgs.yaml-mode
      ekpgs.yasnippet
      ekpgs.yasnippet-snippets
    ];
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
    enableGoogleTalk = true;
  };

  programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit"];
    sessionVariables = {};
    shellAliases = {};
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.git = {
    enable = true;
    userName = "Nikita Mistyukov";
    userEmail = "nekifirus@gmail.com";
    ignores = ["*~" "*.swp" ".direnvrc"];
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
