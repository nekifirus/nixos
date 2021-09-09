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
      emacsWithPackages = wrapper { inherit pkgs lib; } epkgs;

    in
      {
        packages.x86_64-linux.emacs = emacsWithPackages (
          epkgs: (
            with epkgs; [
              ag
              all-the-icons
              all-the-icons-dired
              all-the-icons-ivy
              base16-theme
              bind-key
              company
              company-box
              copy-as-format
              counsel
              counsel-projectile
              counsel-tramp
              diff-hl
              diminish
              direnv
              dired-du
              dockerfile-mode
              elixir-mode
              epl
              expand-region
              flycheck
              gitignore-mode
              go-mode
              google-this
              google-translate
              ibuffer-projectile
              ibuffer-vc
              ivy
              ivy-rich
              lsp-ivy
              lsp-mode
              lsp-ui
              lua-mode
              magit
              magit-popup
              markdown-mode
              mood-line
              multiple-cursors
              nix-mode
              no-littering
              notmuch
              org-bullets
              org-plus-contrib
              org-roam
              pdf-tools
              plantuml-mode
              poporg
              projectile
              protobuf-mode
              py-autopep8
              py-isort
              python-mode
              rainbow-delimiters
              rainbow-identifiers
              rainbow-mode
              reverse-im
              smart-comment
              smartparens
              swiper
              system-packages
              telega
              toc-org
              use-package
              use-package-ensure-system-package
              vue-mode
              which-key
              whole-line-or-region
              xresources-theme
              yaml-mode
              yasnippet
              yasnippet-snippets
            ]
          ) ++ [
            pkgs.ag
            pkgs.ffmpeg-full
            pkgs.gnupg
            pkgs.imagemagick
            pkgs.ispell
            pkgs.mu
            pkgs.notmuch
            pkgs.ripgrep
            pkgs.x265
            pkgs.sqlite
          ]
        );
        defaultPackage.x86_64-linux = self.packages.x86_64-linux.emacs;

      };
}
