{ config, pkgs, lib, ... }:

let
  pinentryWithNotify = pkgs.writeShellScriptBin "pinentry" ''
    # Ищем gpg процесс через /proc и поднимаемся по дереву до реального инициатора
    CALLER="неизвестно"
    GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg 2>/dev/null | head -1)
    if [ -n "$GPG_PID" ]; then
      PARENT_PID=$(awk '/PPid:/{print $2}' /proc/$GPG_PID/status 2>/dev/null)
      PARENT_NAME=$(cat /proc/$PARENT_PID/comm 2>/dev/null)
      GPARENT_PID=$(awk '/PPid:/{print $2}' /proc/$PARENT_PID/status 2>/dev/null)
      GPARENT_NAME=$(cat /proc/$GPARENT_PID/comm 2>/dev/null)
      if [ -n "$GPARENT_NAME" ] && [ -n "$PARENT_NAME" ]; then
        CALLER="$GPARENT_NAME → $PARENT_NAME"
      elif [ -n "$PARENT_NAME" ]; then
        CALLER="$PARENT_NAME"
      fi
    fi
    ${pkgs.libnotify}/bin/notify-send \
      --icon=dialog-password \
      --urgency=normal \
      "GPG: запрос пароля" \
      "Приложение: $CALLER"
    exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@"
  '';
in

{
  services.pcscd.enable = true;
  home-manager.users.nekifirus.programs.ssh.enable = false;
  home-manager.users.nekifirus.programs.gpg.enable = true;
  home-manager.users.nekifirus.services.gpg-agent = {
    enable = true;
    pinentry.package = pinentryWithNotify;
    defaultCacheTtl = 1200;
    enableSshSupport = true;
    sshKeys = [
      "AB5D1B410584680A5E8B2C94A3B6EE46C295B2CD"
      # "1BAB252022782531597538185AA83E75A2428470"
    ];
    enableExtraSocket = true;
    extraConfig = ''
    allow-emacs-pinentry
    allow-loopback-pinentry
    '';
  };

  # prevent clobbering SSH_AUTH_SOCK
  home-manager.users.nekifirus.home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

}
