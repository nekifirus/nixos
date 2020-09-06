{ config, pkgs, lib, ... }:

{

  services.emacs.enable = true;
  services.emacs.install = true;
  services.emacs.defaultEditor = true;
  services.emacs.package = with pkgs; (emacsWithPackages (with emacsPackagesNg; [
    exwm
    clojure-mode-extra-font-locking
    darkroom
    csv-mode
    gnupg
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
    forge
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
    magithub
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
    (pkgs.python38.withPackages (ps: with ps; [elpy jedi flake8 autopep8 isort pip setuptools redis flask ]))
  ]));
}
