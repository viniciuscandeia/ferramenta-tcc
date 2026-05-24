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
    echo "   Artefatos válidos: documentos-para-leigo/01-visao/01-visao-produto.md, documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md, documentos-tecnicos/03-documento/03-srs-completo.md, etc." >&2
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

# ──────────────────────────────────────────────
# Regra 2a: artefatos de M3/M4 proibidos em M1 e M2
# M3: documentos-tecnicos/03-documento/, documentos-para-leigo/03-documento/
#     documentos-tecnicos/04-spec/, documentos-tecnicos/05-tests/, documentos-tecnicos/04-revisao/
# ──────────────────────────────────────────────
if [[ "$MARCO" == "M1" || "$MARCO" == "M2" ]]; then
  M3_PATHS=(
    "documentos-tecnicos/03-documento"
    "documentos-para-leigo/03-documento"
    "documentos-tecnicos/04-spec"
    "documentos-tecnicos/05-tests"
    "documentos-tecnicos/04-revisao"
  )
  for M3_PATH in "${M3_PATHS[@]}"; do
    if [[ "$FILE_PATH" == *"$M3_PATH"* ]]; then
      echo "🔴 BLOQUEADO: '$FILE_PATH' é artefato de M3/M4, mas marco_corrente=$MARCO." >&2
      echo "   Aguardar Gate 2 aprovado antes de gerar artefatos de M3/M4." >&2
      exit 2
    fi
  done
  # Block .feature files regardless of path
  case "$BASENAME" in
    *.feature)
      echo "🔴 BLOQUEADO: arquivos .feature são artefatos de M3, mas marco_corrente=$MARCO." >&2
      exit 2
      ;;
  esac
fi

# ──────────────────────────────────────────────
# Regra 2b: artefatos de M2 proibidos em M1
# M2: documentos-tecnicos/02-requisitos/, documentos-para-leigo/02-requisitos/
# ──────────────────────────────────────────────
if [[ "$MARCO" == "M1" ]]; then
  if [[ "$FILE_PATH" == *"documentos-tecnicos/02-requisitos"* || "$FILE_PATH" == *"documentos-para-leigo/02-requisitos"* ]]; then
    echo "🔴 BLOQUEADO: '$FILE_PATH' é artefato de M2, mas marco_corrente=M1." >&2
    echo "   Aguardar Gate 1 aprovado antes de gerar artefatos de M2." >&2
    exit 2
  fi
fi

# ──────────────────────────────────────────────
# Regra 3: artefatos devem estar em documentos-para-leigo/ ou documentos-tecnicos/
# Exceções: arquivos de sistema na raiz do projeto
# ──────────────────────────────────────────────
SYSTEM_FILES=("estado-projeto.yaml" "_pendencias.md" "_migracao-log.md" "ONBOARDING.md")
IS_SYSTEM=0
for SF in "${SYSTEM_FILES[@]}"; do
  if [[ "$BASENAME" == "$SF" ]]; then
    IS_SYSTEM=1
    break
  fi
done

if [[ "$IS_SYSTEM" == "0" ]]; then
  if [[ "$FILE_PATH" != *"documentos-para-leigo/"* && "$FILE_PATH" != *"documentos-tecnicos/"* ]]; then
    # Allow _skipped.md and _pendencias.md anywhere (recovery files)
    case "$BASENAME" in
      _skipped.md|_pendencias.md|*.draft)
        ;;
      *)
        echo "🔴 BLOQUEADO: '$FILE_PATH' não está em documentos-para-leigo/ nem documentos-tecnicos/." >&2
        echo "   Todos os artefatos do projeto devem estar nessas pastas." >&2
        echo "   Verifique o path antes de criar o arquivo." >&2
        exit 2
        ;;
    esac
  fi
fi

exit 0
