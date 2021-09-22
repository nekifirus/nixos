{ pkgs, ...}:

{
 virtualisation = {
    docker = {
      enable = true;
      extraOptions = "--data-root /home/nekifirus/docker";
    };

    libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
    };
 };
 networking.dhcpcd.denyInterfaces = [ "docker*" "ve*" "br*" ];
  
 environment.systemPackages = with pkgs; [  docker-compose ];
}
