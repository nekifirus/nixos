{ ... }:

{
  users.users = {
    nekifirus = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "libvirtd"
        "postgres"
      ];
       openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCU+aodVr7bnz8TZYfJ+CZvcZ9IKgGswND3uN1w/W3rF/ZxqPSIE4KdEgacmWQSCS5AO3oKtimGKLncIovtEL0BRynJZDdPfDOjS98RvwCh0Fg6eLZ2EPPFsppPhMxUrPAwbkzZ1BO3N/jlSafpjyG2Rk19RppmtBiBPoilcRL7RoRZnxTnTkBMdD1t11BdyRnuJhA5XYNuv8+4c6WXM6jahRUuQPyw3vi2JMFhKKMY5EKlY1CLoitO8M1IDGOYsdWZ7q93UkcEkfMFoZcD3vS8JCbAhO1MVRTaUF/XNmqAFXwYQbvr7EXR5lmLtAS+bVtLa2V+1Jp1mxH+4zM490idvql0uf0XrB86hcOm3WE5L1hgKjte+H6d4e8CyHInUH2NMvYpje7JqDLS/H/3tKG3Q3I5sqX7nW+ZL18ms+Mh5JuhfcggURpl06sBHicEW8NIkZ2KaFolCwdSm90N5gJ4Sc2V2mIGFMFAOVVrxfCWQXga3tHAuDAi4f00g6mOHXKx32712d6TSc9MU23XaYDqgRU8542Vj7lYPJ2gbJSA4UOlMzrhsyp1r7K7TVfxKuE0WfQg0N63JNfff8g7e5hjcSurUaPskRJ0jN00+sNvTlBkfrx89y5uBjDvQn/sc8YYkXsyTw9+68uKUjnKui7oZjWZOl0W7CJ0ijbF0WVs0Q== (none)" ];
    };
  };
}
