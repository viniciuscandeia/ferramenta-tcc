#!/usr/bin/env bash
# message_display_guard.sh — MessageDisplay hook (detector / instrumento de métrica)
#
# IMPORTANTE: MessageDisplay é DISPLAY-ONLY. Não bloqueia e não corrige
# (exit 2 é ignorado; a transcrição e o que o Claude vê mantêm o original).
# Por isso este guard NÃO altera o texto exibido ao usuário — ele apenas MEDE:
# se a mensagem do assistente apresentada ao leigo contém jargão da blacklist
# D1, registra a ocorrência num log dentro do projeto. Serve como instrumento
# de avaliação (quantos vazamentos de jargão de ER chegam ao chat do leigo).
#
# A defesa primária contra jargão continua sendo: disciplina D1 (constitution),
# skill traducao-leigo e blacklist_guard.sh (arquivos documentos-para-leigo/).
#
# Reusa scripts/lib/blacklist.txt (mesmas famílias do blacklist_guard.sh).
# Só atua se houver projeto ativo (estado-projeto.yaml) → evita ruído em
# sessões de desenvolvimento/meta. Nunca quebra: exit 0; não emite displayContent.

set -euo pipefail

[[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]] && exit 0

# Ler payload do stdin (drena o stdin do hook)
PAYLOAD=$(cat)

# Localizar projeto ativo (estado-projeto.yaml em $PWD e até 3 níveis acima — D10)
PROJETO_DIR=""
SEARCH_DIR="$PWD"
for _ in 1 2 3; do
  if [[ -f "$SEARCH_DIR/estado-projeto.yaml" ]]; then
    PROJETO_DIR="$SEARCH_DIR"
    break
  fi
  SEARCH_DIR=$(dirname "$SEARCH_DIR")
done
[[ -z "$PROJETO_DIR" ]] && exit 0

# Lib de padrões da blacklist D1 (CLAUDE_PLUGIN_ROOT ou fallback relativo ao script)
BLACKLIST="${CLAUDE_PLUGIN_ROOT:-}/scripts/lib/blacklist.txt"
if [[ ! -f "$BLACKLIST" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  BLACKLIST="$SCRIPT_DIR/lib/blacklist.txt"
fi
[[ -f "$BLACKLIST" ]] || exit 0

# Extrair o texto exibido do payload. O nome do campo do MessageDisplay não é
# documentado de forma estável → best-effort: coletar recursivamente todos os
# valores string do JSON; se não for JSON, usar o texto cru.
TEXTO=$(/usr/bin/env python3 -c '
import json,sys
raw=sys.stdin.read()
def walk(x,out):
    if isinstance(x,str): out.append(x)
    elif isinstance(x,dict):
        for v in x.values(): walk(v,out)
    elif isinstance(x,list):
        for v in x: walk(v,out)
out=[]
try:
    walk(json.loads(raw),out)
    print("\n".join(out))
except Exception:
    print(raw)
' <<< "$PAYLOAD" 2>/dev/null || true)

[[ -z "$TEXTO" ]] && exit 0

# Verificar a blacklist (ERE; ignora comentários e linhas em branco da lib).
HITS=$(printf '%s' "$TEXTO" \
  | grep -ioEf <(grep -Ev '^[[:space:]]*(#|$)' "$BLACKLIST") 2>/dev/null \
  | sort -u | paste -sd', ' - || true)

[[ -z "$HITS" ]] && exit 0

# Registrar ocorrência (append-only). NÃO altera o texto exibido (sem displayContent).
LOG="$PROJETO_DIR/_metricas-jargao-chat.log"
TS=$(date '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || echo "?")
printf '%s\tjargao_chat\ttermos=[%s]\n' "$TS" "$HITS" >> "$LOG" 2>/dev/null || true

exit 0
