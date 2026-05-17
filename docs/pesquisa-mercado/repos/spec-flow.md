# marcusgoll/Spec-Flow

**URL:** https://github.com/marcusgoll/Spec-Flow
**Autor:** Marcus Goll (marcusgoll)
**Stars:** ~85
**Licença:** MIT
**Linguagem dominante:** Shell
**Criado:** 2025-10-04

---

## 1. O que é

Toolkit de workflow para **Spec-Driven Development** instalado em projetos consumidores. Descrição oficial: *"Turn product ideas into production launches with Spec-Driven Development. Repeatable Claude Code workflows with quality gates, token budgets, and auditable artifacts."* O **público-alvo é equipes de desenvolvimento de software** — solo devs até squads, com papéis de dev, QA, DevOps e product lead. Stakeholders não-técnicos aparecem apenas marginalmente no vocabulário.

---

## 2. Arquitetura

Pipeline de 11 fases orquestrado por slash-commands, com agents especialistas instanciados isoladamente:

```
spec → clarify → plan → tasks → validate → implement → optimize
     → ship-staging → validate-staging → ship-prod → finalize
```

**Três orquestradores por complexidade de feature:**
- `/feature` — features de até ~16 horas
- `/epic` — features longas (multi-sprint com paralelismo)
- `/quick` — mudanças de até ~30 minutos

**Estrutura de camadas (separação rigorosa):**

```
.spec-flow/     ← engine canônico, tool-agnostic (templates, scripts, memória, schemas)
.claude/        ← adapter Claude Code (thin wrapper)
.codex/         ← adapter Codex (partial)
```

Adapters **não** redefinem a lógica do engine. Toda a inteligência está em `.spec-flow/`. A separação engine/adapter é explicitada em `CONTEXT.md` como princípio arquitetural central.

**Estado por epic:** `state.yaml` como source of truth, seeded de `epic-state.template.yaml`. Permite resumabilidade via `/feature continue`.

**Domain Memory:** workers atômicos executam ONE task lendo `domain-memory.yaml` e saem sem reter contexto entre invocações — padrão apátrida similar aos nossos sub-agentes transversais.

**Question batching:** agentes retornam queries em batch antes de re-spawn; main context coleta antes de prosseguir. Formaliza o padrão de perguntas agrupadas.

**Token budget management:** limites explícitos por fase (75k/100k/125k tokens); auto-compact acima de 80% de uso.

---

## 3. Técnicas de elicitação / geração

Não há primitiva única tipo `ask_user`. Input vem de:
- **Questionários inline em `/init`:** `init-preferences` (8 perguntas) e `init-project` (~15 perguntas em ~10 min).
- **Flags de comando:** `--auto` (modo não-interativo), `--ui-first`, `--no-input`.
- **Preference system de 3 camadas:** config → history → flags.
- **`/clarify` como fase dedicada:** acionada quando a spec apresenta ambiguidades acima de limites definidos.
- **Approval gates manuais** em pontos específicos do pipeline.

O input do usuário é guiado por seções de template, não por prosa livre processada via NLP. Não há documentação de análise semântica do input.

---

## 4. Saída

Por feature, os artefatos gerados incluem: `spec.md`, `NOTES.md`, `state.yaml`, `plan.md`, `research.md`, `tasks.md`, `optimization-report.md`, `code-review-report.md`, `error-log.md`.

**`spec-template.md` com 13 seções:**

| Seção | Conteúdo |
|---|---|
| Problem & Goal | Declaração do problema e objetivo |
| Users & JTBD | Jobs-to-be-done por persona |
| User Scenarios | **Gherkin** Given/When/Then |
| User Stories | Priorizadas (P1-P3, XS-XL) |
| Functional Requirements | **"System MUST"** (FR-00X) |
| Non-Functional Requirements | FCP <1.5s, **WCAG 2.2 AA**, P95 <500ms |
| HEART Metrics | Happiness, Engagement, Adoption, Retention, Task success |
| Measurement Plan | Métricas e instrumentação |
| Screens | Mockups / wireframes textuais |
| Hypothesis | Hipótese de valor |
| Deployment | Plano de rollout |
| Traceability Matrix | Requisitos → casos de aceite |
| Open Questions + Implementation Status | Pendências abertas |

**Padrões verificados:** RFC 2119 (MUST/SHALL) explícito; Gherkin; WCAG 2.2 AA. **Não cita IEEE 29148, IREB §3.3.3 ou EARS** nos arquivos consultados.

---

## 5. Stack e dependências

| Categoria | Tecnologias |
|---|---|
| IDE primária | Claude Code |
| IDEs de porte | Gemini CLI (persona adoption), Codex (adapter parcial) |
| Instalação | `npx spec-flow init/status/update` |
| Scripts | Python (`spec-cli.py` ~44KB), Shell/Bash, PowerShell, Node (.mjs) |
| Dependências runtime | Git 2.39+, PowerShell 7.3+/Bash 5+, Python 3.10+, yq 4.0+ |
| Integrações | GitHub Issues, PostHog, Playwright, Lighthouse |
| Estado | File-system (YAML + Markdown versionado em git) |

Porte Gemini CLI exigiu redesenho: `Task()` do Claude Code foi substituído por "persona adoption" (o modelo adota o papel do agente em vez de instanciar um sub-processo separado).

---

## 6. Pontos fortes

