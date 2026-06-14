#!/usr/bin/env bash
# pre_compact.sh — PreCompact hook
#
# Antes da compactação de contexto (manual ou automática), re-emite o resumo
# do estado-projeto.yaml para que o marco corrente, gates e pautas sobrevivam
# à compactação em sessões longas. Reforça D13 + anti-diluição, complementando
# inject_state.sh (UserPromptSubmit) e load_state.sh (SessionStart).
#
# Reusa a extração do load_state.sh (fonte única de verdade do resumo de
# estado) para evitar divergência. Nunca quebra: exit 0 sempre.

set -euo pipefail

[[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]] && exit 0

# Só re-injeta se houver projeto detectável (mesma heurística do load_state.sh/D10);
# evita poluir o contexto com um cabeçalho órfão quando não há projeto ativo.
SEARCH_DIR="$PWD"; FOUND=""
for _ in 1 2 3; do
  [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]] && { FOUND=1; break; }
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done
[[ -z "$FOUND" ]] && exit 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOAD_STATE="$SCRIPT_DIR/load_state.sh"
[[ -f "$LOAD_STATE" ]] || exit 0

echo "[SNAPSHOT PRÉ-COMPACTAÇÃO — preservar o estado abaixo após compactar]"
bash "$LOAD_STATE" || true

exit 0
