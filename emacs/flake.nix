{
  description = "My awesome emacs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";
    
  outputs = { self, nixpkgs, emacs-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ emacs-overlay.overlay ];
      };
      lib = pkgs.lib;
      myEmacs = pkgs.emacs;
      epkgs = (pkgs.emacsPackagesFor myEmacs);
      
      wrapper = { pkgs, lib }: import ./wrapper.nix {
        inherit (pkgs) makeWrapper runCommand gcc;
        inherit (pkgs.xorg) lndir;
        inherit lib;
      };
      emacsWithPackages = wrapper { inherit pkgs lib ; } epkgs; 
      
    in {
      packages.x86_64-linux.emacs = emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
        magit
        which-key
        ivy-rich
      ]) ++ (with epkgs.melpaPackages; [ 
      ]) ++ (with epkgs.elpaPackages; [ 
      ]) ++ [
        pkgs.figlet
        pkgs.notmuch   # From main packages set
        pkgs.ffmpeg-full
        pkgs.bash
      ]);
      packages.x86_64-linux.figlet = pkgs.figlet;
      defaultPackage.x86_64-linux = self.packages.x86_64-linux.emacs;
      
    };
}
