{ ... }:

{
  home-manager.users.nekifirus.programs.ssh.enable = false;
  services = {
    openssh = {
      enable = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };
}
