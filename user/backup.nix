{ pkgs, ... }:

let
  backupScript = pkgs.writeShellScript "restic-backup" ''
    set -euo pipefail

    R2_ACCOUNT="$(${pkgs.pass}/bin/pass backup/r2-account-id)"
    export RESTIC_REPOSITORY="s3:https://$R2_ACCOUNT.r2.cloudflarestorage.com/nixos-backup"
    export RESTIC_PASSWORD="$(${pkgs.pass}/bin/pass backup/restic-password)"
    export AWS_ACCESS_KEY_ID="$(${pkgs.pass}/bin/pass backup/r2-access-key-id)"
    export AWS_SECRET_ACCESS_KEY="$(${pkgs.pass}/bin/pass backup/r2-secret-access-key)"

    echo "=== Restic backup started: $(date) ==="

    ${pkgs.restic}/bin/restic backup \
      --verbose \
      --one-file-system \
      /home/nekifirus \
      --exclude=/home/nekifirus/.cache \
      --exclude=/home/nekifirus/.npm \
      --exclude=/home/nekifirus/.m2 \
      --exclude=/home/nekifirus/.nix-profile \
      --exclude=/home/nekifirus/.nix-defexpr \
      --exclude=/home/nekifirus/.nix-channels \
      --exclude=/home/nekifirus/.local/share/pnpm \
      --exclude=/home/nekifirus/.local/share/virtualenv \
      --exclude=/home/nekifirus/.config/Slack \
      --exclude=/home/nekifirus/.config/google-chrome \
      --exclude=/home/nekifirus/.local/share/TelegramDesktop \
      --exclude=/home/nekifirus/.emacs.d/eln-cache \
      --exclude=/home/nekifirus/.emacs.d/elpa \
      --exclude=/home/nekifirus/org/clickup \
      --exclude='**/node_modules' \
      --exclude='**/target' \
      --exclude='**/__pycache__' \
      --exclude='**/.gradle' \
      --exclude=/home/nekifirus/mongodb \
      --exclude=/home/nekifirus/postgres \
      --exclude=/home/nekifirus/docker

    echo "=== Pruning old snapshots ==="

    ${pkgs.restic}/bin/restic forget \
      --keep-daily 7 \
      --keep-weekly 4 \
      --prune

    echo "=== Backup finished: $(date) ==="

    ${pkgs.libnotify}/bin/notify-send \
      --icon=drive-multidisk \
      --urgency=low \
      "Бэкап завершён" \
      "Restic → Cloudflare R2"
  '';

in

{
  home-manager.users.nekifirus.systemd.user.services.restic-backup = {
    Unit = {
      Description = "Restic backup to Cloudflare R2";
      After = [ "network-online.target" "gpg-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${backupScript}";
      # Нужны для pass + pinentry-gnome3
      Environment = [
        "DISPLAY=:0"
        "WAYLAND_DISPLAY=wayland-1"
        "GNUPGHOME=/home/nekifirus/.gnupg"
        "PASSWORD_STORE_DIR=/home/nekifirus/.password-store"
      ];
    };
  };

  home-manager.users.nekifirus.systemd.user.timers.restic-backup = {
    Unit.Description = "Daily restic backup at noon";
    Timer = {
      OnCalendar = "12:00";
      Persistent = true;   # запустить если пропустили (напр. машина была выключена)
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
