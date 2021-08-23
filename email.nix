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
      # passwordCommand = "gpg2 -q -d ~/.authinfo.gpg | awk 'FNR == 2 {print $6}'";
      smtp = {
        host = "smtp.gmail.com";
      };
      userName = "nekifirus@gmail.com";
    };
  };
}
