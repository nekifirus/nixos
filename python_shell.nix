with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "python";

  buildInputs = [
    bash
    libxml2
    # libxslt
    postgresql
    (python37.withPackages (ps: with ps; [pip elpy jedi flake8 autopep8 celery]))
  ];

  shellHook = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export PGDATA="$PWD/db"

    alias pip="PIP_PREFIX='$(pwd)/venv/lib/python3.7/site-packages' \pip"
    export PYTHONPATH="$(pwd)/venv/lib/python3.7/site-packages:PYTHONPATH"
    unset SOURCE_DATE_EPOCH
    source venv/bin/activate
  '';
}