1. **Separação engine canônico vs. adapter por IDE** — toda a lógica reside em `.spec-flow/`; adapters são wrappers finos. Viabiliza porte multi-IDE sem fork da inteligência. Princípio documentado em `CONTEXT.md`.
2. **Gates automatizados densos em `/optimize`** — 10+ verificações (performance, security, a11y, code review, migrations, docker, E2E, API contracts, load test, migration integrity) conforme `docs/quality-gates.md`.
3. **Token budget management explícito** — limites por fase com auto-compact acima de 80%. Previne falhas silenciosas por context overflow em sessões longas.
4. **`state.yaml` por epic como source of truth** — recovery determinístico sem inferência; resumabilidade nativa via `/feature continue`.
5. **40+ templates especializados** — cobrem spec, plan, tasks, E2E, Lighthouse, load-test, migration, mockup-approval, walkthrough. Ciclo completo de desenvolvimento, não só a spec.
6. **Question batching formalizado** — agentes retornam queries em batch antes de re-spawn, reduzindo context switches e latência.

---

## 7. Limitações

1. **Público técnico-only** — questionários assumem decisões de stack (banco, deploy, auth). Sem vocabulário ou fluxo adaptado para cliente não-técnico.
2. **Gates "humanos" são poucos** — quase todos os gates em `docs/quality-gates.md` são `Automated`; único gate manual real é `/validate-staging`. O foco é qualidade de código/deploy, não aprovação de stakeholder.
3. **Acoplamento com `Task()` do Claude Code** — porte Gemini exigiu redesenho arquitetural (persona adoption). Indica que a separação engine/adapter ainda tem pontos de vazamento.
4. **Padrões não formais** — sem IEEE 29148, IREB, EARS. A spec é produto-comercial (JTBD/HEART/ICE/screens), não derivada de framework acadêmico de ER.

---

## 8. Inspirações para nossa ferramenta

| Inspiração | Impacto | Esforço | Decisão afetada |
|---|---|---|---|
| **Engine canônico vs. adapter por IDE** (`.spec-flow/` + `.claude/` + `.gemini/`) | Alto | Médio | Complementa [D11](../../planejamento/1%20-%20Decisões%20Tomadas.md) — isolar lógica de prompt/agente do adapter por plataforma; o porte Gemini→Claude Code se torna adaptação de interface, não reescrita de conteúdo |
| **`state.yaml` por projeto como source of truth** | Alto | Baixo | Complementa [D10](../../planejamento/1%20-%20Decisões%20Tomadas.md) — substituir inferência por file-system leitura por um `estado-projeto.yaml` explícito; recovery determinístico e auditável |
| **Token budget por fase + auto-compact** | Médio | Médio | Complementa [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) — sub-agentes transversais em sessões longas (estudo de caso real) podem exceder limites; budget explícito previne falhas silenciosas |
| **Question batching pattern** | Alto | Baixo | Complementa [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) e formaliza o limite de 4 perguntas do `ask_user` — agente coleta todas as perguntas necessárias, exibe em lote, processa respostas |
| **Traceability matrix como seção obrigatória da spec** | Médio | Baixo | Complementa [D4](../../planejamento/1%20-%20Decisões%20Tomadas.md) e [D8](../../planejamento/1%20-%20Decisões%20Tomadas.md) — adicionar seção de rastreabilidade explícita no template SRS, além do que IREB §3.3.3 já prevê |

---

## 9. Diferenças de filosofia

1. **Público dev-first vs. stakeholder-leigo-first:** Spec-Flow é orientado a times de desenvolvimento que precisam de um pipeline estruturado de spec → código. Nossa proposta ([D1](../../planejamento/1%20-%20Decisões%20Tomadas.md)) inverte o eixo: o usuário é o dono do negócio, e a ferramenta substitui o analista de requisitos.
2. **Gates automatizados de código vs. gates humanos de requisitos:** Spec-Flow tem 10+ gates automatizados focados em qualidade de código e deploy; nossos gates M1/M2/M3 ([D3](../../planejamento/1%20-%20Decisões%20Tomadas.md)) são humanos e focados em aprovação de artefatos de ER. Camadas complementares — o Spec-Flow começa onde o nosso termina (da SRS aprovada para o código).
3. **Spec produto-comercial vs. SRS formal:** Spec-Flow gera spec orientada a produto (JTBD/HEART/ICE/screens/hypothesis). Nossa proposta ([D4](../../planejamento/1%20-%20Decisões%20Tomadas.md), [D8](../../planejamento/1%20-%20Decisões%20Tomadas.md)) gera SRS formal IREB §3.3.3 com EARS + RFC 2119, auditável academicamente.

---

## 10. URLs consultadas

- https://github.com/marcusgoll/Spec-Flow
- https://api.github.com/repos/marcusgoll/Spec-Flow (+ /contents)
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/README.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/CLAUDE.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/CONTEXT.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/QUICKSTART.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/GEMINI.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/AGENTS.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/.spec-flow/IMPLEMENTATION_GUIDE.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/.spec-flow/templates/spec-template.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/.spec-flow/templates/plan-template.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/.spec-flow/templates/tasks-template.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/architecture.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/commands.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/quality-gates.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/use-cases.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/project-design-guide.md
- https://raw.githubusercontent.com/marcusgoll/Spec-Flow/main/docs/getting-started.md
