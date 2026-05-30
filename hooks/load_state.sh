#!/usr/bin/env bash
# load_state.sh — SessionStart hook
#
# Verifica se existe estado-projeto.yaml no diretório de trabalho e
# injeta um resumo de contexto no ambiente para que o orquestrador
# possa retomar de onde parou sem ter que perguntar ao usuário.
#
# Protocolo Claude Code hooks: escreve para stdout (contexto adicional);
# exit 0 = sucesso; exit 1 = aviso não-fatal; exit 2 = erro fatal (não usar aqui).

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

# Extrair campos relevantes
SUMMARY=$(python3 -c "
import sys
try:
    import yaml
    with open('$STATE_YAML') as f:
        d = yaml.safe_load(f)
    if not d:
        sys.exit(0)

    marco = d.get('marco_corrente', 'desconhecido')
    gates = d.get('gate_status', {})
    pautas = d.get('pautas_abertas', [])
    lacunas = d.get('lacunas_m1', {})
    artefatos = [a.get('nome','?') for a in d.get('artefatos', [])]
    ultima = d.get('ultima_atualizacao', '?')

    print(f'[RETOMADA DE PROJETO]')
    print(f'Marco corrente: {marco}')
    print(f'Gates: {gates}')
    if artefatos:
        print(f'Artefatos gerados: {artefatos}')
    if pautas:
        print(f'Pautas em aberto: {pautas}')
    if lacunas:
        print(f'Lacunas M1 pendentes: {lacunas}')
    print(f'Última atualização: {ultima}')
    print(f'Estado em: $STATE_YAML')
except Exception as e:
    sys.exit(0)
" 2>/dev/null || true)

if [[ -n "$SUMMARY" ]]; then
  echo "$SUMMARY"
fi

exit 0
