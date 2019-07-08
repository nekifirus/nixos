{ pkgs, lib, ... }:

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
    pkgs.abiword
    pkgs.heroku
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
      ekpgs.docker-tramp
      ekpgs.counsel-tramp
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
      case "$TERM" in
     "dumb")
          unsetopt zle
          unsetopt prompt_cr
          unsetopt prompt_subst
          unfunction precmd
          unfunction preexec
          PS1="> "                # Tramp hangs #3
          ;;
     xterm*|rxvt*|eterm*|screen*)
          PS1="\u@\h:\W: $  "
          ;;
     linux*)
          PS1="\u@\h:\W: $  "
          ;;
     *)
          PS1="> "
          ;;
      esac

      eval "$(direnv hook bash)"
    '';
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    sshKeys = [
      "AB5D1B410584680A5E8B2C94A3B6EE46C295B2CD"
      "1BAB252022782531597538185AA83E75A2428470"
    ];
    enableExtraSocket = true;
  };


  programs.ssh.enable = false;

  programs.git = {
    enable = true;
    userName = "Nikita Mistyukov";
    userEmail = "nekifirus@gmail.com";
    ignores = ["*~" "*.swp" ".direnvrc"];
  };


  # Prevent clobbering SSH_AUTH_SOCK
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
