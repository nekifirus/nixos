{ pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  accounts.email = {
    accounts.nekifirus = {
      address = "nekifirus@gmail.com";
      gpg = {
        key = "nekifirus@gmail.com";
        signByDefault = true;
      };
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = "Nikita Mistyukov";
      signature = {
        text = ''
        '';
        showSignature = "append";
      };
      passwordCommand = "pass email/gmail.app-pass";
      smtp = {
        host = "smtp.gmail.com";
      };
      userName = "nekifirus@gmail.com";
    };
    accounts.nekifirus-yandex = {
      address = "nekifirus@yandex.ru";
      gpg = {
        key = "nekifirus@gmail.com";
        signByDefault = true;
      };
      imap.host = "imap.yandex.ru";
      imap.port = 993;
      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = false;
      realName = "Nikita Mistyukov";
      signature = {
        text = ''
        '';
        showSignature = "append";
      };
      passwordCommand = "pass email/yandex.app-pass";
      smtp = {
        host = "smtp.yandex.ru";
        port = 465;
      };
      userName = "nekifirus@yandex.ru";
    };
  };
}
