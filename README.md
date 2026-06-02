# ferramenta-tcc

Ferramenta de elicitação e documentação de requisitos para stakeholder leigo.
Conduz o usuário por perguntas estruturadas e gera SRS no padrão IREB §3.3.3 +
specs Gherkin + step definitions RED em 3 frameworks (Pytest-BDD, Cucumber-js, SpecFlow).
Ao concluir, exporta a documentação completa em PDF automaticamente.

**Projeto:** TCC — Vinicius Candeia (deadline 2026-07-01)
**Plataforma:** Claude Code (v0.17.1+)

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

**macOS:**
```bash
brew install pandoc
brew install --cask basictex
```

**Ubuntu/Debian:**
```bash
sudo apt install pandoc texlive-xetex
```

### Opção 2 — md-to-pdf (mais leve, requer Node.js)

```bash
npm install -g md-to-pdf
```

### Opção 3 — weasyprint (requer Python)

```bash
pip install weasyprint
```

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
- `pdf/documentacao-tecnica.pdf` — versão técnica (SRS, specs, estratégia de testes)

---

## Estrutura

```
ferramenta-tcc/
├── .claude-plugin/
│   └── plugin.json        # Manifesto (metadados apenas — sem hooks inline)
├── settings.json          # Apenas: {"agent": "orchestrator"}
├── hooks/
│   └── hooks.json         # Todos os 4 hooks (SessionStart, PreToolUse, PostToolUse, UserPromptSubmit)
├── agents/                # Definições de agente (orchestrator + 5 sub-agentes)
│   └── orchestrator.md    # Agente principal (system prompt quando plugin habilitado)
├── skills/                # 28 skills de elicitação, documentação e exportação
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

Casos canônicos (3 por marco) em `tests/marco-{1,2,3}/casos.md`.
Checklists de critérios em `tests/marco-{1,2,3}/checklist.md`.

Procedimento E2E:
1. Criar pasta `tests/marco-1/execucoes/execucao-01-<descritor>/`
2. Executar `/iniciar-projeto` nessa pasta com o input do caso
3. Preencher `checklist.md` com `[x]` / `[ ]`
4. Salvar artefatos gerados + `notas.md` na pasta de execução

Critério de aprovação: checklist 100% `[x]` e `CRITICAL = 0` no `analyze-report.md` antes do Gate M3.

---

## Licença

Código aberto para fins acadêmicos. Referências bibliográficas em `referencias/` (monorepo pai) não são distribuídas por restrição de licença.
