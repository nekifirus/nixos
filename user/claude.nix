{ config, lib, pkgs, ... }:

let
  # Database query wrapper - reads credentials from pass, supports postgres and mssql
  db-query = pkgs.writeShellScriptBin "db-query" ''
    exec bash ${./db-tools/db_query.sh} "$@"
  '';

in
{
  home-manager.users.nekifirus = {
    home.packages = [
      pkgs.claude-code
      pkgs.google-cloud-sdk
      pkgs.jq           # JSON processor for configuration and data transformation
      pkgs.postgresql   # psql client
      pkgs.sqlcmd       # Microsoft SQL Server CLI (Go edition)
      db-query
    ];

    # Дополнительная конфигурация gcloud если нужна
    home.sessionVariables = {
      CLOUDSDK_PYTHON = "${pkgs.python3}/bin/python3";
    };
  };
}
