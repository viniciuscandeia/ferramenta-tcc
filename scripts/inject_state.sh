#!/usr/bin/env bash
# inject_state.sh — UserPromptSubmit hook
#
# Reinjeta um cabeçalho compacto (≤3 linhas) a cada turno para combater a
# diluição de contexto da arquitetura de persona inline (D25) em sessões longas.
#
# Protocolo Claude Code hooks: stdout JSON → additionalContext para Claude.
# exit 0 sempre (nunca bloquear prompt); silencioso se não há projeto.
# v0.9.0: sem PyYAML; extração via grep/sed; json emitido via python3 stdlib.

set -euo pipefail

if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

# ── Localizar estado-projeto.yaml (cwd + até 3 níveis acima) ─────────────────
# Igual à convenção de load_state.sh.
STATE=""
SEARCH_DIR="$PWD"
for _ in 1 2 3; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    STATE="$SEARCH_DIR/estado-projeto.yaml"
    break
  fi
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

# Sem projeto → silêncio total (não é erro; Claude Code pode abrir em qualquer pasta)
[[ -z "$STATE" ]] && exit 0

# ── Extrair campos via grep/sed (sem PyYAML) ──────────────────────────────────
MARCO=$(grep -m1 -E '^[[:space:]]*marco_corrente:' "$STATE" 2>/dev/null \
  | sed -E 's/^[[:space:]]*marco_corrente:[[:space:]]*//; s/[[:space:]]*#.*//' || true)

# Se marco_corrente ausente/ilegível → yaml corrompido ou projeto incompleto → silêncio
[[ -z "$MARCO" ]] && exit 0

# Gates aprovados: "gate_N: aprovado" dentro do bloco gate_status
GATES_OK=$(grep -E '^[[:space:]]*gate_[0-9]:[[:space:]]*aprovado' "$STATE" 2>/dev/null \
  | sed -E 's/^[[:space:]]*(gate_[0-9]):.*/\1/' | paste -sd',' - || true)
[[ -z "$GATES_OK" ]] && GATES_OK="nenhum"

# ── Montar cabeçalho compacto (≤3 linhas) ────────────────────────────────────
HEADER=$(printf '[ESTADO ATIVO] Marco: %s | Gates aprovados: %s\nBlacklist D1 ativa — jargão ER proibido em documentos-para-leigo/.\nSoT: estado-projeto.yaml (D13). Em caso de dúvida sobre o estado, releia o arquivo.' \
  "$MARCO" "$GATES_OK")

# ── Emitir JSON para UserPromptSubmit ────────────────────────────────────────
# Todo texto dentro do python3 print: stray stdout quebraria o JSON.
/usr/bin/env python3 -c '
import json, sys
header = sys.argv[1]
print(json.dumps({
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": header
  }
}))' "$HEADER"

exit 0
