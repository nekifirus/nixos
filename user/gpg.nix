{ config, pkgs, lib, ... }:

let
  pinentryWithNotify = pkgs.writeShellScriptBin "pinentry" ''
    CALLER="неизвестно"
    CALLER_PID=$(${pkgs.iproute2}/bin/ss -xp 2>/dev/null \
      | grep 'S\.gpg-agent[^.]' \
      | grep -v '"gpg-agent"' \
      | grep -oP 'pid=\K[0-9]+' \
      | head -1)
    if [ -n "$CALLER_PID" ]; then
      CALLER=$(ps -p "$CALLER_PID" -o comm= 2>/dev/null || echo "неизвестно")
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
