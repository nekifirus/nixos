#!/bin/bash
# Database query wrapper - parses requests and executes via psql/sqlcmd
# Usage: db_query.sh "query postgres dev: SELECT * FROM users"
#        db_query.sh "mssql staging: SELECT COUNT(*) FROM orders"

set -euo pipefail

export PASSWORD_STORE_DIR="/home/nekifirus/.password-store"
export GNUPGHOME="/home/nekifirus/.gnupg"

if [ $# -eq 0 ]; then
    echo "Usage: db_query.sh \"<query request>\""
    echo "Examples:"
    echo "  db_query.sh \"query postgres dev: SELECT * FROM users\""
    echo "  db_query.sh \"mssql staging: SELECT COUNT(*) FROM orders\""
    exit 1
fi

REQUEST="$*"

# Parse: [query] <engine> <env>: <sql>
# Matches: "postgres dev: SELECT..." or "query mssql staging: SELECT..."
if [[ $REQUEST =~ ^query[[:space:]]+([a-z]+)[[:space:]]+([a-z]+)[[:space:]]*:[[:space:]]*(.*) ]]; then
    ENGINE="${BASH_REMATCH[1]}"
    ENV="${BASH_REMATCH[2]}"
    SQL="${BASH_REMATCH[3]}"
elif [[ $REQUEST =~ ^([a-z]+)[[:space:]]+([a-z]+)[[:space:]]*:[[:space:]]*(.*) ]]; then
    ENGINE="${BASH_REMATCH[1]}"
    ENV="${BASH_REMATCH[2]}"
    SQL="${BASH_REMATCH[3]}"
else
    echo "❌ Error: Could not parse request: $REQUEST" >&2
    exit 1
fi

# Normalize engine names
case "$ENGINE" in
    pg|postgresql|postgres) ENGINE="postgres" ;;
    mssql|sql|sqlserver|ms) ENGINE="mssql" ;;
    *) echo "❌ Error: Unknown database engine: $ENGINE" >&2; exit 1 ;;
esac

# Determine pass entry
if [ "$ENGINE" = "postgres" ]; then
    PASS_ENTRY="db/psql-$ENV"
else
    PASS_ENTRY="db/mssql-$ENV"
fi

# Read credentials from pass
read_pass_creds() {
    local entry="$1"
    if ! credentials=$(pass show "$entry" 2>/dev/null); then
        echo "❌ Error: Cannot read credentials from $entry" >&2
        return 1
    fi
    echo "$credentials"
}

# Parse pass file format:
# password
# :engine postgresql
# :dbhost localhost
# :dbport 5432
# :database dbname
# :dbuser username
parse_creds() {
    local creds="$1"
    local -A result

    local first=1
    while IFS= read -r line; do
        if [ $first -eq 1 ]; then
            result[password]="$line"
            first=0
        elif [[ $line =~ ^:([a-z]+)[[:space:]]+(.+)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local val="${BASH_REMATCH[2]}"
            result[$key]="$val"
        fi
    done <<< "$creds"

    # Output as KEY=VALUE format
    for key in "${!result[@]}"; do
        echo "${key}=${result[$key]}"
    done
}

# Execute query
execute_postgres() {
    local host="$1" port="$2" db="$3" user="$4" pass="$5" sql="$6"

    PGPASSWORD="$pass" psql \
        -h "$host" \
        -p "$port" \
        -U "$user" \
        -d "$db" \
        -c "$sql"
}

execute_mssql() {
    local host="$1" port="$2" db="$3" user="$4" pass="$5" sql="$6"

    # Using sqlcmd (from mssql-tools)
    sqlcmd \
        -S "${host},${port}" \
        -U "$user" \
        -P "$pass" \
        -d "$db" \
        -Q "$sql"
}

# Main execution
echo "📚 Connecting to $ENGINE ($ENV)..."

if ! creds_raw=$(read_pass_creds "$PASS_ENTRY"); then
    exit 1
fi

# Parse credentials
declare -A creds
while IFS='=' read -r key val; do
    creds[$key]="$val"
done < <(parse_creds "$creds_raw")

# Set defaults
DBHOST="${creds[dbhost]:-localhost}"
DBPORT="${creds[dbport]:-$([ "$ENGINE" = "postgres" ] && echo 5432 || echo 1433)}"
DBNAME="${creds[database]:-$([ "$ENGINE" = "postgres" ] && echo postgres || echo master)}"
DBUSER="${creds[dbuser]:-$([ "$ENGINE" = "postgres" ] && echo postgres || echo sa)}"
DBPASS="${creds[password]:-}"

echo "🔍 Executing query..."

if [ "$ENGINE" = "postgres" ]; then
    execute_postgres "$DBHOST" "$DBPORT" "$DBNAME" "$DBUSER" "$DBPASS" "$SQL"
else
    execute_mssql "$DBHOST" "$DBPORT" "$DBNAME" "$DBUSER" "$DBPASS" "$SQL"
fi
