{ config, lib, pkgs, ... }:

let
  # MCP сервер для Google Cloud Logging
  gcp-logs-mcp = pkgs.writeShellScriptBin "gcp-logs-mcp" ''
    exec ${pkgs.python3}/bin/python3 ${./mcp-servers/gcp_logs_mcp.py} "$@"
  '';

  mcpCommand = "${gcp-logs-mcp}/bin/gcp-logs-mcp";

in
{
  home-manager.users.nekifirus = {
    home.packages = [
      pkgs.claude-code
      pkgs.google-cloud-sdk  # gcloud CLI
      gcp-logs-mcp
    ];

    # MCP сервер конфигурация для Claude Code
    home.file.".mcp.json" = {
      enable = true;
      text = lib.generators.toJSON {} {
        mcpServers = {
          gcp-logs = {
            command = mcpCommand;
          };
        };
      };
    };

    # Дополнительная конфигурация gcloud если нужна
    home.sessionVariables = {
      CLOUDSDK_PYTHON = "${pkgs.python3}/bin/python3";
    };
  };
}
