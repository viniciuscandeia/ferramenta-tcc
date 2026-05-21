#!/usr/bin/env bash
# gate_guard.sh — PreToolUse hook para Write e Edit
#
# Bloqueia writes de artefatos fora da tabela canônica do marco corrente.
# Protocolo Claude Code hooks: recebe JSON via stdin; exit 2 = hard block.
#
# Para desabilitar em sessões de debug:
#   export CLAUDE_HOOKS_DISABLED=1

set -euo pipefail

# Bypass para debug
if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

# Ler tool_input do stdin
TOOL_INPUT=$(cat)

# Extrair file_path do JSON
FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Extrair apenas o nome do arquivo (basename)
BASENAME=$(basename "$FILE_PATH")

# ──────────────────────────────────────────────
# Regra 1: nomes proibidos (sem equivalente na tabela canônica)
# ──────────────────────────────────────────────
case "$BASENAME" in
  srs.md|fluxos.md|necessidades.md|requisitos.md|vision-box.md)
    echo "🔴 BLOQUEADO: '$BASENAME' não está na tabela canônica de artefatos." >&2
    echo "   Artefatos válidos: visao-produto-leigo.md, visao-produto-normativo.md, 03.1-funcionais.md, SRS-completo.md, etc." >&2
    echo "   Consulte core/marcos/m{N}.md para a lista completa do marco corrente." >&2
    exit 2
    ;;
esac

# ──────────────────────────────────────────────
# Regra 2: artefatos de marco futuro (requer estado-projeto.yaml)
# ──────────────────────────────────────────────
# Localizar estado-projeto.yaml a partir do diretório atual
STATE_YAML=""
SEARCH_DIR="$PWD"
for i in 1 2 3 4 5; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    STATE_YAML="$SEARCH_DIR/estado-projeto.yaml"
    break
  fi
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

if [[ -z "$STATE_YAML" ]]; then
  # Sem estado: só aplicar Regra 1 (já passou)
  exit 0
fi

# Ler marco_corrente
MARCO=$(python3 -c "
import sys
try:
    import yaml
    with open('$STATE_YAML') as f:
        d = yaml.safe_load(f)
    print(d.get('marco_corrente',''))
except Exception:
    print('')
" 2>/dev/null || true)

if [[ -z "$MARCO" ]]; then
  exit 0
fi

# Artefatos de M3 proibidos em M1 e M2
if [[ "$MARCO" == "M1" || "$MARCO" == "M2" ]]; then
  case "$BASENAME" in
    SRS-completo.md|SRS-completo-leigo.md|analyze-report.md|rastreabilidade.md|TESTING-STRATEGY.md|README-TESTS.md)
      echo "🔴 BLOQUEADO: '$BASENAME' é artefato de M3, mas marco_corrente=$MARCO." >&2
      echo "   Aguardar Gate 2 aprovado antes de gerar artefatos de M3." >&2
      exit 2
      ;;
    *.feature)
      echo "🔴 BLOQUEADO: arquivos .feature são artefatos de M3, mas marco_corrente=$MARCO." >&2
      exit 2
      ;;
  esac
fi

# Artefatos de M2 proibidos em M1
if [[ "$MARCO" == "M1" ]]; then
  case "$BASENAME" in
    03.1-funcionais.md|03.1-funcionais-leigo.md|03.2-qualidade.md|03.2-qualidade-leigo.md|\
    03.3-restricoes.md|03.3-restricoes-leigo.md|glossario.md|pautas-reelicitacao.md|\
    03.4-premissas.md|conflitos-detectados.md|elicitacao-raw.md)
      echo "🔴 BLOQUEADO: '$BASENAME' é artefato de M2, mas marco_corrente=M1." >&2
      echo "   Aguardar Gate 1 aprovado antes de gerar artefatos de M2." >&2
      exit 2
      ;;
  esac
fi

exit 0
