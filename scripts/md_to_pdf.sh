#!/usr/bin/env bash
# md_to_pdf.sh — converte documentação MD → PDF consolidado por público
# Uso: md_to_pdf.sh <PROJETO_DIR>   (default: cwd)
# Saída: <PROJETO_DIR>/pdf/documentacao-cliente.pdf
#         <PROJETO_DIR>/pdf/documentacao-tecnica.pdf
# Exit 0 = sucesso; exit 1 = erro; exit 2 = nenhum conversor disponível
#
# Pré-requisito opcional (mas fortemente recomendado) para quebra de linha em
# blocos e código inline no PDF LaTeX:
#   macOS  : sudo tlmgr install fvextra
#   Ubuntu : sudo tlmgr install fvextra   (ou: sudo apt install texlive-latex-extra)

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuração: arquivos internos excluídos do técnico (padrões glob, basename)
# ---------------------------------------------------------------------------
EXCLUIR_TECNICO=(
  "*elicitacao-raw*"
  "*pautas-reelicitacao*"
  "*analyze-report*"
)

# Pastas/arquivos de M1 e M2 excluídos do PDF técnico:
# O PDF técnico começa pelo SRS (03-documento/) — M1 (visão) e M2 (requisitos
# intermediários) são artefatos de processo, não o documento entregue final.
EXCLUIR_PASTAS_TECNICO=(
  "01-visao"
  "02-requisitos"
)

# Pastas excluídas do PDF do CLIENTE:
# O cliente recebe apenas o resumo do produto (01-visao/). Os requisitos
# detalhados (02-requisitos/) e o documento completo (03-documento/) ficam fora.
EXCLUIR_PASTAS_CLIENTE=(
  "02-requisitos"
  "03-documento"
)

# ---------------------------------------------------------------------------
# Argumentos
# ---------------------------------------------------------------------------
PROJETO_DIR="${1:-$(pwd)}"
PROJETO_DIR="$(cd "$PROJETO_DIR" && pwd)"  # absoluto, sem trailing slash

PDF_DIR="$PROJETO_DIR/pdf"

# ---------------------------------------------------------------------------
# Detectar nome do projeto (estado-projeto.yaml, campo nome_projeto)
# ---------------------------------------------------------------------------
NOME_PROJETO="Projeto"
ESTADO_YAML="$PROJETO_DIR/estado-projeto.yaml"
if [[ -f "$ESTADO_YAML" ]]; then
  _nome=$(grep -E '^nome_projeto:' "$ESTADO_YAML" | head -1 | sed 's/nome_projeto:[[:space:]]*//' | tr -d '"'"'" 2>/dev/null || true)
  [[ -n "$_nome" ]] && NOME_PROJETO="$_nome"
fi

