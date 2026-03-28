{ config, pkgs, lib, ... }:

let
  pinentryWithCaller = pkgs.writeShellScriptBin "pinentry" ''
    CALLER="unknown"
    SHELLS="bash sh dash zsh fish"

    # Debug: log all processes matching gpg/ssh - write to home dir for guaranteed access
    DEBUG_LOG="$HOME/.pinentry-debug.log"
    echo "DEBUG: USER=$USER" >> "$DEBUG_LOG"
    echo "DEBUG: All gpg processes: $(${pkgs.procps}/bin/pgrep -f gpg 2>/dev/null)" >> "$DEBUG_LOG"
    echo "DEBUG: pgrep -x gpg: $(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg 2>/dev/null)" >> "$DEBUG_LOG"
    echo "DEBUG: pgrep -x gpg2: $(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg2 2>/dev/null)" >> "$DEBUG_LOG"
    echo "DEBUG: pgrep -x ssh: $(${pkgs.procps}/bin/pgrep -u "$USER" -x ssh 2>/dev/null)" >> "$DEBUG_LOG"
    echo "DEBUG: ps aux | grep gpg:" >> "$DEBUG_LOG"
    ${pkgs.procps}/bin/ps aux | grep -E 'gpg|PID' >> "$DEBUG_LOG" 2>&1

    # Try exact match first, then pattern match
    GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg 2>/dev/null | head -1)
    [ -z "$GPG_PID" ] && GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x gpg2 2>/dev/null | head -1)
    [ -z "$GPG_PID" ] && GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -f "gpg" 2>/dev/null | grep -v gpg-agent | head -1)
    [ -z "$GPG_PID" ] && GPG_PID=$(${pkgs.procps}/bin/pgrep -u "$USER" -x ssh 2>/dev/null | head -1)

    echo "DEBUG: GPG_PID=$GPG_PID" >> "$DEBUG_LOG"
    if [ -n "$GPG_PID" ]; then
      PID=$GPG_PID; CHAIN=""; FOUND=0; LAST_NAME=""
      for _ in 1 2 3 4 5; do
        PID=$(awk '/PPid:/{print $2}' /proc/$PID/status 2>/dev/null)
        echo "DEBUG: Iteration PID=$PID" >> "$DEBUG_LOG"
        [ -z "$PID" ] || [ "$PID" = "1" ] && break
        NAME=$(cat /proc/$PID/comm 2>/dev/null)
        echo "DEBUG: NAME=$NAME" >> "$DEBUG_LOG"
        [ -z "$NAME" ] && break
        NAME=$(echo "$NAME" | sed 's/^\.//' | sed 's/-wrapped$//')
        IS_SHELL=0
        for s in $SHELLS; do [ "$NAME" = "$s" ] && IS_SHELL=1 && break; done
        [ "$IS_SHELL" = "1" ] && continue
        case "$NAME" in systemd|login|sshd|gdm*|gnome-session*) break ;; esac
        [ "$NAME" = "$LAST_NAME" ] && continue
        LAST_NAME="$NAME"
        CHAIN="$NAME''${CHAIN:+ -> $CHAIN}"
        FOUND=$((FOUND + 1))
        [ "$FOUND" -ge 2 ] && break
      done
      echo "DEBUG: Final CHAIN=$CHAIN" >> "$DEBUG_LOG"
      [ -n "$CHAIN" ] && CALLER="$CHAIN"
    fi
    echo "DEBUG: CALLER=$CALLER" >> "$DEBUG_LOG"

    # Прокси: перехватываем SETDESC и дописываем строку с caller'ом.
    # %0A = перенос строки в протоколе Assuan.
    exec ${pkgs.pinentry-gnome3}/bin/pinentry-gnome3 "$@" < <(
      while IFS= read -r line; do
        echo "DEBUG: Input line: $line" >> "$DEBUG_LOG"
        case "$line" in
          SETDESC*)
            MODIFIED=$(printf '%s%%0A%%0AFrom: %s\n' "$line" "$CALLER")
            echo "DEBUG: Modified SETDESC: $MODIFIED" >> "$DEBUG_LOG"
            printf '%s\n' "$MODIFIED"
            ;;
          *)
            printf '%s\n' "$line"
            ;;
        esac
      done
    )
  '';
in

{
  services.pcscd.enable = true;
  home-manager.users.nekifirus = {
    programs.ssh.enable = false;
    programs.gpg.enable = true;

    # Install pinentry wrapper in ~/.local/bin so it takes priority
    home.file.".local/bin/pinentry" = {
      source = "${pinentryWithCaller}/bin/pinentry";
      executable = true;
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1200;
      maxCacheTtl = 86400;  # 24ч — чтобы дневной бэкап нашёл кэшированный ключ
      enableSshSupport = true;
      sshKeys = [
        "AB5D1B410584680A5E8B2C94A3B6EE46C295B2CD"
        # "1BAB252022782531597538185AA83E75A2428470"
      ];
      enableExtraSocket = true;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
        pinentry-program /home/nekifirus/.local/bin/pinentry
      '';
    };

    # prevent clobbering SSH_AUTH_SOCK
    home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
  };
}
