{ config, pkgs, lib, ... }:

{
  services.openvpn.servers = {
    zenmateVPN  = {
      # config = "config /root/vpn/openvpn.ovpn";
      config = ''
client
remote 9-15-cz.cg-dialup.net 443
dev tun
proto udp

resolv-retry infinite
redirect-gateway def1
persist-key
persist-tun
nobind
cipher AES-256-CBC
auth SHA256
ping 15
ping-exit 90
ping-timer-rem
script-security 2
remote-cert-tls server
route-delay 5
verb 4
comp-lzo

ca /root/vpn/ca.crt
cert /root/vpn/client.crt
key /root/vpn/client.key
auth-user-pass /root/vpn/auth.cred
      '';
      autoStart = false;
      updateResolvConf = true;

    };
  };
}
