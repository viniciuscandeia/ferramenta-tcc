# ferramenta-tcc

Ferramenta de elicitação e documentação de requisitos para stakeholder leigo.
Conduz o usuário por perguntas estruturadas e gera SRS no padrão IREB §3.3.3 +
specs Gherkin + step definitions RED em 3 frameworks (Pytest-BDD, Cucumber-js, SpecFlow).

**Projeto:** TCC — Vinicius Candeia (deadline 2026-07-01)

---

## Instalação

### Gemini CLI

```bash
# Via GitHub (recomendado):
gemini extension install https://github.com/viniciuscandeia/ferramenta-tcc

# Ou via path local (clone antes):
# gemini extension install /caminho/para/ferramenta-tcc
```

### Claude Code

```bash
# Adicionar o repo como fonte de plugins (uma vez):
claude plugin marketplace add viniciuscandeia/ferramenta-tcc

# Instalar o plugin:
claude plugin install ferramenta-tcc@ferramenta-tcc
```

Confirmar instalação:
```bash
gemini extension list   # deve mostrar "ferramenta-tcc 0.2.0"
claude plugin list      # deve mostrar "ferramenta-tcc 0.2.0"
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
- `visao-produto-normativo.md` + `-leigo.md` (Marco 1)
- `03.1-funcionais.md`, `03.2-qualidade.md`, `glossario.md` (Marco 2)
- `SRS-completo.md`, `spec/*.feature`, `tests/`, `TESTING-STRATEGY.md`, `README-TESTS.md` (Marco 3)

---

## Estrutura

```
ferramenta-tcc/
├── gemini-extension.json  # Manifesto Gemini CLI
├── GEMINI.md              # Entry-point Gemini CLI (carregado automaticamente como contexto global)
├── .claude-plugin/
│   └── plugin.json        # Manifesto Claude Code
├── settings.json          # Entry-point Claude Code (ativa agente orchestrator como thread principal)
├── agents/
│   └── orchestrator.md    # Agente principal Claude Code (thread principal quando plugin habilitado)
├── core/                  # Engine canônico (orquestrador, agentes, skills, constitution)
│   ├── orchestrator.md
│   ├── constitution.md
│   ├── agents/            # 5 sub-agentes funcionais (M1–M4)
│   └── skills/            # 26 skills especializadas
├── .gemini/               # Adapter Gemini CLI (commands/agents/skills wrappers)
├── .claude/               # Adapter Claude Code (commands/agents/skills wrappers)
├── catalogos-seed/        # Conhecimento destilado de domínios e requisitos típicos
├── tests/                 # Casos canônicos E2E + checklists por marco
└── CATALOGO.md            # Índice completo de agentes e skills
```

Engine canônico em `core/`. Adapters em `.gemini/` e `.claude/` são thin wrappers sem lógica de negócio.
`GEMINI.md` e `settings.json` forçam os CLIs a adotarem o orquestrador como thread principal desde o primeiro turno.
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

## Plataformas

| Plataforma | Versão mínima testada | Primitiva de pergunta | Sub-agentes |
|---|---|---|---|
| Gemini CLI | a verificar | `ask_user` | Persona adoption (sem Task()) |
| Claude Code | a verificar | `AskUserQuestion` | Sub-agentes reais |

---

## Licença

Código aberto para fins acadêmicos. Referências bibliográficas em `referencias/` (monorepo pai) não são distribuídas por restrição de licença.
