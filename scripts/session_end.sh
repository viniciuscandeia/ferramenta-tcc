#!/usr/bin/env bash
# session_end.sh — SessionEnd hook
#
# Ao encerrar a sessão (normal ou abrupta), faz um commit-snapshot
# idempotente e não-destrutivo dos artefatos do projeto, reusando
# git_track.sh. Garante versionamento mesmo se a sessão terminar fora
# de um gate (ex.: usuário fecha o CLI no meio de um marco).
#
# Nunca quebra: exit 0 sempre. Degrada em silêncio se não houver projeto/git.
# Protocolo CC hooks: SessionEnd não pode bloquear; a saída é apenas informativa.

set -euo pipefail

[[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]] && exit 0

# Localizar o diretório do projeto (que contém estado-projeto.yaml), buscando
# em $PWD e até 3 níveis acima — mesma heurística do load_state.sh (D10).
PROJETO_DIR=""
SEARCH_DIR="$PWD"
for _ in 1 2 3; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    PROJETO_DIR="$SEARCH_DIR"
    break
  fi
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

# Sem projeto detectável → nada a versionar
[[ -z "$PROJETO_DIR" ]] && exit 0

# Resolver git_track.sh relativo a este script (robusto a CLAUDE_PLUGIN_ROOT ausente)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_TRACK="$SCRIPT_DIR/git_track.sh"
[[ -f "$GIT_TRACK" ]] || exit 0

# Commit-snapshot idempotente: git_track commit só efetiva se houver mudanças
# e retorna exit 0 mesmo sem git/mudanças.
bash "$GIT_TRACK" commit "$PROJETO_DIR" "chore: snapshot automático ao encerrar sessão" || true

exit 0
