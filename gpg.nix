{ config, pkgs, lib, ... }:

{
  services.gpg-agent = {
    enable = true;
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

  # prevent clobbering SSH_AUTH_SOCK
  home.sessionVariables.GSM_SKIP_SSH_AGENT_WORKAROUND = "1";

  # Disable gnome-keyring ssh-agent
  xdg.configFile."autostart/gnome-keyring-ssh.desktop".text = ''
    ${lib.fileContents "${pkgs.gnome3.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
    Hidden=true
  '';
}
