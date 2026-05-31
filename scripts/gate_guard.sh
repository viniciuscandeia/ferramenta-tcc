#!/usr/bin/env bash
# gate_guard.sh — PreToolUse hook para Write e Edit
#
# Bloqueia writes de artefatos fora da tabela canônica do marco corrente.
# Protocolo Claude Code hooks: recebe JSON via stdin; exit 2 = hard block.
#
# Para desabilitar em sessões de debug:
#   export CLAUDE_HOOKS_DISABLED=1
#
# v0.9.0: eliminada dependência PyYAML (não distribuível); extração via grep/sed.

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
    echo "   Consulte marcos/m{N}.md para a lista completa do marco corrente." >&2
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

# Ler marco_corrente via grep/sed (sem PyYAML — não distribuível)
MARCO=$(grep -m1 -E '^[[:space:]]*marco_corrente:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*marco_corrente:[[:space:]]*//; s/[[:space:]]*#.*//' || true)

if [[ -z "$MARCO" ]]; then
  exit 0
fi

# ──────────────────────────────────────────────
# Regra 2a: artefatos de M3/M4 proibidos em M1 e M2
# M3: documentos-tecnicos/03-documento/, documentos-para-leigo/03-documento/
#     documentos-tecnicos/04-spec/, documentos-tecnicos/05-tests/, documentos-tecnicos/04-revisao/
# ──────────────────────────────────────────────
if [[ "$MARCO" == "M1" || "$MARCO" == "M2" ]]; then
  # Paths canônicos confirmados por orchestrator.md e marcos/m3.md.
  # 03-documento casa por substring com 03-documento/04-spec e 03-documento/05-tests.
  # 04-revisao (M4) vive diretamente em documentos-tecnicos/04-revisao (não aninhado).
  M3_PATHS=(
    "documentos-tecnicos/03-documento"
    "documentos-para-leigo/03-documento"
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

# ──────────────────────────────────────────────
# Regra 4: Gate 1 — validação determinística antes de aprovar
# Intercepta Write/Edit em estado-projeto.yaml que contenha
# gate_status.gate_1: aprovado sem os pré-requisitos satisfeitos.
# ──────────────────────────────────────────────
if [[ "$BASENAME" == "estado-projeto.yaml" ]]; then
  CONTENT=$(echo "$TOOL_INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('content',''))" 2>/dev/null || true)

  if echo "$CONTENT" | grep -q "gate_1.*aprovado"; then
    CURRENT_STATE="${STATE_YAML:-}"

    PROJETO_DIR=""
    if [[ -n "$CURRENT_STATE" ]]; then
      # Extrair projeto_dir via grep/sed (sem PyYAML — não distribuível)
      PROJETO_DIR=$(grep -m1 -E '^[[:space:]]*projeto_dir:' "$CURRENT_STATE" 2>/dev/null \
        | sed -E 's/^[[:space:]]*projeto_dir:[[:space:]]*//; s/[[:space:]]*#.*//' || true)
    fi

    # Fallback: usar diretório onde está o estado-projeto.yaml
    if [[ -z "$PROJETO_DIR" ]] && [[ -n "$CURRENT_STATE" ]]; then
      PROJETO_DIR=$(dirname "$CURRENT_STATE")
    fi

    if [[ -n "$PROJETO_DIR" ]]; then
      GATE1_ERRORS=()

      # Verificar artefato normativo
      NORM_FILE="$PROJETO_DIR/documentos-tecnicos/01-visao/01-visao-produto.md"
      if [[ ! -f "$NORM_FILE" ]] || [[ ! -s "$NORM_FILE" ]]; then
        GATE1_ERRORS+=("MISSING: documentos-tecnicos/01-visao/01-visao-produto.md")
      fi

      # Verificar artefato leigo
      LEIGO_FILE="$PROJETO_DIR/documentos-para-leigo/01-visao/01-visao-produto.md"
      if [[ ! -f "$LEIGO_FILE" ]] || [[ ! -s "$LEIGO_FILE" ]]; then
        GATE1_ERRORS+=("MISSING: documentos-para-leigo/01-visao/01-visao-produto.md")
      fi

      # Verificar seções obrigatórias no artefato normativo
      if [[ -f "$NORM_FILE" ]]; then
        for SECTION in "## 1. Visão" "## 2. Problema" "## 4. Pessoas Envolvidas" "## 5. Contexto e Limites"; do
          if ! grep -q "$SECTION" "$NORM_FILE" 2>/dev/null; then
            GATE1_ERRORS+=("MISSING_SECTION: '${SECTION}' ausente em 01-visao-produto.md (normativo)")
          fi
        done
      fi

      # Verificar blacklist D1 completa no artefato leigo (22 famílias via shared lib)
      if [[ -f "$LEIGO_FILE" ]]; then
        BLACKLIST="${CLAUDE_PLUGIN_ROOT:-}/scripts/lib/blacklist.txt"
        if [[ -f "$BLACKLIST" ]]; then
          # Process substitution evita consumir stdin (já lido por `cat` no topo do script)
          # grep -Ev filtra comentários E linhas em branco (BSD grep falha com pattern vazio)
          BLACKLIST_HITS=$(grep -ioEf <(grep -Ev '^[[:space:]]*(#|$)' "$BLACKLIST") \
            "$LEIGO_FILE" 2>/dev/null | sort -u | head -3 || true)
        else
          # Lib ausente: fallback para regex parcial legada (9 famílias)
          BLACKLIST_HITS=$(grep -iE "requisito funcional|stakeholder|elicitação|\bescopo\b|\bgate [0-9]\b|EARS\b|Gherkin|MoSCoW|\bsprint\b|\bbacklog\b" "$LEIGO_FILE" 2>/dev/null | head -3 || true)
        fi
        if [[ -n "$BLACKLIST_HITS" ]]; then
          GATE1_ERRORS+=("BLACKLIST_D1: versão leigo contém jargão proibido (${BLACKLIST_HITS//$'\n'/, }) — aplicar traducao-leigo antes de aprovar")
        fi
      fi

      if [[ ${#GATE1_ERRORS[@]} -gt 0 ]]; then
        echo "🔴 GATE 1 BLOQUEADO: pré-condições não satisfeitas." >&2
        for ERR in "${GATE1_ERRORS[@]}"; do
          echo "   ❌ $ERR" >&2
        done
        echo "   Corrija os itens acima antes de marcar gate_status.gate_1: aprovado." >&2
        exit 2
      fi
    fi
  fi
fi

exit 0
