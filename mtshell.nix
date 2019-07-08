# This defines a function taking `pkgs` as parameter, and uses
# `nixpkgs` by default if no argument is passed to it.
{ pkgs ? import <nixpkgs> {} }:

# This avoids typing `pkgs.` before each package name.
with pkgs;

let

  inherit (lib) optional optionals;

in

# Defines a shell.
mkShell {
  # Sets the build inputs, i.e. what will be available in our
  # local environment.
  buildInputs = [
    git

    elixir
    erlang

    libtool
    autoconf
    automake
    gmp

 ]
 ++ optional stdenv.isLinux glibcLocales # To allow setting consistent locale on linux
 ++ optional stdenv.isLinux inotify-tools # For file_system
 ++ optional stdenv.isLinux libnotify # For ExUnit
 ;

 # Set up environment vars
 shellHook = ''
   export LANG="en_US.UTF-8"
   export LC_ALL="en_US.UTF-8"
   export PGDATA="$PWD/db"
 '';
}
