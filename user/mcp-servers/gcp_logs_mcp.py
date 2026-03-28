#!/usr/bin/env python3
"""MCP server for GCP Cloud Logging (App Engine)."""

import json
import subprocess
import sys
import urllib.request
import urllib.parse
from datetime import datetime, timezone, timedelta
from typing import Any

# MCP protocol via stdio
def send(msg: dict):
    line = json.dumps(msg)
    sys.stdout.write(line + "\n")
    sys.stdout.flush()

def err_response(id_, code: int, message: str) -> dict:
    return {"jsonrpc": "2.0", "id": id_, "error": {"code": code, "message": message}}

def ok_response(id_, result: Any) -> dict:
    return {"jsonrpc": "2.0", "id": id_, "result": result}

# ── GCP helpers ──────────────────────────────────────────────────────────────

def get_token() -> str:
    """Get access token via gcloud CLI."""
    result = subprocess.run(
        ["gcloud", "auth", "print-access-token"],
        capture_output=True, text=True, timeout=10
    )
    if result.returncode != 0:
        raise RuntimeError(f"gcloud error: {result.stderr.strip()}")
    return result.stdout.strip()

def get_project() -> str:
    """Get current GCP project."""
    result = subprocess.run(
        ["gcloud", "config", "get-value", "project"],
        capture_output=True, text=True, timeout=10
    )
    if result.returncode != 0 or not result.stdout.strip():
        raise RuntimeError("No active GCP project. Run: gcloud config set project YOUR_PROJECT")
    return result.stdout.strip()

