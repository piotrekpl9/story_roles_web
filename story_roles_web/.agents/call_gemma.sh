#!/bin/bash
# =============================================================
# call_gemma.sh — wyślij prompt do Gemma 4 27B przez Ollama
# =============================================================
# Użycie:
#   bash .agents/call_gemma.sh "system prompt" "user prompt"
#   bash .agents/call_gemma.sh "system prompt" "user prompt" > output.md
#
# Wymaga: ollama serve (domyślnie localhost:11434)
# =============================================================

OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"
MODEL="${GEMMA_MODEL:-gemma3:27b}"

SYSTEM_PROMPT="$1"
USER_PROMPT="$2"

if [[ -z "$SYSTEM_PROMPT" || -z "$USER_PROMPT" ]]; then
    echo "Użycie: bash call_gemma.sh \"system prompt\" \"user prompt\""
    exit 1
fi

# Escape JSON
escape_json() {
    python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))" <<< "$1"
}

SYS_ESC=$(escape_json "$SYSTEM_PROMPT")
USR_ESC=$(escape_json "$USER_PROMPT")

curl -s "$OLLAMA_HOST/api/chat" \
    -d "{
        \"model\": \"$MODEL\",
        \"stream\": false,
        \"options\": {\"temperature\": 0.1, \"num_predict\": 8192},
        \"messages\": [
            {\"role\": \"system\", \"content\": $SYS_ESC},
            {\"role\": \"user\", \"content\": $USR_ESC}
        ]
    }" | python3 -c "import json,sys; print(json.loads(sys.stdin.read()).get('message',{}).get('content','ERROR: no response'))"
