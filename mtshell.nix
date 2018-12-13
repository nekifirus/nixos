# This defines a function taking `pkgs` as parameter, and uses
# `nixpkgs` by default if no argument is passed to it.
{ pkgs ? import <nixpkgs> {} }:

# This avoids typing `pkgs.` before each package name.
with pkgs;

# Defines a shell.
mkShell {
  # Sets the build inputs, i.e. what will be available in our
  # local environment.
  buildInputs = [ 
    elixir
    erlang

    postgresql100
    hex2nix

    libtool
    autoconf
    automake
    gmp

 ];
}
