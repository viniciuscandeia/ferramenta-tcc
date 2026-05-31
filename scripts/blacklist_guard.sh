#!/usr/bin/env bash
# blacklist_guard.sh — PostToolUse hook para Write e Edit
#
# Após qualquer escrita em documentos-para-leigo/, verifica a blacklist D1
# completa (scripts/lib/blacklist.txt — 22 famílias). Se encontrar jargão técnico
# de ER → exit 2 (sinal de correção: Claude reescreve via traducao-leigo).
#
# Contexto: PostToolUse acontece APÓS o write — o arquivo já está em disco.
# exit 2 não previne a escrita; é um sinal de correção que retorna ao Claude
# via stderr, pedindo reescrita. O arquivo fica como rascunho até o gate.
#
# Protocolo Claude Code hooks: exit 2 = sinal de correção (stderr → Claude).
# v0.9.0: sem PyYAML; extração via python3 stdlib json.

set -euo pipefail

# Bypass para debug / testes manuais
if [[ "${CLAUDE_HOOKS_DISABLED:-0}" == "1" ]]; then
  exit 0
fi

# Ler payload do stdin
PAYLOAD=$(cat)

# Extrair file_path via python3 stdlib json (sem PyYAML)
FILE_PATH=$(/usr/bin/env python3 -c \
  "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" \
  <<< "$PAYLOAD" 2>/dev/null || true)

# ── Guardas de saída antecipada ────────────────────────────────────────────────

# file_path vazio → nada a verificar
[[ -z "$FILE_PATH" ]] && exit 0

# Escopo restrito: só documentos-para-leigo/ (técnicos podem ter jargão).
# estado-projeto.yaml na raiz nunca casa → sem loop infinito.
[[ "$FILE_PATH" != *"documentos-para-leigo/"* ]] && exit 0

# Rascunhos internos (.draft) nunca exibidos ao usuário → ignorar
case "$FILE_PATH" in *.draft) exit 0 ;; esac

# Arquivo não existe no disco (Edit que falhou / delete) → nada a verificar
[[ -f "$FILE_PATH" ]] || exit 0

# Shared lib de padrões
# ${CLAUDE_PLUGIN_ROOT:-} evita erro "unbound variable" se CC não injetou a var
# (o guard [[ -f ]] abaixo trata graciosamente o caso de path vazio/inválido)
BLACKLIST="${CLAUDE_PLUGIN_ROOT:-}/scripts/lib/blacklist.txt"
# Lib ausente (instalação parcial ou CLAUDE_PLUGIN_ROOT unset) → degradar silenciosamente
[[ -f "$BLACKLIST" ]] || exit 0

# ── Verificação da blacklist D1 ───────────────────────────────────────────────
# Ler do disco (uniformiza Write e Edit — em PostToolUse o write já foi aplicado).
# Process substitution <(...) evita consumir stdin (já lido por `cat` acima).
# grep -ioEf usa os padrões ERE filtrados; sort -u deduplica; head -20 limita output.
# grep -Ev filtra linhas de comentário (#) E linhas em branco (BSD grep falha com pattern vazio)
HITS=$(grep -ioEf <(grep -Ev '^[[:space:]]*(#|$)' "$BLACKLIST") "$FILE_PATH" 2>/dev/null \
  | sort -u | head -20 || true)

# Nenhum hit → arquivo leigo ok
[[ -z "$HITS" ]] && exit 0

# ── Sinal de correção → Claude ────────────────────────────────────────────────
{
  echo "🔴 BLACKLIST D1: '$FILE_PATH' contém jargão técnico de ER proibido na versão leigo."
  echo "   Termos encontrados:"
  while IFS= read -r termo; do
    [[ -n "$termo" ]] && echo "      • $termo"
  done <<< "$HITS"
  echo "   Ação obrigatória: invocar skill 'traducao-leigo' e reescrever o arquivo antes de prosseguir."
  echo "   (Arquivos em documentos-tecnicos/ podem conter esses termos — só documentos-para-leigo/ é restrito.)"
} >&2

exit 2
