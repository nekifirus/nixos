{ config, pkgs, lib, ... }:

{
  imports = [
    ./email.nix
    ./emacs.nix
  ];

  services.syncthing = {
    enable = true;
    tray.enable = false;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # optional for nix flakes support
  programs.direnv.nix-direnv.enableFlakes = true;
  
  programs.rofi = {
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
            tmuxPlugins.resurrect
            {
              plugin = tmuxPlugins.continuum;
              extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '15' # minutes
                set -g status-right '#{continuum_status}'
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
    pinentryFlavor = null;
    defaultCacheTtl = 7200;
    enableSshSupport = true;
    sshKeys = [
      "AB5D1B410584680A5E8B2C94A3B6EE46C295B2CD"
      "1BAB252022782531597538185AA83E75A2428470"
    ];
    enableExtraSocket = true;
    extraConfig = ''
    allow-emacs-pinentry
    allow-loopback-pinentry
    '';
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
  };

  xresources = {
    properties = {
      "XTerm*font" = "*-fixed-*-*-*-*-*";
      "XTerm*faceName" = "pango:monospace";
      "XTerm*faceSize" = "12";
      "XTerm*termName" = "xterm-256color";
      "XTerm*metaSendsEscape" = true;
    };
    extraConfig = ''

       ! -----------------------------------------------------------------------------
       ! File: gruvbox-dark.xresources
       ! Description: Retro groove colorscheme generalized
       ! Author: morhetz <morhetz@gmail.com>
       ! Source: https://github.com/morhetz/gruvbox-generalized
       ! Last Modified: 6 Sep 2014
       ! -----------------------------------------------------------------------------

       ! hard contrast:
       *background: #1d2021
       ! medium contrast: *background: #282828
       ! soft contrast: *background: #32302f
       *foreground: #ebdbb2
       ! Black + DarkGrey
       *color0:  #282828
       *color8:  #928374
       ! DarkRed + Red
       *color1:  #cc241d
       *color9:  #fb4934
       ! DarkGreen + Green
       *color2:  #98971a
       *color10: #b8bb26
       ! DarkYellow + Yellow
       *color3:  #d79921
       *color11: #fabd2f
       ! DarkBlue + Blue
       *color4:  #458588
       *color12: #83a598
       ! DarkMagenta + Magenta
       *color5:  #b16286
       *color13: #d3869b
       ! DarkCyan + Cyan
       *color6:  #689d6a
       *color14: #8ec07c
       ! LightGrey + White
       *color7:  #a89984
       *color15: #ebdbb2
    '';

  };

  # prevent clobbering SSH_AUTH_SOCK
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';

  programs.home-manager.enable = true;
}
