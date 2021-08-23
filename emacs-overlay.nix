{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/abc392cf4bd06dfa7b08fece4982445f845fbbe4.tar.gz;
    }))
  ];
}
