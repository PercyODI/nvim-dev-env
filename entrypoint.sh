#!/bin/bash
set -e

# Set working directory
cd "$WORKDIR"

# Find .devcontainer.json
if [ -f "$WORKDIR/.devcontainer/devcontainer.json" ]; then
    DEVCONTAINER_JSON="$WORKDIR/.devcontainer/devcontainer.json"
elif [ -f "$WORKDIR/.devcontainer.json" ]; then
    DEVCONTAINER_JSON="$WORKDIR/.devcontainer.json"
else
    DEVCONTAINER_JSON=""
fi

# --- Helper: Run onCreateCommand in any format ---
run_on_create_command() {
    local json="$1"
    local type
    type=$(jq -r 'type' <<< "$json")

    case "$type" in
        string)
            echo "🔧 Running onCreateCommand (string): $json"
            bash -c "$json"
            ;;
        array)
            echo "🔧 Running onCreateCommand (array):"
            local args=()
            # Convert JSON array to bash array
            while read -r element; do
                args+=("$element")
            done < <(jq -r '.[]' <<< "$json")
            echo "➤ ${args[*]}"
            "${args[@]}"
            ;;
        object)
            echo "🔧 Running onCreateCommand (object - parallel):"
            echo "$json" | jq -r 'to_entries[] | "\(.key): \(.value | @json)"' | while IFS=: read -r key value_json; do
                value=$(jq -r '.' <<< "$value_json")
                echo "➤ [$key] $value"

                # Detect inner type (string or array)
                cmd_type=$(jq -r 'type' <<< "$value_json")

                if [[ "$cmd_type" == "string" ]]; then
                    bash -c "$value" &
                elif [[ "$cmd_type" == "array" ]]; then
                    local args=()
                    while read -r element; do
                        args+=("$element")
                    done < <(jq -r '.[]' <<< "$value_json")
                    "${args[@]}" &
                else
                    echo "⚠️ Unsupported type in object value for key: $key"
                fi
            done

            wait  # wait for all background jobs to finish
            ;;
        *)
            echo "⚠️ Unknown onCreateCommand format: $type"
            ;;
    esac
}

# Run if onCreateCommand is present
if [ -n "$DEVCONTAINER_JSON" ]; then
    RAW_ON_CREATE=$(jq '.onCreateCommand // empty' "$DEVCONTAINER_JSON")
    if [ -n "$RAW_ON_CREATE" ] && [ "$RAW_ON_CREATE" != "null" ]; then
        run_on_create_command "$RAW_ON_CREATE"
    fi
fi

# Final shell hand-off
exec "$@"
