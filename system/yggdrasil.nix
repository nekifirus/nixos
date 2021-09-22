{ ... }:

{
  services.yggdrasil = {
    enable = false;
    persistentKeys = false;
      # The NixOS module will generate new keys and a new IPv6 address each time
      # it is started if persistentKeys is not enabled.

    config = {
      Peers = [
        # Yggdrasil will automatically connect and "peer" with other nodes it
        # discovers via link-local multicast annoucements. Unless this is the
        # case (it probably isn't) a node needs peers within the existing
        # network that it can tunnel to.
        "tcp://ygg-nl.incognet.io:8883"
        "tls://65.21.57.122:61995"
        "tcp://1.2.3.4:1024"
        "tcp://1.2.3.5:1024"
        # Public peers can be found at
        # https://github.com/yggdrasil-network/public-peers
      ];
    };
  };
}
