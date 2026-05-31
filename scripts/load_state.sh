#!/usr/bin/env bash
# load_state.sh — SessionStart hook
#
# Verifica se existe estado-projeto.yaml no diretório de trabalho e
# injeta um resumo de contexto no ambiente para que o orquestrador
# possa retomar de onde parou sem ter que perguntar ao usuário.
#
# Protocolo Claude Code hooks: escreve para stdout (contexto adicional);
# exit 0 = sucesso; exit 1 = aviso não-fatal; exit 2 = erro fatal (não usar aqui).
# v0.9.0: eliminada dependência PyYAML (não distribuível); extração via grep/sed.

set -euo pipefail

if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

# Buscar estado-projeto.yaml no diretório corrente e um nível acima
STATE_YAML=""
SEARCH_DIR="$PWD"
for i in 1 2 3; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    STATE_YAML="$SEARCH_DIR/estado-projeto.yaml"
    break
  fi
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

if [[ -z "$STATE_YAML" ]]; then
  # Sem estado — projeto novo, nada a injetar
  exit 0
fi

# Extrair campos via grep/sed (sem PyYAML — não distribuível; D13)
MARCO=$(grep -m1 -E '^[[:space:]]*marco_corrente:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*marco_corrente:[[:space:]]*//; s/[[:space:]]*#.*//' || true)

# yaml existe mas campos ausentes / arquivo corrompido → silêncio
if [[ -z "$MARCO" ]]; then
  exit 0
fi

ULTIMA=$(grep -m1 -E '^[[:space:]]*ultima_atualizacao:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*ultima_atualizacao:[[:space:]]*//; s/[[:space:]]*#.*//; s/"//g' || true)

# gates: todas as linhas "gate_N: <status>" dentro do bloco gate_status
# tr + sed para separador consistente (BSD paste trata -d'; ' como 2 separadores alternados)
GATES=$(grep -E '^[[:space:]]*gate_[0-9]:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*//' | tr '\n' '|' | sed 's/|/ | /g; s/ | $//' || true)

# artefatos gerados: paths das entradas "- nome:" (até 8 para não poluir)
ARTEFATOS=$(grep -E '^[[:space:]]*-[[:space:]]*nome:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*-[[:space:]]*nome:[[:space:]]*//' | head -8 \
  | paste -sd', ' - || true)

# pautas abertas: valor inline da linha pautas_abertas
PAUTAS=$(grep -m1 -E '^[[:space:]]*pautas_abertas:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*pautas_abertas:[[:space:]]*//; s/[[:space:]]*#.*//' || true)

# lacunas_m1.contagem (campo aninhado — extrair o primeiro "contagem:" após "lacunas_m1:")
LACUNAS_COUNT=$(grep -A5 -m1 -E '^lacunas_m1:' "$STATE_YAML" 2>/dev/null \
  | grep -m1 -E '[[:space:]]*contagem:' \
  | sed -E 's/.*contagem:[[:space:]]*//' || true)

{
  echo "[RETOMADA DE PROJETO]"
  echo "Marco corrente: $MARCO"
  [[ -n "$GATES" ]] && echo "Gates: $GATES"
  [[ -n "$ARTEFATOS" ]] && echo "Artefatos gerados: $ARTEFATOS"
  [[ -n "$PAUTAS" && "$PAUTAS" != "[]" ]] && echo "Pautas em aberto: $PAUTAS"
  [[ -n "$LACUNAS_COUNT" && "$LACUNAS_COUNT" != "0" ]] && echo "Lacunas M1 pendentes (contagem): $LACUNAS_COUNT"
  [[ -n "$ULTIMA" ]] && echo "Última atualização: $ULTIMA"
  echo "Estado em: $STATE_YAML"
}

exit 0
