with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "go-shell";

  buildInputs = [
    go
  ];

  shellHook = ''
    export GO111MODULE="on"
    export GOPATH="/home/nekifirus/go"
    export PATH="$GOPATH/bin:$PATH"
    export GOROOT="${go.out}/share/go"
  '';
}
