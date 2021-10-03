{ ... }:

{
  home-manager.users.nekifirus.programs.ssh.enable = false;
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
