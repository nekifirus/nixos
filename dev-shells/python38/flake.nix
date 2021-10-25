{
  description = "Python 3.8 development shell";

  outputs = { self, nixpkgs }: 
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      packages.x86_64-linux.python38 = pkgs.python38;
      packages.x86_64-linux.python38Packages.pip = pkgs.python38Packages.pip;
      packages.x86_64-linux.python38Packages.redis = pkgs.python38Packages.redis;
      packages.x86_64-linux.python38Packages.celery = pkgs.python38Packages.celery;
      packages.x86_64-linux.python38Packages.flower = pkgs.python38Packages.flower;
      packages.x86_64-linux.python38Packages.jedi = pkgs.python38Packages.jedi;
      packages.x86_64-linux.python38Packages.isort = pkgs.python38Packages.isort;
      packages.x86_64-linux.python38Packages.flake8 = pkgs.python38Packages.flake8;
      packages.x86_64-linux.python38Packages.autopep8 = pkgs.python38Packages.autopep8;
      packages.x86_64-linux.python38Packages.python-lsp-server = pkgs.python38Packages.python-lsp-server;
      
      devShell.x86_64-linux =  pkgs.mkShell {
        buildInputs = [
          self.packages.x86_64-linux.python38
          # self.packages.x86_64-linux.python38.withPackages (ps: with ps; [ pip ])
          self.packages.x86_64-linux.python38Packages.pip
          self.packages.x86_64-linux.python38Packages.jedi
          self.packages.x86_64-linux.python38Packages.isort
          self.packages.x86_64-linux.python38Packages.flake8
          self.packages.x86_64-linux.python38Packages.autopep8
          self.packages.x86_64-linux.python38Packages.celery
          self.packages.x86_64-linux.python38Packages.flower
          self.packages.x86_64-linux.python38Packages.python-lsp-server
        ];
        shellHook = ''
          export LANG="en_US.UTF-8"
          export LC_ALL="en_US.UTF-8"
          export PGDATA="$PWD/db"

          alias pip="PIP_PREFIX='$(pwd)/venv/lib/python3.8/site-packages' \pip"
          export PYTHONPATH="$(pwd)/venv/lib/python3.8/site-packages:$(pwd):$PYTHONPATH"
          unset SOURCE_DATE_EPOCH
          source venv/bin/activate
          echo ALLFINE
        '';
      };
  };
}