# ---------------------------------------------------------------------------
# Garantir que TeX (BasicTeX/MacTeX/TeX Live) esteja no PATH no macOS
# ---------------------------------------------------------------------------
for _texbin in /Library/TeX/texbin /usr/local/texlive/*/bin/universal-apple-darwin \
               /usr/local/texlive/*/bin/x86_64-darwin /usr/local/texlive/*/bin/aarch64-darwin; do
  # shellcheck disable=SC2086
  for _d in $_texbin; do
    [[ -d "$_d" ]] && PATH="$_d:$PATH"
  done
done
export PATH

# ---------------------------------------------------------------------------
# Detectar fvextra e criar preâmbulo LaTeX para quebra de linha correta
# ---------------------------------------------------------------------------
# fvextra corrige:
#   - blocos de código (```...```) que estouram a margem (Verbatim/Highlighting)
#   - código inline (`...`) via scanner de tokens que insere pontos de quebra
#     após / . - (seguro com escapes do pandoc como \_ \# etc.)
#   - emergencystretch generosa como rede de segurança
#
# Se fvextra não estiver instalado: avisa, gera PDF sem o fix (comportamento
# original — não aborta a geração do gate).
#   Instalar: sudo tlmgr install fvextra
# ---------------------------------------------------------------------------
PREAMBLE_TEX=""

if command -v kpsewhich &>/dev/null && kpsewhich fvextra.sty &>/dev/null; then
  PREAMBLE_TEX="$(mktemp /tmp/ferramenta_tcc_preamble_XXXXXX)"
  cat > "$PREAMBLE_TEX" <<'LATEXPREAMBLE'
% === ferramenta-tcc: fix quebra de linha em PDF LaTeX ===
% Requer: fvextra  (sudo tlmgr install fvextra)

% Fix 1 — blocos de código fenced (```...```):
%   Redefine Highlighting env gerada pelo pandoc para permitir quebra em qualquer char.
\usepackage{fvextra}
\fvset{breaklines=true,breakanywhere=true}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{%
  breaklines=true,breakanywhere=true,commandchars=\\\{\}}

% Fix 2 — quebra de código inline (\texttt{...}) longo:
%   REMOVIDO. A versão anterior redefinia \texttt com um scanner token-a-token
%   que inseria \discretionary após / . -. Esse scanner vazava para "moving
%   arguments" (títulos de seção → arquivo .toc e bookmarks do hyperref),
%   gerando \discretionary literal no .toc e o erro FATAL
%   "Improper discretionary list" / "Missing { inserted" — que impedia a
%   geração do PDF técnico (o .toc inclui §3/§4 com caminhos em código inline).
%   Tentativas de blindar (\DeclareRobustCommand) causavam loop infinito na
%   geração de bookmarks. Como o ganho era apenas cosmético (caminhos longos
%   quebrando na margem) e o custo era o PDF inteiro falhar, o fix foi removido.
%   Mitigação de overflow residual: \emergencystretch abaixo (Fix 3) + \sloppy.
\sloppy

% Fix 3 — rede de segurança para overflows residuais (inclui caminhos longos
%   em código inline, antes tratados pelo Fix 2)
\setlength{\emergencystretch}{10em}

% Fix 4 — imagens (incluindo diagramas Mermaid) escaladas para caber na página
%   Idêntico ao padrão do template pandoc default.latex.
%   Imagens menores que a coluna ficam no tamanho natural; maiores são reduzidas.
\usepackage{graphicx}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
\makeatother
LATEXPREAMBLE
  # Limpar ao sair do script
  # shellcheck disable=SC2064
  trap "rm -f '$PREAMBLE_TEX'" EXIT
else
  echo "[md_to_pdf] AVISO: fvextra não encontrado — código pode estourar margem no PDF." >&2
  echo "[md_to_pdf]   Instalar: sudo tlmgr install fvextra" >&2
  echo "[md_to_pdf]   Gerando PDF sem fix de quebra de linha." >&2
fi

# ---------------------------------------------------------------------------
# Detectar mmdc (Mermaid CLI) — opcional, para renderizar diagramas como imagem
# ---------------------------------------------------------------------------
MMDC=""
command -v mmdc &>/dev/null && MMDC="$(command -v mmdc)"

# ---------------------------------------------------------------------------
# Detectar engine de conversão (ordem de preferência)
# ---------------------------------------------------------------------------
ENGINE=""

_pandoc_engine() {
  # Prefere xelatex (Unicode completo) > pdflatex > wkhtmltopdf > padrão
  if pandoc --version &>/dev/null; then
    if command -v xelatex &>/dev/null; then
      echo "pandoc-xelatex"; return
    elif command -v pdflatex &>/dev/null; then
      echo "pandoc-pdflatex"; return
    elif command -v wkhtmltopdf &>/dev/null; then
      echo "pandoc-wkhtmltopdf"; return
    else
      echo "pandoc-default"; return
    fi
  fi
}

if [[ -z "$ENGINE" ]]; then
  _e=$(_pandoc_engine)
  [[ -n "$_e" ]] && ENGINE="$_e"
fi
if [[ -z "$ENGINE" ]] && command -v md-to-pdf &>/dev/null; then
  ENGINE="md-to-pdf"
fi
if [[ -z "$ENGINE" ]] && command -v weasyprint &>/dev/null; then
  ENGINE="weasyprint"
fi
if [[ -z "$ENGINE" ]] && command -v markdown-pdf &>/dev/null; then
  ENGINE="markdown-pdf"
fi

if [[ -z "$ENGINE" ]]; then
  cat >&2 <<'EOF'
[md_to_pdf] Nenhum conversor PDF encontrado.
Para instalar:
  macOS  : brew install pandoc && brew install --cask basictex
           sudo tlmgr install fvextra       # fix quebra de linha (recomendado)
  Ubuntu : sudo apt install pandoc texlive-xetex
           sudo tlmgr install fvextra       # ou: sudo apt install texlive-latex-extra
  Node   : npm install -g md-to-pdf
  Python : pip install weasyprint
EOF
  exit 2
fi

# ---------------------------------------------------------------------------
# Funções auxiliares
# ---------------------------------------------------------------------------

# Testa se basename de $1 corresponde a algum padrão em EXCLUIR_TECNICO
_excluido() {
  local arquivo="$1"
  local base
  base="$(basename "$arquivo")"
  for padrao in "${EXCLUIR_TECNICO[@]}"; do
    # shellcheck disable=SC2254
    case "$base" in
      $padrao) return 0 ;;
    esac
  done
  return 1
}

# Separador de página conforme engine
_page_break() {
  case "$ENGINE" in
    pandoc*) echo -e '\n\\newpage\n' ;;
    *)       echo -e '\n<div style="page-break-after:always"></div>\n' ;;
  esac
}

# Substituir blocos ```mermaid por imagens PNG renderizadas via mmdc.
# Blocos que falharem na conversão ficam como código (fallback gracioso).
# _processar_mermaid <tmp_md> <img_dir>
_processar_mermaid() {
  local tmp_md="$1" img_dir="$2"
  python3 - "$tmp_md" "$img_dir" <<'PYEOF'
import re, subprocess, os, sys

input_file, img_dir = sys.argv[1], sys.argv[2]
content = open(input_file, encoding='utf-8').read()
count = [0]

def replace_mermaid(m):
    count[0] += 1
    n = count[0]
    mmd_file = os.path.join(img_dir, f'diagram_{n}.mmd')
    png_file  = os.path.join(img_dir, f'diagram_{n}.png')
    open(mmd_file, 'w', encoding='utf-8').write(m.group(1).strip())
    try:
        result = subprocess.run(
            ['mmdc', '-i', mmd_file, '-o', png_file,
             '-b', 'white', '--quiet', '-w', '600'],
            capture_output=True, timeout=60
        )
        if result.returncode == 0 and os.path.exists(png_file):
            return f'![Diagrama {n}]({png_file})\n'
    except Exception:
        pass
    return m.group(0)  # fallback: mantém bloco mermaid original

processed = re.sub(r'```mermaid\n(.*?)```', replace_mermaid, content, flags=re.DOTALL)
open(input_file, 'w', encoding='utf-8').write(processed)
PYEOF
}

# Converter arquivo MD temporário para PDF
# _convert <tmp_md> <out_pdf> <titulo>
_convert() {
  local src="$1" dst="$2" titulo="$3"
  # Montar array de args do preâmbulo LaTeX (vazio se fvextra não instalado)
  local -a _preamble_args=()
  [[ -n "${PREAMBLE_TEX:-}" && -f "${PREAMBLE_TEX:-}" ]] \
    && _preamble_args=(--include-in-header "$PREAMBLE_TEX")
  case "$ENGINE" in
    pandoc-xelatex)
      pandoc "$src" -o "$dst" \
        --pdf-engine=xelatex \
        --toc \
        --metadata title="$titulo" \
        -V geometry:margin=2.5cm \
        -V lang=pt-BR \
        --standalone \
        "${_preamble_args[@]+"${_preamble_args[@]}"}" \
        2> >(grep -vE "Missing character|Float too large for page|^\s+input line [0-9]+\." >&2)
      ;;
    pandoc-pdflatex)
      pandoc "$src" -o "$dst" \
        --pdf-engine=pdflatex \
        --toc \
        --metadata title="$titulo" \
        -V geometry:margin=2.5cm \
        -V lang=pt-BR \
        --standalone \
        "${_preamble_args[@]+"${_preamble_args[@]}"}" \
        2> >(grep -vE "Missing character|Float too large for page|^\s+input line [0-9]+\." >&2)
      ;;
    pandoc-wkhtmltopdf)
      pandoc "$src" -o "$dst" \
        --pdf-engine=wkhtmltopdf \
        --toc \
        --metadata title="$titulo" \
        --standalone
      ;;
    pandoc-default)
      pandoc "$src" -o "$dst" \
        --toc \
        --metadata title="$titulo" \
        --standalone
      ;;
    md-to-pdf)
      md-to-pdf "$src" --dest "$dst" 2>/dev/null
      ;;
    weasyprint)
      if command -v pandoc &>/dev/null; then
        local tmp_html="${src%.md}.html"
        pandoc "$src" -o "$tmp_html" --standalone --metadata title="$titulo"
        weasyprint "$tmp_html" "$dst"
        rm -f "$tmp_html"
      else
        weasyprint "$src" "$dst"
      fi
      ;;
    markdown-pdf)
      markdown-pdf "$src" -o "$dst"
      ;;
  esac
}

# Construir PDF a partir de uma pasta de documentos
# _gerar_pdf <pasta_docs> <out_pdf> <titulo_capa> <perfil: cliente|tecnico>
#   cliente — só o resumo do produto (exclui 02-requisitos/ e 03-documento/)
#   tecnico — entregáveis (exclui internos + 01-visao/ + 02-requisitos/)
_gerar_pdf() {
  local pasta="$1" out_pdf="$2" titulo="$3" perfil="$4"
  local tmp_md tmp_img_dir
  tmp_md="$(mktemp /tmp/ferramenta_tcc_XXXXXX)"
  tmp_img_dir="$(mktemp -d /tmp/ferramenta_tcc_imgs_XXXXXX)"
  # shellcheck disable=SC2064
  trap "rm -f '$tmp_md'; rm -rf '$tmp_img_dir'" RETURN

  # Cabeçalho / capa
  {
    echo "# $titulo"
    echo ""
    echo "**$NOME_PROJETO**"
    echo ""
    echo "---"
    echo ""
  } > "$tmp_md"

  # Selecionar pastas a excluir conforme o perfil
  local -a _pastas_excluidas=()
  if [[ "$perfil" == "tecnico" ]]; then
    _pastas_excluidas=("${EXCLUIR_PASTAS_TECNICO[@]}")
  elif [[ "$perfil" == "cliente" ]]; then
    _pastas_excluidas=("${EXCLUIR_PASTAS_CLIENTE[@]}")
  fi

  # Coletar arquivos em ordem canônica (prefixos numéricos garantem sort correto)
  local -a arquivos=()
  while IFS= read -r -d '' f; do
    # Excluir arquivos _internos (prefixo _)
    [[ "$(basename "$f")" == _* ]] && continue
    # Excluir padrões internos (somente perfil técnico)
    if [[ "$perfil" == "tecnico" ]] && _excluido "$f"; then
      continue
    fi
    # Excluir pastas conforme o perfil (técnico: 01/02; cliente: 02/03)
    local _excluir_pasta=false
    for _pasta_excl in "${_pastas_excluidas[@]+"${_pastas_excluidas[@]}"}"; do
      if [[ "$f" == *"/$_pasta_excl/"* ]]; then
        _excluir_pasta=true
        break
      fi
    done
    [[ "$_excluir_pasta" == "true" ]] && continue
    arquivos+=("$f")
  done < <(find "$pasta" -maxdepth 4 -name '*.md' -print0 | sort -z)

  if [[ ${#arquivos[@]} -eq 0 ]]; then
    rm -f "$tmp_md"
    return 0  # pasta vazia — no-op gracioso
  fi

  local primeiro=true
  for arquivo in "${arquivos[@]}"; do
    if [[ "$primeiro" == "true" ]]; then
      primeiro=false
    else
      _page_break >> "$tmp_md"
    fi
    cat "$arquivo" >> "$tmp_md"
    echo "" >> "$tmp_md"
  done

  # Renderizar diagramas Mermaid como imagens PNG (se mmdc disponível)
  if [[ -n "$MMDC" ]]; then
    _processar_mermaid "$tmp_md" "$tmp_img_dir"
  fi

  _convert "$tmp_md" "$out_pdf" "$titulo"
}

# ---------------------------------------------------------------------------
# Principal
# ---------------------------------------------------------------------------

mkdir -p "$PDF_DIR"

gerados=()
erros=()

# --- Versão cliente ---
PASTA_LEIGO="$PROJETO_DIR/documentos-para-leigo"
OUT_CLIENTE="$PDF_DIR/documentacao-cliente.pdf"
if [[ -d "$PASTA_LEIGO" ]]; then
  if _gerar_pdf "$PASTA_LEIGO" "$OUT_CLIENTE" "Visão do Produto — $NOME_PROJETO" "cliente"; then
    [[ -f "$OUT_CLIENTE" ]] && gerados+=("$OUT_CLIENTE")
  else
    erros+=("documentacao-cliente.pdf")
  fi
fi

# --- Versão técnica ---
PASTA_TEC="$PROJETO_DIR/documentos-tecnicos"
OUT_TEC="$PDF_DIR/documentacao-tecnica.pdf"
if [[ -d "$PASTA_TEC" ]]; then
  if _gerar_pdf "$PASTA_TEC" "$OUT_TEC" "Documentação Técnica — $NOME_PROJETO" "tecnico"; then
    [[ -f "$OUT_TEC" ]] && gerados+=("$OUT_TEC")
  else
    erros+=("documentacao-tecnica.pdf")
  fi
fi

# ---------------------------------------------------------------------------
# Relatório stdout (o orquestrador lê e repassa ao usuário em linguagem leigo)
# ---------------------------------------------------------------------------
if [[ ${#gerados[@]} -gt 0 ]]; then
  echo "PDF_GERADOS:"
  for pdf in "${gerados[@]}"; do
    echo "  $pdf"
  done
fi

if [[ ${#erros[@]} -gt 0 ]]; then
  echo "PDF_ERROS: ${erros[*]}" >&2
  exit 1
fi

exit 0