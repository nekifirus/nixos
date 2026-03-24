{ config, pkgs, lib, ... }:

let
  pinentryWithNotify = pkgs.writeShellScriptBin "pinentry" ''
    # Ищем gpg/gpg2 процесс и поднимаемся по дереву, пропуская shell-процессы
    CALLER="неизвестно"
    SHELLS="bash sh dash zsh fish"

    GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg 2>/dev/null | head -1)
    [ -z "$GPG_PID" ] && GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg2 2>/dev/null | head -1)

    if [ -n "$GPG_PID" ]; then
      # Поднимаемся по дереву от gpg/gpg2, пропуская shell-процессы
      # Собираем до 2 значимых имён для цепочки "grandparent → parent"
      PID=$GPG_PID
      CHAIN=""
      FOUND=0
      for _ in 1 2 3 4 5; do
        PID=$(awk '/PPid:/{print $2}' /proc/$PID/status 2>/dev/null)
        [ -z "$PID" ] || [ "$PID" = "1" ] && break
        NAME=$(cat /proc/$PID/comm 2>/dev/null)
        [ -z "$NAME" ] && break
        # Убираем NixOS-обёртки вида .foo-wrapped → foo
        NAME=$(echo "$NAME" | sed 's/^\.//' | sed 's/-wrapped$//')
        # Пропускаем shell-процессы
        IS_SHELL=0
        for s in $SHELLS; do [ "$NAME" = "$s" ] && IS_SHELL=1 && break; done
        [ "$IS_SHELL" = "1" ] && continue
        # Останавливаемся на системных процессах
        case "$NAME" in systemd|login|sshd|gdm*|gnome-session*) break ;; esac
        # Не добавляем дубликаты подряд
        [ "$NAME" = "$LAST_NAME" ] && continue
        LAST_NAME="$NAME"
        CHAIN="$NAME''${CHAIN:+ → $CHAIN}"
        FOUND=$((FOUND + 1))
        [ "$FOUND" -ge 2 ] && break
      done
      [ -n "$CHAIN" ] && CALLER="$CHAIN"
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
