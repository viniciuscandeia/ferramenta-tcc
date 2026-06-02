#!/usr/bin/env bash
# todo_guard.sh — PreToolUse hook para TodoWrite
#
# Antes de qualquer chamada TodoWrite, verifica se os textos dos todos
# contêm jargão técnico de ER (blacklist D1). Se encontrar → exit 2
# (sinal de correção: Claude reescreve os textos em linguagem leigo antes
# de chamar TodoWrite novamente).
#
# Contexto: PreToolUse acontece ANTES da chamada — bloqueia a exibição
# de jargão ao usuário via lista de progresso.
#
# Protocolo Claude Code hooks: exit 2 = sinal de correção (stderr → Claude).
# D27: TodoWrite é superfície de progresso leigo — D1 aplica integralmente.
# v0.18.0

set -euo pipefail

# Bypass para debug / testes manuais
if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

# Ler payload do stdin
PAYLOAD=$(cat)

# Extrair textos de todos via python3 stdlib json
# tool_input.todos[].content — array de strings
TODO_TEXTS=$(/usr/bin/env python3 -c \
  "import json,sys
d=json.load(sys.stdin)
todos=d.get('tool_input',{}).get('todos',[])
print('\n'.join(t.get('content','') for t in todos if t.get('content','').strip()))" \
  <<< "$PAYLOAD" 2>/dev/null || true)

# Nada a verificar (lista vazia ou sem content)
[[ -z "$TODO_TEXTS" ]] && exit 0

# Shared lib de padrões — mesma blacklist usada por blacklist_guard.sh
# ${CLAUDE_PLUGIN_ROOT:-} evita erro "unbound variable" se CC não injetou a var
BLACKLIST="${CLAUDE_PLUGIN_ROOT:-}/scripts/lib/blacklist.txt"
# Lib ausente (instalação parcial) → degradar silenciosamente
[[ -f "$BLACKLIST" ]] || exit 0

# Verificar todos os textos contra a blacklist D1
HITS=$(echo "$TODO_TEXTS" | grep -ioEf <(grep -Ev '^[[:space:]]*(#|$)' "$BLACKLIST") 2>/dev/null \
  | sort -u | head -20 || true)

# Nenhum hit → todos leigo ok
[[ -z "$HITS" ]] && exit 0

# Sinal de correção → Claude
{
  echo "🔴 TODO_GUARD D27: textos de TodoWrite contêm jargão técnico de ER proibido (D1)."
  echo "   Termos encontrados:"
  while IFS= read -r termo; do
    [[ -n "$termo" ]] && echo "      • $termo"
  done <<< "$HITS"
  echo "   Ação obrigatória: reescrever os textos dos todos em linguagem leigo"
  echo "   (frases-objetivo, sem nome de skill/marco/gate) antes de chamar TodoWrite."
  echo "   Ver MAPA DE PROGRESSO em content/orchestrator.md para os textos sancionados."
} >&2

exit 2
