{ ... }:

{
  services.openvpn.servers = {
    firstVPN  = {
      config = '' config /root/vpn/first_vpn.conf '';
      updateResolvConf = true;
    };
  };
}
