# ferramenta-tcc

Ferramenta de elicitação e documentação de requisitos para stakeholder leigo.
Conduz o usuário por perguntas estruturadas e gera SRS no padrão IREB §3.3.3
com diagramas, matriz de rastreabilidade e versão em linguagem de negócio.
Ao concluir, exporta a documentação completa em PDF automaticamente.

**Projeto:** TCC — Vinicius Candeia (deadline 2026-07-01)
**Plataforma:** Claude Code (CLI)

---

## Instalação

```bash
# Adicionar o repo como fonte de plugins (uma vez):
claude plugin marketplace add viniciuscandeia/ferramenta-tcc

# Instalar o plugin:
claude plugin install ferramenta-tcc@ferramenta-tcc
```

Confirmar instalação:
```bash
claude plugin list      # deve mostrar "ferramenta-tcc"
```

---

## Dependências para exportação PDF

A ferramenta gera PDFs automaticamente ao concluir. Requer ao menos uma das ferramentas abaixo:

### Opção 1 — pandoc + LaTeX (recomendado — melhor qualidade tipográfica)

<details open>
<summary><strong>macOS</strong></summary>

```bash
brew install pandoc
brew install --cask basictex
sudo /Library/TeX/texbin/tlmgr update --self
sudo /Library/TeX/texbin/tlmgr install fvextra
```

> `fvextra` corrige quebra de linha de código inline e blocos no PDF.
> Sem ele, caminhos longos (ex.: `documentos-tecnicos/02-requisitos/...`) podem
> ultrapassar a margem direita. A exportação funciona sem ele, mas com o bug visual.

</details>

<details>
<summary><strong>Ubuntu / Debian</strong></summary>

```bash
sudo apt update
sudo apt install pandoc texlive-xetex texlive-latex-extra
```

> `texlive-latex-extra` inclui `fvextra` (fix de quebra de linha no PDF).

</details>

<details>
<summary><strong>Fedora / RHEL / CentOS</strong></summary>

```bash
sudo dnf install pandoc texlive-xetex texlive-fvextra
```

Se `texlive-fvextra` não estiver disponível no repositório, instale via tlmgr após instalar o TeX Live:
```bash
sudo dnf install pandoc texlive-xetex
sudo tlmgr install fvextra
```

</details>

<details>
<summary><strong>Arch Linux / Manjaro</strong></summary>

```bash
sudo pacman -S pandoc texlive-core texlive-latexextra
```

> `texlive-latexextra` inclui `fvextra`.

</details>

<details>
<summary><strong>Windows (WSL — recomendado)</strong></summary>

A ferramenta roda via Claude Code no terminal. No Windows, use WSL (Windows Subsystem for Linux)
com Ubuntu e siga as instruções de Ubuntu acima.

Instalar WSL (PowerShell como administrador):
```powershell
wsl --install
```

Após reiniciar, abra o terminal Ubuntu e execute:
```bash
sudo apt update
sudo apt install pandoc texlive-xetex texlive-latex-extra
```

</details>

<details>
<summary><strong>Windows (nativo, sem WSL)</strong></summary>

```powershell
# Instalar Scoop (gerenciador de pacotes, PowerShell):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Instalar pandoc e MiKTeX:
scoop install pandoc
scoop bucket add extras
scoop install miktex
```

Após instalar o MiKTeX, abrir o **MiKTeX Console** → aba "Packages" → buscar `fvextra` → instalar.

