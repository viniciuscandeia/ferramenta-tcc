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

# Diretório deste script (para localizar filtros pandoc auxiliares)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LUA_TABELA="$SCRIPT_DIR/pandoc-tabela-wrap.lua"

# ---------------------------------------------------------------------------
# Configuração: arquivos internos excluídos do técnico (padrões glob, basename)
# ---------------------------------------------------------------------------
EXCLUIR_TECNICO=(
  "*elicitacao-raw*"
  "*pautas-reelicitacao*"
  "*analyze-report*"
  "*03.3-diagramas*"
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
PREAMBLE_TEX="$(mktemp /tmp/ferramenta_tcc_preamble_XXXXXX)"
# shellcheck disable=SC2064
trap "rm -f '$PREAMBLE_TEX'" EXIT

# fvextra (opcional) — corrige blocos de código (```...```) que estouram a margem.
# Ausente: segue sem esse fix; os demais (overflow, imagens, tabelas) continuam valendo.
if command -v kpsewhich &>/dev/null && kpsewhich fvextra.sty &>/dev/null; then
  cat > "$PREAMBLE_TEX" <<'LATEXFVEXTRA'
% Fix 1 — blocos de código fenced: quebra em qualquer caractere (requer fvextra)
\usepackage{fvextra}
\fvset{breaklines=true,breakanywhere=true}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{%
  breaklines=true,breakanywhere=true,commandchars=\\\{\}}
LATEXFVEXTRA
else
  : > "$PREAMBLE_TEX"
  echo "[md_to_pdf] AVISO: fvextra não encontrado — código pode estourar margem no PDF." >&2
  echo "[md_to_pdf]   Instalar: sudo tlmgr install fvextra" >&2
  echo "[md_to_pdf]   Gerando PDF sem fix de quebra de linha em blocos de código." >&2
fi

# Fixes sempre aplicados (independem de fvextra): overflow residual, imagens e tabelas.
cat >> "$PREAMBLE_TEX" <<'LATEXBASE'

% Fix 3 — rede de segurança para overflows residuais (caminhos longos etc.)
\sloppy
\setlength{\emergencystretch}{10em}

% Fix 4 — imagens (incluindo diagramas Mermaid) escaladas para caber na página
\usepackage{graphicx}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
\makeatother

% Fix 5 — tabelas: fonte menor e colunas que quebram. As larguras p{} das tabelas
%   largas são definidas pelo filtro Lua pandoc-tabela-wrap.lua.
\usepackage{array}
\usepackage{ragged2e}
\usepackage{etoolbox}
\AtBeginEnvironment{longtable}{\small}
\AtBeginEnvironment{tabular}{\small}
LATEXBASE

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

# Escape de caracteres especiais do título para a capa (--include-before-body,
# conteúdo bruto, sem escape automático do pandoc).
#   _escape_latex: & % $ # _ { } e em-dash (— → ---, evita erro Unicode no pdflatex)
#   _escape_html : & < >
_escape_latex() {
  printf '%s' "$1" | sed \
    -e 's/&/\\&/g' -e 's/%/\\%/g' -e 's/\$/\\$/g' -e 's/#/\\#/g' \
    -e 's/_/\\_/g' -e 's/{/\\{/g' -e 's/}/\\}/g' \
    -e 's/—/---/g'
}
_escape_html() {
  printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Substituir blocos ```mermaid por imagens PNG renderizadas via mmdc.
# Blocos que falharem na conversão ficam como código (fallback gracioso).
# _processar_mermaid <tmp_md> <img_dir>
_processar_mermaid() {
  local tmp_md="$1" img_dir="$2" fmt="${3:-png}"
  python3 - "$tmp_md" "$img_dir" "$fmt" <<'PYEOF'
import re, subprocess, os, sys

input_file, img_dir, fmt = sys.argv[1], sys.argv[2], sys.argv[3]
content = open(input_file, encoding='utf-8').read()
count = [0]

# Nitidez do diagrama: PDF vetorial para engines LaTeX (escala infinita);
# PNG de alta densidade (escala 3x) para engines HTML (wkhtmltopdf/weasyprint/etc).
if fmt == 'pdf':
    ext, extra = 'pdf', ['--pdfFit']
else:
    ext, extra = 'png', ['-w', '1400', '-s', '3']

def replace_mermaid(m):
    count[0] += 1
    n = count[0]
    mmd_file = os.path.join(img_dir, f'diagram_{n}.mmd')
    out_file = os.path.join(img_dir, f'diagram_{n}.{ext}')
    open(mmd_file, 'w', encoding='utf-8').write(m.group(1).strip())
    try:
        result = subprocess.run(
            ['mmdc', '-i', mmd_file, '-o', out_file,
             '-b', 'white', '--quiet'] + extra,
            capture_output=True, timeout=120
        )
        if result.returncode == 0 and os.path.exists(out_file):
            return f'![Diagrama {n}]({out_file})\n'
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
  local -a _lua_args=()
  [[ -f "${LUA_TABELA:-}" ]] && _lua_args=(--lua-filter "$LUA_TABELA")

  # Capa: bloco renderizado via --include-before-body, que o pandoc emite ANTES
  # do \tableofcontents (LaTeX) e antes da <nav> do sumário (HTML), e que nunca
  # vira entrada do sumário (conteúdo bruto, não-markdown). Substitui o antigo
  # --metadata title (\maketitle), cujo posicionamento dependia do template.
  local _capa=""
  local -a _capa_args=()
  case "$ENGINE" in
    pandoc-xelatex|pandoc-pdflatex)
      _capa="$(mktemp /tmp/ferramenta_tcc_capa_XXXXXX.tex)"
      printf '%s\n' \
        '\begin{center}' \
        "{\\LARGE\\bfseries $(_escape_latex "$titulo")}\\\\[0.4em]" \
        '\rule{0.55\linewidth}{0.4pt}' \
        '\end{center}' \
        '\vspace{1.5em}' > "$_capa"
      # title-meta preenche o pdftitle (hyperref) sem disparar \maketitle.
      _capa_args=(--include-before-body "$_capa" -V title-meta="$titulo")
      ;;
    pandoc-wkhtmltopdf|pandoc-default)
      _capa="$(mktemp /tmp/ferramenta_tcc_capa_XXXXXX.html)"
      printf '%s\n' \
        '<div style="text-align:center;margin-bottom:2em;">' \
        "<div style=\"font-size:2em;font-weight:bold;margin-bottom:0.2em;\">$(_escape_html "$titulo")</div>" \
        '<hr style="width:55%;border:none;border-top:1px solid #000;">' \
        '</div>' > "$_capa"
      _capa_args=(--include-before-body "$_capa" --metadata pagetitle="$titulo")
      ;;
  esac
  # shellcheck disable=SC2064
  [[ -n "$_capa" ]] && trap "rm -f '$_capa'" RETURN

  case "$ENGINE" in
    pandoc-xelatex)
      pandoc "$src" -o "$dst" \
        --pdf-engine=xelatex \
        --toc \
        -V geometry:margin=2.5cm \
        -V lang=pt-BR \
        --standalone \
        "${_capa_args[@]+"${_capa_args[@]}"}" \
        "${_preamble_args[@]+"${_preamble_args[@]}"}" \
        "${_lua_args[@]+"${_lua_args[@]}"}" \
        2> >(grep -vE "Missing character|Float too large for page|^\s+input line [0-9]+\." >&2)
      ;;
    pandoc-pdflatex)
      pandoc "$src" -o "$dst" \
        --pdf-engine=pdflatex \
        --toc \
        -V geometry:margin=2.5cm \
        -V lang=pt-BR \
        --standalone \
        "${_capa_args[@]+"${_capa_args[@]}"}" \
        "${_preamble_args[@]+"${_preamble_args[@]}"}" \
        "${_lua_args[@]+"${_lua_args[@]}"}" \
        2> >(grep -vE "Missing character|Float too large for page|^\s+input line [0-9]+\." >&2)
      ;;
    pandoc-wkhtmltopdf)
      pandoc "$src" -o "$dst" \
        --pdf-engine=wkhtmltopdf \
        --toc \
        --standalone \
        "${_capa_args[@]+"${_capa_args[@]}"}" \
        "${_lua_args[@]+"${_lua_args[@]}"}"
      ;;
    pandoc-default)
      pandoc "$src" -o "$dst" \
        --toc \
        --standalone \
        "${_capa_args[@]+"${_capa_args[@]}"}" \
        "${_lua_args[@]+"${_lua_args[@]}"}"
      ;;
    md-to-pdf)
      md-to-pdf "$src" --dest "$dst" 2>/dev/null
      ;;
    weasyprint)
      if command -v pandoc &>/dev/null; then
        local tmp_html="${src%.md}.html"
        pandoc "$src" -o "$tmp_html" --standalone "${_lua_args[@]+"${_lua_args[@]}"}"
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

  # Cabeçalho / capa:
  #  - engines pandoc: a capa vai por --include-before-body (em _convert),
  #    emitida ANTES do sumário e FORA dele (conteúdo bruto, nunca vira entrada
  #    do sumário). Body sem H1 de título — o H1 dos arquivos-fonte permanece
  #    como primeira entrada do sumário.
  #  - engines não-pandoc (sem sumário automático): injeta H1 visível.
  case "$ENGINE" in
    pandoc*)
      : > "$tmp_md"
      ;;
    *)
      {
        echo "# $titulo"
        echo ""
        echo "---"
        echo ""
      } > "$tmp_md"
      ;;
  esac

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

  # Renderizar diagramas Mermaid (se mmdc disponível): PDF vetorial nas engines
  # LaTeX (nitidez perfeita), PNG de alta densidade nas demais.
  if [[ -n "$MMDC" ]]; then
    local _diag_fmt="png"
    case "$ENGINE" in
      pandoc-xelatex|pandoc-pdflatex) _diag_fmt="pdf" ;;
    esac
    _processar_mermaid "$tmp_md" "$tmp_img_dir" "$_diag_fmt"
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