def query_logs(project: str, token: str, filter_str: str, page_size: int = 200) -> list[dict]:
    """Query Cloud Logging API."""
    url = "https://logging.googleapis.com/v2/entries:list"
    payload = json.dumps({
        "resourceNames": [f"projects/{project}"],
        "filter": filter_str,
        "orderBy": "timestamp desc",
        "pageSize": page_size,
    }).encode()

    req = urllib.request.Request(
        url,
        data=payload,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST"
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.loads(resp.read())
    return data.get("entries", [])

def format_entry(e: dict) -> str:
    """Format a log entry to readable text."""
    ts = e.get("timestamp", "")[:19].replace("T", " ")
    sev = e.get("severity", "DEFAULT")
    text = (
        e.get("textPayload")
        or e.get("jsonPayload", {}).get("message")
        or json.dumps(e.get("jsonPayload", {}))
        or e.get("protoPayload", {}).get("methodName", "")
        or "(no message)"
    )
    return f"[{ts}] [{sev:8}] {text}"

def time_filter(minutes: int) -> str:
    dt = datetime.now(timezone.utc) - timedelta(minutes=minutes)
    return dt.strftime('%Y-%m-%dT%H:%M:%SZ')

# ── Tool implementations ──────────────────────────────────────────────────────

def tool_get_logs(args: dict) -> str:
    minutes = int(args.get("minutes", 60))
    severity = args.get("severity", "").upper()
    search = args.get("search", "")
    limit = min(int(args.get("limit", 200)), 500)
    project = args.get("project") or get_project()

    token = get_token()

    parts = [f'timestamp >= "{time_filter(minutes)}"']
    parts.append('resource.type="gae_app"')
    if severity and severity != "ALL":
        parts.append(f'severity>={severity}')
    if search:
        parts.append(f'textPayload:"{search}"')

    entries = query_logs(project, token, " AND ".join(parts), page_size=limit)
    if not entries:
        return f"Логи не найдены (проект: {project}, период: {minutes} мин)"

    lines = [f"=== {len(entries)} записей | проект: {project} | период: {minutes} мин ===\n"]
    lines += [format_entry(e) for e in entries]
    return "\n".join(lines)


def tool_search_errors(args: dict) -> str:
    minutes = int(args.get("minutes", 60))
    project = args.get("project") or get_project()
    token = get_token()

    f = (
        f'timestamp >= "{time_filter(minutes)}" '
        f'AND resource.type="gae_app" '
        f'AND severity>=ERROR'
    )
    entries = query_logs(project, token, f, page_size=500)
    if not entries:
        return f"Ошибок не найдено за последние {minutes} минут. Всё чисто ✓"

    lines = [f"=== {len(entries)} ошибок за {minutes} мин | проект: {project} ===\n"]
    lines += [format_entry(e) for e in entries]
    return "\n".join(lines)


def tool_get_summary(args: dict) -> str:
    minutes = int(args.get("minutes", 60))
    project = args.get("project") or get_project()
    token = get_token()

    counts = {}
    all_entries = []
    for sev in ["DEFAULT", "INFO", "WARNING", "ERROR", "CRITICAL"]:
        f = (
            f'timestamp >= "{time_filter(minutes)}" '
            f'AND resource.type="gae_app" '
            f'AND severity="{sev}"'
        )
        entries = query_logs(project, token, f, page_size=500)
        counts[sev] = len(entries)
        all_entries.extend(entries)

    total = sum(counts.values())
    lines = [
        f"=== Сводка логов | проект: {project} | период: {minutes} мин ===",
        f"Всего записей: {total}",
        "",
        "По severity:",
    ]
    for sev, count in counts.items():
        bar = "█" * min(count // 5 + (1 if count else 0), 30)
        lines.append(f"  {sev:10} {count:5}  {bar}")

    # Last 3 errors
    errors = [e for e in all_entries if e.get("severity") in ("ERROR", "CRITICAL")]
    if errors:
        lines += ["", "Последние ошибки:"]
        for e in errors[:3]:
            lines.append("  " + format_entry(e))

    return "\n".join(lines)


def tool_get_request_errors(args: dict) -> str:
    """Find HTTP 5xx errors in App Engine request logs."""
    minutes = int(args.get("minutes", 60))
    project = args.get("project") or get_project()
    token = get_token()

    f = (
        f'timestamp >= "{time_filter(minutes)}" '
        f'AND resource.type="gae_app" '
        f'AND httpRequest.status>=500'
    )
    entries = query_logs(project, token, f, page_size=200)
    if not entries:
        return f"HTTP 5xx ошибок не найдено за {minutes} мин ✓"

    lines = [f"=== {len(entries)} HTTP 5xx ошибок | {minutes} мин ===\n"]
    for e in entries:
        ts = e.get("timestamp", "")[:19].replace("T", " ")
        req = e.get("httpRequest", {})
        status = req.get("status", "?")
        method = req.get("requestMethod", "?")
        url = req.get("requestUrl", "?")
        latency = req.get("latency", "")
        lines.append(f"[{ts}] {status} {method} {url} {latency}")

    return "\n".join(lines)

# ── MCP protocol ─────────────────────────────────────────────────────────────

TOOLS = [
    {
        "name": "get_logs",
        "description": "Получить логи App Engine из GCP Cloud Logging. Поддерживает фильтр по времени, severity и тексту.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "minutes": {"type": "integer", "description": "За сколько минут назад (по умолчанию 60)", "default": 60},
                "severity": {"type": "string", "description": "Минимальный уровень: DEFAULT, INFO, WARNING, ERROR, CRITICAL", "default": "DEFAULT"},
                "search": {"type": "string", "description": "Текст для поиска в логах"},
                "limit": {"type": "integer", "description": "Максимум записей (до 500)", "default": 200},
                "project": {"type": "string", "description": "GCP project ID (если не указан — берётся из gcloud config)"},
            },
        },
    },
    {
        "name": "search_errors",
        "description": "Быстро найти все ошибки (ERROR и CRITICAL) в App Engine логах за указанный период.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "minutes": {"type": "integer", "description": "За сколько минут (по умолчанию 60)", "default": 60},
                "project": {"type": "string", "description": "GCP project ID (опционально)"},
            },
        },
    },
    {
        "name": "get_log_summary",
        "description": "Сводка логов по severity за период: количество записей каждого типа и последние ошибки.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "minutes": {"type": "integer", "description": "За сколько минут (по умолчанию 60)", "default": 60},
                "project": {"type": "string", "description": "GCP project ID (опционально)"},
            },
        },
    },
    {
        "name": "get_request_errors",
        "description": "Найти HTTP 5xx ошибки в App Engine request логах.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "minutes": {"type": "integer", "description": "За сколько минут (по умолчанию 60)", "default": 60},
                "project": {"type": "string", "description": "GCP project ID (опционально)"},
            },
        },
    },
]

TOOL_FN = {
    "get_logs": tool_get_logs,
    "search_errors": tool_search_errors,
    "get_log_summary": tool_get_summary,
    "get_request_errors": tool_get_request_errors,
}

def handle(msg: dict) -> dict | None:
    method = msg.get("method")
    id_ = msg.get("id")

    if method == "initialize":
        return ok_response(id_, {
            "protocolVersion": "2024-11-05",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "gcp-logs-mcp", "version": "1.0.0"},
        })

    if method == "tools/list":
        return ok_response(id_, {"tools": TOOLS})

    if method == "tools/call":
        name = msg.get("params", {}).get("name")
        args = msg.get("params", {}).get("arguments", {})
        fn = TOOL_FN.get(name)
        if not fn:
            return err_response(id_, -32601, f"Unknown tool: {name}")
        try:
            result = fn(args)
            return ok_response(id_, {"content": [{"type": "text", "text": result}]})
        except Exception as e:
            return ok_response(id_, {"content": [{"type": "text", "text": f"Ошибка: {e}"}], "isError": True})

    if method == "notifications/initialized":
        return None  # no response needed

    if id_ is not None:
        return err_response(id_, -32601, f"Method not found: {method}")
    return None


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        response = handle(msg)
        if response is not None:
            send(response)

if __name__ == "__main__":
    main()
