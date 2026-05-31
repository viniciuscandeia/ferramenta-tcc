# ferramenta-tcc

Ferramenta de elicitação e documentação de requisitos para stakeholder leigo.
Conduz o usuário por perguntas estruturadas e gera SRS no padrão IREB §3.3.3 +
specs Gherkin + step definitions RED em 3 frameworks (Pytest-BDD, Cucumber-js, SpecFlow).

**Projeto:** TCC — Vinicius Candeia (deadline 2026-07-01)
**Plataforma:** Claude Code (v0.8.0+)

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

## Uso

Em qualquer diretório de projeto vazio:

```
/iniciar-projeto
```

O orquestrador conduz o processo de 4 marcos (Definição → Consenso → Detalhamento → Revisão Técnica opcional).
Responda as perguntas como faria com um analista de requisitos humano.

**Artefatos gerados ao final:**
- `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-para-leigo/01-visao/01-visao-produto.md` (Marco 1)
- `02.1-requisitos-funcionais.md`, `02.2-requisitos-qualidade.md`, `02.5-glossario.md` etc. (Marco 2)
- `03-srs-completo.md`, `04-spec/*.feature`, `05-tests/`, `06-estrategia-testes.md`, `07-como-rodar-testes.md` (Marco 3)

---

## Estrutura

```
ferramenta-tcc/
├── .claude-plugin/
│   └── plugin.json        # Manifesto Claude Code
├── settings.json          # Entry-point Claude Code (ativa orquestrador como thread principal)
├── agents/
│   └── orchestrator.md    # Agente principal (thread principal quando plugin habilitado)
├── skills/                # CC adapters — thin wrappers sem lógica de negócio
├── hooks/                 # gate_guard.sh (PreToolUse) + load_state.sh (SessionStart)

│   ├── orchestrator.md
│   ├── constitution.md
│   ├── agents/            # 5 sub-agentes funcionais (M1–M4)
│   ├── skills/            # 26 skills especializadas
│   ├── marcos/            # Slices por marco (m1–m4)
│   ├── workflows/         # Workflows detalhados por marco
│   └── templates/         # Templates de artefatos
├── catalogos-seed/        # Conhecimento destilado de domínios e requisitos típicos
├── tests/                 # Casos canônicos E2E + checklists por marco
└── CATALOGO.md            # Índice completo de agentes e skills
```

Engine canônico em raiz do plugin. Adapters em `skills/` e `agents/` são thin wrappers sem lógica de negócio.
`settings.json` força o orquestrador como thread principal desde o primeiro turno.
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
