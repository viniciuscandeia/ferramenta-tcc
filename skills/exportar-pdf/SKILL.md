---
name: exportar-pdf
marco: [M1, M2, M3, M4]
description: >-
  Gera os arquivos PDF da documentação do projeto a partir dos documentos em
  formato texto já criados. Use quando o usuário pedir para gerar, salvar ou
  exportar o PDF, ou quando a geração automática no encerramento tiver falhado
  por falta de conversor. — Re-exports project docs to PDF from existing MD
  artifacts; recovery path when auto-export at project close fails.
---

## Filosofia desta skill

Re-executa a exportação PDF de forma idempotente. Pode ser chamada quantas
vezes for necessário. Não altera nenhum documento de texto — só gera/regera
os arquivos PDF em `pdf/`.

---

## Fase 0 — Pré-condições

Antes de qualquer coisa, verificar:

1. **PLUGIN_ROOT** — usar o valor já resolvido na sessão (skill `iniciar-projeto`
   fez a resolução no boot via `installed_plugins.json`). Se não disponível no
   contexto, resolver:
   ```bash
   python3 -c "
   import json, pathlib
   data = json.loads(pathlib.Path.home().joinpath('.claude/plugins/installed_plugins.json').read_text())
   print(data['ferramenta-tcc@ferramenta-tcc'][0]['installPath'])
   "
   ```

2. **PROJETO_DIR** — localizar `estado-projeto.yaml` pelo cwd ou buscando até
   3 níveis acima:
   ```bash
   d="$(pwd)"
   for _ in 1 2 3 4; do
     [ -f "$d/estado-projeto.yaml" ] && echo "$d" && break
     d="$(dirname "$d")"
   done
   ```
   Se não encontrado: informar ao usuário em linguagem simples que não foi
   possível localizar o projeto e perguntar onde estão os documentos.

3. **Documentos existem?** — checar se `$PROJETO_DIR/documentos-para-leigo/`
   ou `$PROJETO_DIR/documentos-tecnicos/` existem e têm arquivos `.md`.
   Se ambas estiverem vazias: informar que ainda não há documentos para
   converter (o processo precisa estar pelo menos no final da etapa 1).

---

## Fase 1 — Executar conversão

Rodar via Bash:
```bash
bash "{PLUGIN_ROOT}/scripts/md_to_pdf.sh" "{PROJETO_DIR}"
```

Capturar exit code e stdout/stderr.

---

## Fase 2 — Relatar resultado ao usuário (linguagem simples, sem jargão D1)

### Exit 0 — sucesso

Mostrar ao usuário:
- Confirmação de que os PDFs foram gerados.
- Caminhos exatos de `pdf/documentacao-cliente.pdf` e `pdf/documentacao-tecnica.pdf`.
- Dica: "Você pode abrir, imprimir ou compartilhar esses arquivos como qualquer
  outro PDF."

### Exit 2 — nenhum conversor disponível

Mostrar ao usuário:
- Que os documentos de texto estão intactos.
- Que para gerar o PDF é preciso instalar uma ferramenta gratuita:
  - Mac:
    ```
    brew install pandoc
    brew install --cask basictex
    sudo /Library/TeX/texbin/tlmgr update --self
    sudo /Library/TeX/texbin/tlmgr install fvextra
    ```
  - Linux: `sudo apt install pandoc texlive-xetex texlive-latex-extra`
  - Alternativa leve (Node.js): `npm install -g md-to-pdf`
- Que após instalar, basta usar `/exportar-pdf` novamente.

> **Nota:** se o usuário já tem pandoc + LaTeX mas o PDF sai com código ultrapassando
> a margem, o `fvextra` não está instalado. Orientar a instalar conforme acima.

### Exit 1 — erro de conversão

Mostrar ao usuário:
- Que os documentos de texto estão intactos (nenhum documento foi perdido).
- Que houve uma dificuldade técnica ao gerar o PDF.
- Sugerir tentar novamente com `/exportar-pdf`; se o problema persistir,
  verificar se o conversor instalado está funcionando corretamente.
