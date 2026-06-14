#!/usr/bin/env bash
# git_track.sh — versionamento automático dos artefatos gerados
#
# Subcomandos:
#   git_track.sh init   <PROJETO_DIR>            — git init + .gitignore + commit inicial
#   git_track.sh commit <PROJETO_DIR> "<mensagem>" — git add -A + commit (somente se houver mudanças)
#
# Exit 0 sempre — nunca quebra o fluxo do orquestrador.
#
# NOTA: mensagens como GIT_SEM_MUDANCAS, GIT_JA_EXISTE, GIT_NAO_DISPONIVEL e
# GIT_DIR_INVALIDO são STATUS informativos (stderr/stdout), NÃO erros — o
# orquestrador as trata silenciosamente (ver content/orchestrator.md §INICIALIZAÇÃO).

set -euo pipefail

# ---------------------------------------------------------------------------
# Verificar se git está disponível
# ---------------------------------------------------------------------------
if ! command -v git &>/dev/null; then
  echo "GIT_NAO_DISPONIVEL: rastreio de mudanças desativado" >&2
  exit 0
fi

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------
SUBCMD="${1:-}"
PROJETO_DIR="${2:-}"

if [[ -z "$SUBCMD" || -z "$PROJETO_DIR" ]]; then
  echo "Uso: git_track.sh <init|commit> <PROJETO_DIR> [mensagem]" >&2
  exit 0
fi

# Resolver caminho absoluto; se inacessível, abortar sem quebrar o fluxo
_PROJETO_DIR_RAW="$PROJETO_DIR"
if ! PROJETO_DIR="$(cd "$PROJETO_DIR" 2>/dev/null && pwd)"; then
  echo "GIT_DIR_INVALIDO: diretório inacessível: $_PROJETO_DIR_RAW" >&2
  exit 0
fi

# ---------------------------------------------------------------------------
# Wrapper git — config local para não depender de config global do usuário
# ---------------------------------------------------------------------------
_git() {
  git -C "$PROJETO_DIR" \
      -c user.email="ferramenta-tcc@local" \
      -c user.name="ferramenta-tcc" \
      -c commit.gpgsign=false \
      -c core.hooksPath=/dev/null \
      "$@"
}

# ---------------------------------------------------------------------------
# SUBCOMANDO: init
# ---------------------------------------------------------------------------
_init() {
  # Idempotente: se já existe repo, não sobrescreve
  if [[ -d "$PROJETO_DIR/.git" ]]; then
    echo "GIT_JA_EXISTE: repo já inicializado em $PROJETO_DIR"
    exit 0
  fi

  # Inicializar repo (branch determinístico p/ evitar hint ruidoso do git no macOS)
  git -c init.defaultBranch=main init "$PROJETO_DIR" --quiet

  # Criar .gitignore (via shell redirect — não usa tool Write, não dispara gate_guard)
  cat > "$PROJETO_DIR/.gitignore" <<'GITIGNORE'
# Rascunhos temporários
*.draft

# macOS
.DS_Store

# Editor
.vscode/
.idea/

# Métrica interna (detector de jargão no chat — instrumento de dev, não-entregável)
_metricas-jargao-chat.log
GITIGNORE

  # Commit inicial (pode estar vazio se o projeto ainda não tem artefatos)
  _git add -A
  if ! _git diff --cached --quiet 2>/dev/null; then
    _git commit --quiet -m "chore: início do projeto" 2>/dev/null || true
  else
    # repo novo vazio — commit vazio de marcação
    _git commit --quiet --allow-empty -m "chore: início do projeto" 2>/dev/null || true
  fi

  echo "GIT_INIT_OK: repo criado em $PROJETO_DIR"
}

# ---------------------------------------------------------------------------
# SUBCOMANDO: commit
# ---------------------------------------------------------------------------
_commit() {
  local MENSAGEM="${3:-Atualização}"

  # Se repo não existe ainda, inicializar primeiro (fallback de segurança)
  if [[ ! -d "$PROJETO_DIR/.git" ]]; then
    _init
  fi

  _git add -A

  # Só commita se houver mudanças staged
  if _git diff --cached --quiet 2>/dev/null; then
    echo "GIT_SEM_MUDANCAS: nenhum artefato alterado desde o último commit"
    exit 0
  fi

  _git commit --quiet -m "$MENSAGEM" 2>/dev/null || {
    echo "GIT_COMMIT_FALHOU: verifique a configuração de git em $PROJETO_DIR" >&2
    exit 0
  }

  echo "GIT_COMMIT_OK: $MENSAGEM"
}

# ---------------------------------------------------------------------------
# Despacho
# ---------------------------------------------------------------------------
case "$SUBCMD" in
  init)   _init ;;
  commit) _commit "$@" ;;
  *)
    echo "Subcomando desconhecido: $SUBCMD (use init ou commit)" >&2
    exit 0
    ;;
esac
