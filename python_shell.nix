# with import <nixpkgs> {};

# (python37.withPackages (ps: with ps; [pip jedi flake8 autopep8 celery twilio boto3])).env


with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "python";

  buildInputs = [
    bash
    libxml2
    libffi
    openssl
    glibc.static
    cmake
    ncurses
    # libxslt
    postgresql
    python38Packages.pip
    python38Packages.celery
    (python38.withPackages (ps: with ps; [requests jedi isort flake8 autopep8 celery]))
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
