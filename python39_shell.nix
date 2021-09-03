# with import <nixpkgs> {};

# (python37.withPackages (ps: with ps; [pip jedi flake8 autopep8 celery twilio boto3])).env


with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "python39_shell";

  buildInputs = [
    bash
    glibc.static
    cmake
    tk
    (python39Full.withPackages (ps: with ps; [pip]))
  ];

  shellHook = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export PGDATA="$PWD/db"

    alias pip="PIP_PREFIX='$(pwd)/venv/lib/python3.9/site-packages' \pip"
    export PYTHONPATH="$(pwd)/venv/lib/python3.9/site-packages:$(pwd):$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
    source venv/bin/activate
  '';
}
