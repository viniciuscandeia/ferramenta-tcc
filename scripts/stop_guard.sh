#!/usr/bin/env bash
# stop_guard.sh — Stop hook: impede finalização precoce do fluxo da ferramenta.
#
# Dispara quando o agente principal vai encerrar o turno. Se o projeto ainda
# está em andamento (marco != concluido) e o usuário NÃO pediu pausa, devolve
# exit 2 + stderr (sinal de continuação): o modelo deve encadear o próximo passo
# em vez de parar silenciosamente (bug "encerrou sozinho, sem mensagem").
#
# Estados terminais legítimos (permite parar — exit 0):
#   - stop_hook_active == true  → continuação já induzida por este hook (anti-loop)
#   - sem estado-projeto.yaml    → não é um projeto da ferramenta
#   - marco_corrente == concluido → projeto entregue
#   - sessao_pausada == true      → usuário pediu pausa
#
# Observação: perguntas ao usuário passam por AskUserQuestion (tool call), que
# NÃO dispara Stop — logo, um Stop com projeto em andamento = parada indevida.
#
# Protocolo Claude Code: Stop hook; exit 2 = bloqueia a parada, stderr → modelo.
# v0.23.0

set -euo pipefail

# Bypass para debug / testes manuais
if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

PAYLOAD=$(cat)

# Anti-loop: se já estamos numa continuação induzida por Stop hook, permitir parar
STOP_ACTIVE=$(/usr/bin/env python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('stop_hook_active', False))" \
  <<< "$PAYLOAD" 2>/dev/null || true)
[[ "$STOP_ACTIVE" == "True" ]] && exit 0

# Localizar estado-projeto.yaml subindo a partir do cwd (PROJETO_DIR = cwd no fluxo canônico)
STATE_YAML=""
SEARCH_DIR="$PWD"
for _i in 1 2 3 4 5; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    STATE_YAML="$SEARCH_DIR/estado-projeto.yaml"
    break
  fi
  [[ "$SEARCH_DIR" == "/" ]] && break
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done

# Sem estado → não é projeto da ferramenta; permitir parar
[[ -z "$STATE_YAML" ]] && exit 0

# Ler marco_corrente e sessao_pausada (grep/sed — sem PyYAML, não distribuível)
MARCO=$(grep -m1 -E '^[[:space:]]*marco_corrente:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*marco_corrente:[[:space:]]*//; s/[[:space:]]*#.*//; s/[[:space:]]*$//' || true)
PAUSADA=$(grep -m1 -E '^[[:space:]]*sessao_pausada:' "$STATE_YAML" 2>/dev/null \
  | sed -E 's/^[[:space:]]*sessao_pausada:[[:space:]]*//; s/[[:space:]]*#.*//; s/[[:space:]]*$//' || true)

# Estados terminais legítimos → permitir parar
[[ "$MARCO" == "concluido" ]] && exit 0
[[ "$PAUSADA" == "true" ]] && exit 0

# Projeto em andamento sem pausa → finalização precoce: sinal de continuação
{
  echo "🔴 STOP_GUARD: fluxo do produto não concluído (etapa atual: ${MARCO:-desconhecida}) e sem pausa do usuário."
  echo "   NÃO encerre o turno. Continue o fluxo: invoque a próxima etapa/skill da etapa corrente."
  echo "   Se precisar de algo do usuário, faça uma pergunta via AskUserQuestion (isso não encerra o turno)."
  echo "   Só é permitido encerrar quando: marco_corrente=concluido, sessao_pausada=true,"
  echo "   ou há uma pergunta AskUserQuestion aguardando resposta."
} >&2
exit 2
