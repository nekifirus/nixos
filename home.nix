{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.lxappearance-gtk3
    pkgs.pass
    pkgs.surf
    pkgs.qutebrowser
    pkgs.epiphany
    pkgs.ag
    pkgs.urlview
    pkgs.xclip
    pkgs.xsel
    pkgs.htop
    pkgs.scrot
    pkgs.fortune
    pkgs.direnv
    pkgs.slack
    pkgs.tdesktop
    pkgs.ispell
    pkgs.skype
    pkgs.zoom-us
    pkgs.gnumake
    pkgs.abiword
    pkgs.heroku
    pkgs.gmrun
    pkgs.xmobar
    pkgs.gcc
    pkgs.libffi.dev
    pkgs.openssl.dev
  ];

  services.udiskie = {
      enable = true;
      automount = false;
      notify = true;
      tray = "auto";
  };

  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = (epkgs: (with epkgs.melpaPackages; [
      nix-mode
      magit
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
      # clojure-mode-extra-font-locking
      clojure-snippets
      company
      company-statistics
      copy-as-format
      counsel
      counsel-projectile
      epkgs.csv-mode
      epkgs.darkroom
      diff-hl
      diminish
      direnv
      docker
      docker-compose-mode
      dockerfile-mode
      docker-tramp
      elixir-mode
      epl
      exec-path-from-shell
      expand-region
      flycheck
      flycheck-mix
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
      lua-mode
      magit-popup
      markdown-mode
      marshal
      memoize
      no-littering
      parseclj
      parseedn
      pcache
      pkg-info
      plantuml-mode
      projectile
      epkgs.queue
      rainbow-delimiters
      rainbow-identifiers
      epkgs.rainbow-mode
      restart-emacs
      reverse-im
      sesman
      smart-comment
      smartparens
      epkgs.spinner
      swiper
      system-packages
      tablist
      toc-org
      use-package
      use-package-ensure-system-package
      wakatime-mode
      which-key
      whole-line-or-region
      yaml-mode
      yasnippet
      yasnippet-snippets
      docker-tramp
      counsel-tramp
      py-autopep8
      elpy
      (pkgs.python37.withPackages (ps: with ps; [elpy jedi flake8 autopep8 isort pip setuptools redis celery flask ]))
    ]));
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
    enableGoogleTalk = true;
  };

  programs.chromium = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
    extraConfig = ''
      set -g mouse on
    '';
    plugins =  with pkgs; [
            tmuxPlugins.cpu
            tmuxPlugins.yank
            tmuxPlugins.urlview
            tmuxPlugins.sensible
            {
              plugin = tmuxPlugins.continuum;
              extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '15' # minutes
              '';
            }
          ];
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
    defaultCacheTtl = 7200;
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
    ignores = ["*~" "*.swp" ".direnvrc" ".envrc" "shell.nix"];
    signing = {
            signByDefault = true;
            key = "nekifirus@gmail.com";
    };
    extraConfig = {
      core = { editor = "emacsclient -c"; };
    };
  };

  xsession = {
    initExtra = ''
    xset -dpms
    xset s off
    '';
    windowManager.xmonad = {
                         enable = true;
                         enableContribAndExtras = true;
                         extraPackages =  haskellPackages: [
                                       haskellPackages.xmobar
                                       ];
                         };
  };

  xresources = {
    properties = {
      "XTerm*font" = "*-fixed-*-*-*-*-*";
      "XTerm*faceName" = "pango:monospace";
      "XTerm*faceSize" = "12";
      "XTerm*termName" = "xterm-256color";
      "XTerm*metaSendsEscape" = true;
    };
    # lighttheme
    # extraConfig = ''
    # ! Base16 Gruvbox light, hard
    # ! Scheme: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)

    # #define base00 #f9f5d7
    # #define base01 #ebdbb2
    # #define base02 #d5c4a1
    # #define base03 #bdae93
    # #define base04 #665c54
    # #define base05 #504945
    # #define base06 #3c3836
    # #define base07 #282828
    # #define base08 #9d0006
    # #define base09 #af3a03
    # #define base0A #b57614
    # #define base0B #79740e
    # #define base0C #427b58
    # #define base0D #076678
    # #define base0E #8f3f71
    # #define base0F #d65d0e

    # *.foreground:   base05
    # #ifdef background_opacity
    # *.background:   [background_opacity]base00
    # #else
    # *.background:   base00
    # #endif
    # *.cursorColor:  base05

    # *.color0:       base00
    # *.color1:       base08
    # *.color2:       base0B
    # *.color3:       base0A
    # *.color4:       base0D
    # *.color5:       base0E
    # *.color6:       base0C
    # *.color7:       base05

    # *.color8:       base03
    # *.color9:       base08
    # *.color10:      base0B
    # *.color11:      base0A
    # *.color12:      base0D
    # *.color13:      base0E
    # *.color14:      base0C
    # *.color15:      base07

    # ! Note: colors beyond 15 might not be loaded (e.g., xterm, urxvt),
    # ! use 'shell' template to set these if necessary
    # *.color16:      base09
    # *.color17:      base0F
    # *.color18:      base01
    # *.color19:      base02
    # *.color20:      base04
    # *.color21:      base06
    # '';
    # extraConfig = ''

    #    ! -----------------------------------------------------------------------------
    #    ! File: gruvbox-dark.xresources
    #    ! Description: Retro groove colorscheme generalized
    #    ! Author: morhetz <morhetz@gmail.com>
    #    ! Source: https://github.com/morhetz/gruvbox-generalized
    #    ! Last Modified: 6 Sep 2014
    #    ! -----------------------------------------------------------------------------

    #    ! hard contrast:
    #    *background: #1d2021
    #    ! medium contrast: *background: #282828
    #    ! soft contrast: *background: #32302f
    #    *foreground: #ebdbb2
    #    ! Black + DarkGrey
    #    *color0:  #282828
    #    *color8:  #928374
    #    ! DarkRed + Red
    #    *color1:  #cc241d
    #    *color9:  #fb4934
    #    ! DarkGreen + Green
    #    *color2:  #98971a
    #    *color10: #b8bb26
    #    ! DarkYellow + Yellow
    #    *color3:  #d79921
    #    *color11: #fabd2f
    #    ! DarkBlue + Blue
    #    *color4:  #458588
    #    *color12: #83a598
    #    ! DarkMagenta + Magenta
    #    *color5:  #b16286
    #    *color13: #d3869b
    #    ! DarkCyan + Cyan
    #    *color6:  #689d6a
    #    *color14: #8ec07c
    #    ! LightGrey + White
    #    *color7:  #a89984
    #    *color15: #ebdbb2
    # '';

      # ! special
      # *.foreground:   #d0d0d0
      # *.background:   #151515
      # *.cursorColor:  #d0d0d0

      # ! black
      # *.color0:       #151515
      # *.color8:       #505050

      # ! red
      # *.color1:       #ac4142
      # *.color9:       #ac4142

      # ! green
      # *.color2:       #90a959
      # *.color10:      #90a959

      # ! yellow
      # *.color3:       #f4bf75
      # *.color11:      #f4bf75

      # ! blue
      # *.color4:       #6a9fb5
      # *.color12:      #6a9fb5

      # ! magenta
      # *.color5:       #aa759f
      # *.color13:      #aa759f

      # ! cyan
      # *.color6:       #75b5aa
      # *.color14:      #75b5aa

      # ! white
      # *.color7:       #d0d0d0
      # *.color15:      #f5f5f5
  };

  # prevent clobbering SSH_AUTH_SOCK
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
