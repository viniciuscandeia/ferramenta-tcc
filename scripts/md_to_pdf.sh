#!/usr/bin/env bash
# md_to_pdf.sh — converte documentação MD → PDF consolidado por público
# Uso: md_to_pdf.sh <PROJETO_DIR>   (default: cwd)
# Saída: <PROJETO_DIR>/pdf/documentacao-cliente.pdf
#         <PROJETO_DIR>/pdf/documentacao-tecnica.pdf
# Exit 0 = sucesso; exit 1 = erro; exit 2 = nenhum conversor disponível

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuração: arquivos internos excluídos do técnico (padrões glob, basename)
# ---------------------------------------------------------------------------
EXCLUIR_TECNICO=(
  "*elicitacao-raw*"
  "*pautas-reelicitacao*"
  "*analyze-report*"
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
  Ubuntu : sudo apt install pandoc texlive-xetex
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
             '-b', 'white', '--quiet', '--scale', '2'],
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
  case "$ENGINE" in
    pandoc-xelatex)
      pandoc "$src" -o "$dst" \
        --pdf-engine=xelatex \
        --toc \
        --metadata title="$titulo" \
        -V geometry:margin=2.5cm \
        -V lang=pt-BR \
        --standalone \
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
# _gerar_pdf <pasta_docs> <out_pdf> <titulo_capa> <excluir_internos: true|false>
_gerar_pdf() {
  local pasta="$1" out_pdf="$2" titulo="$3" excluir_internos="$4"
  local tmp_md tmp_img_dir
  tmp_md="$(mktemp /tmp/ferramenta_tcc_XXXXXX.md)"
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

  # Coletar arquivos em ordem canônica (prefixos numéricos garantem sort correto)
  local -a arquivos=()
  while IFS= read -r -d '' f; do
    # Excluir arquivos _internos (prefixo _)
    [[ "$(basename "$f")" == _* ]] && continue
    # Excluir padrões internos do técnico, se solicitado
    if [[ "$excluir_internos" == "true" ]] && _excluido "$f"; then
      continue
    fi
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
  if _gerar_pdf "$PASTA_LEIGO" "$OUT_CLIENTE" "Documentação do Projeto — versão para o cliente" "false"; then
    [[ -f "$OUT_CLIENTE" ]] && gerados+=("$OUT_CLIENTE")
  else
    erros+=("documentacao-cliente.pdf")
  fi
fi

# --- Versão técnica ---
PASTA_TEC="$PROJETO_DIR/documentos-tecnicos"
OUT_TEC="$PDF_DIR/documentacao-tecnica.pdf"
if [[ -d "$PASTA_TEC" ]]; then
  if _gerar_pdf "$PASTA_TEC" "$OUT_TEC" "Documentação Técnica — $NOME_PROJETO" "true"; then
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