Alternativa: instalar pelo instalador oficial em [miktex.org](https://miktex.org/download) e
depois no MiKTeX Console instalar `fvextra`.

> No Windows nativo, o Claude Code roda via Node.js. Confirme que o `pandoc` e o `xelatex`
> estão no PATH antes de usar `/exportar-pdf`.

</details>

### Opção 2 — md-to-pdf (mais leve, requer Node.js ≥ 18)

Funciona em macOS, Linux e Windows nativamente.

```bash
npm install -g md-to-pdf
```

> Não requer LaTeX. Qualidade tipográfica inferior à Opção 1, mas sem dependências pesadas.
> Não produz tabela de conteúdo automática.

### Opção 3 — weasyprint (requer Python ≥ 3.9)

```bash
pip install weasyprint
```

> Converte via HTML+CSS → PDF. Requer pandoc instalado para melhor resultado.

> O script detecta automaticamente qual ferramenta está disponível na ordem acima.
> Se nenhuma estiver instalada, os documentos Markdown são gerados normalmente
> e o PDF pode ser exportado depois via `/exportar-pdf`.

### Dependência opcional — diagramas Mermaid no PDF

Para renderizar fluxogramas e diagramas como imagens visuais no PDF
(em vez de código-texto), instale o Mermaid CLI:

```bash
npm install -g @mermaid-js/mermaid-cli
```

Requer Node.js ≥ 18. O Mermaid CLI baixa Chromium headless (~200 MB) na primeira execução.
Se não instalado, blocos `\`\`\`mermaid` aparecem como código no PDF (fallback gracioso).

### Dependência opcional — rastreio de mudanças (git)

A ferramenta inicializa um repositório git na pasta do projeto ao começar e faz commit
automático a cada etapa concluída. Requer git instalado (já presente na maioria dos sistemas):

```bash
# Verificar se disponível:
git --version

# macOS (se ausente):
brew install git

# Ubuntu/Debian:
sudo apt install git

# Fedora/RHEL:
sudo dnf install git

# Arch:
sudo pacman -S git

# Windows: já incluído no Git for Windows (https://git-scm.com) ou via WSL
```

Se git não estiver disponível, o rastreio é desativado silenciosamente — o fluxo não é interrompido.

**Como consultar o histórico de mudanças dos requisitos:**
```bash
# Ver todas as etapas documentadas:
git -C <pasta-do-projeto> log --oneline

# Ver o que mudou entre duas etapas:
git -C <pasta-do-projeto> diff HEAD~1

# Ver mudanças específicas de um arquivo de requisitos:
git -C <pasta-do-projeto> log --follow documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md
```

---

## Uso

Em qualquer diretório de projeto vazio:

```
/iniciar-projeto
```

O orquestrador conduz o processo de 4 marcos (Definição → Consenso → Detalhamento → Revisão Técnica opcional).
Responda as perguntas como faria com um analista de requisitos humano.

Para re-exportar o PDF a qualquer momento (útil se o conversor foi instalado após o encerramento):

```
/exportar-pdf
```

**Artefatos gerados ao final:**
- `documentos-para-leigo/` e `documentos-tecnicos/` — documentação em Markdown por marco
- `pdf/documentacao-cliente.pdf` — versão para o cliente (todos os docs leigo consolidados)
- `pdf/documentacao-tecnica.pdf` — versão técnica (SRS, diagramas, rastreabilidade)

---

## Estrutura

```
ferramenta-tcc/
├── .claude-plugin/
│   └── plugin.json        # Manifesto (metadados apenas — sem hooks inline)
├── settings.json          # Apenas: {"agent": "orchestrator"}
├── hooks/
│   └── hooks.json         # Todos os 5 hooks em 4 eventos (SessionStart, PreToolUse ×2, PostToolUse, UserPromptSubmit)
├── agents/                # Definições de agente (orchestrator + 5 sub-agentes)
│   └── orchestrator.md    # Agente principal (system prompt quando plugin habilitado)
├── skills/                # 25 skills de elicitação, documentação e exportação
│   └── exportar-pdf/      # Re-exportação PDF sob demanda (/exportar-pdf)
├── scripts/               # Scripts invocados pelos hooks e pelo orquestrador
│   ├── md_to_pdf.sh       # Conversor MD → PDF (pandoc/md-to-pdf/weasyprint + mmdc para Mermaid)
│   └── lib/blacklist.txt  # Blacklist D1 (jargão proibido)
├── content/               # Conteúdo do plugin (não auto-descoberto pelo CC)
│   ├── orchestrator.md    # Dispatcher central
│   ├── constitution.md    # Guardrails imutáveis (D15)
│   ├── marcos/            # Slices por marco (m1–m4)
│   ├── workflows/         # Workflows detalhados por marco
│   ├── catalogos-seed/    # Conhecimento destilado de domínios e requisitos típicos
│   └── templates/         # Templates de artefatos
├── references/            # Material de referência externo
│   └── normas/            # Normas IREB, ISO/IEC/IEEE 29148
├── tests/                 # Casos canônicos E2E + checklists por marco
└── CATALOGO.md            # Índice completo de agentes e skills
```

`settings.json` ativa o orquestrador como thread principal desde o primeiro turno.
Veja `CATALOGO.md` para o índice completo de agentes e skills.

---

## Testar localmente

Casos canônicos (3 por marco) em `tests/marco-{1,2,3,4}/casos.md`.
Checklists de critérios em `tests/marco-{1,2,3,4}/checklist.md`.

Procedimento E2E:
1. Criar pasta `tests/marco-1/execucoes/execucao-01-<descritor>/`
2. Executar `/iniciar-projeto` nessa pasta com o input do caso
3. Preencher `checklist.md` com `[x]` / `[ ]`
4. Salvar artefatos gerados + `notas.md` na pasta de execução

Critério de aprovação: checklist 100% `[x]` e `CRITICAL = 0` no `analyze-report.md` antes do Gate M3.

---

## Licença

Código aberto para fins acadêmicos. Em `references/normas/` são distribuídos apenas materiais com licença permissiva (RFCs IETF, paper arXiv, paper RESI); o handbook IREB, o paper IEEE (EARS 2009) e o preview da ISO 29148 **não** são redistribuídos — obtenha-os nos links oficiais indicados em `references/normas/README.md`. As demais referências bibliográficas ficam no monorepo pai (`referencias/`), fora deste repositório.
