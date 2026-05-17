# bmad-code-org/BMAD-METHOD

**URL:** https://github.com/bmad-code-org/BMAD-METHOD
**Stars:** ~47.310 (verificado em 2026-05-16)
**Forks:** ~5.539
**Licença:** MIT (com proteção de marcas BMad, BMad Method, BMad Core)
**Linguagem dominante:** JavaScript (tooling) + Markdown/YAML (conteúdo operacional)
**Criado:** 2025-04-13

---

## 1. O que é

O BMAD-METHOD ("Breakthrough Method for Agile AI Driven Development") é um framework de desenvolvimento de software guiado por **6 agentes nomeados com personas especializadas**, cobrindo o ciclo completo desde análise de necessidade até implementação de código. O **público-alvo é desenvolvedores e líderes técnicos** confortáveis com assistentes de IA (Claude, Cursor, GitHub Copilot). O framework pressupõe literacia técnica e não foi concebido para stakeholders leigos.

---

## 2. Arquitetura

### 6 agentes nomeados (personas fixas)

| Agente | Nome | Fase | Papel |
|---|---|---|---|
| 1 | Mary | Analysis | Analista de Negócios |
| 2 | Paige | Analysis | Redatora Técnica |
| 3 | John | Plan/Workflows | Gerente de Produto |
| 4 | Sally | Plan/Workflows | Designer UX |
| 5 | Winston | Solutioning | Arquiteto de Sistemas |
| 6 | Amelia | Implementation | Engenheira Sênior |

### 4 fases sequenciais + core skills

**Core skills (12, transversais):** `bmad-party-mode`, `bmad-advanced-elicitation`, `bmad-brainstorming`, `bmad-distillator`, `bmad-help`, `bmad-index-docs`, `bmad-review-adversarial-general`, `bmad-review-edge-case-hunter`, `bmad-shard-doc`, `bmad-editorial-review-prose`, `bmad-editorial-review-structure`, `bmad-customize`.

**bmm-skills (por fase):**

| Fase | Skills |
|---|---|
| 1 — Analysis | `bmad-agent-analyst` (Mary), `bmad-agent-tech-writer` (Paige), `bmad-document-project`, `bmad-prfaq`, `bmad-product-brief` |
| 2 — Plan/Workflows | `bmad-agent-pm` (John), `bmad-agent-ux-designer` (Sally), `bmad-create-prd`, `bmad-edit-prd`, `bmad-validate-prd`, `bmad-create-ux-design` |
| 3 — Solutioning | `bmad-agent-architect` (Winston), `bmad-create-architecture`, `bmad-create-epics-and-stories`, `bmad-check-implementation-readiness`, `bmad-generate-project-context` |
| 4 — Implementation | `bmad-agent-dev` (Amelia), `bmad-dev-story`, `bmad-code-review`, `bmad-sprint-planning` |

### Party Mode — colaboração multi-agente real

Party Mode (`bmad-party-mode`) é o mecanismo de revisão com múltiplos agentes em paralelo. Funcionamento:

1. Usuário executa `bmad-party-mode`.
2. Sistema resolve roster de agentes via 4 camadas de configuração TOML (base do time, base pessoal, overrides do time, overrides pessoais).
3. Carrega `project-context.md` como contexto compartilhado.
4. Para cada mensagem do usuário: spawna 2-4 subagentes **em paralelo** via Agent Tool, cada um com sua persona, resumo da conversa (máx. 400 palavras) e mensagens dos outros agentes quando relevante.
5. Protocolo explícito de **discordância autêntica**: agentes instruídos a discordar quando sua perspectiva indicar isso, sem suavizar posições.
6. Cada perspectiva aparece em seção própria, nunca parafraseada. "Orchestrator Note" opcional marca discordâncias significativas.

**handoff entre fases:** artefato-driven. `product-brief.md` → PRD → arquitetura → épicos/stories → `project-context.md` como constituição compartilhada carregada por 7 workflows. Gate entre Fase 3 e Fase 4: `bmad-check-implementation-readiness` emite PASS/CONCERNS/FAIL, mas a decisão é do humano.

**Instalação:** `npx bmad-method install` no diretório do projeto. Cria `_bmad/` (configuração) e `_bmad-output/` (artefatos).

---

## 3. Técnicas de elicitação / geração

O BMAD não é uma ferramenta de elicitação de requisitos — é de engenharia de software guiada por agentes. A elicitação que existe é orientada a produto/código, não a requisitos formais.

**Mecanismos de interação:**
- **Input conversacional livre** em linguagem natural. Quando a intenção é clara, o agente inicia sem menus.
- **Triggers curtos** dentro de sessão de agente (ex: `DS`, `CP`) para invocar workflows predefinidos.
- **`bmad-help` contextual**: aceita queries abertas, escaneia artefatos existentes (PRD, arquitetura, stories) e recomenda próxima ação com comando específico. Funciona como GPS do processo.
- **`bmad-advanced-elicitation`**: o componente de maior valor para elicitação. Fluxo: analisa o contexto → seleciona 5 dos **50 métodos disponíveis** (organizados em 12 categorias) → apresenta menu numerado com opções `[r] Reshuffle`, `[a] List All`, `[x] Proceed` → aplica o método → usuário aceita/rejeita/itera.

**Os 50 métodos em `methods.csv` cobrem 12 categorias:** Core, Colaborativo, Avançado, Competitivo, Técnico, Criativo, Pesquisa, Risco, Filosófico, Retrospectivo, Aprendizado. Incluem: Pré-mortem, Primeiros Princípios, Socrático, SCAMPER, 5 Porquês, Tree of Thoughts, Red Team vs Blue Team, entre outros.

- **PRFAQ**: adaptação do método "Working Backwards" da Amazon — o usuário escreve comunicado de imprensa antes do desenvolvimento como técnica de validação de visão.
- **`bmad-brainstorming`**: gera 100+ ideias com protocolo anti-viés que desloca domínios a cada 10 ideias.

Não há primitiva equivalente ao `ask_user`. Interação é majoritariamente conversacional sem perguntas estruturadas choice/yesno/text.

---

## 4. Saída

| Fase | Artefatos |
|---|---|
| Analysis | `brainstorming-report.md`, `product-brief.md` (1-2 páginas), `prfaq-{projeto}.md`, relatórios de pesquisa |
| Planning | `prd.md`, `addendum.md`, `decision-log.md`, `validation-report.md`, `ux-spec.md` |
| Solutioning | `architecture.md` (com ADRs), `epics/*.md` com stories, `project-context.md` |
| Implementation | `sprint-status.yaml`, `story-[slug].md`, código e testes, relatório de retrospectiva |

**Padrões formais:** nenhuma referência verificada a IEEE 29148, IREB §3.3.3, EARS ou RFC 2119. O PRD segue convenções de produto/startup (épicos, stories, MVPs), não o formato SRS formal.

---

## 5. Stack e dependências

| Categoria | Detalhe |
|---|---|
| Runtime | Node.js v20+ (instalador), Python 3.10+ com `uv` (scripts de roster) |
| IDE | Claude Code, Cursor, ou qualquer IDE com suporte a agentes de IA |
| Extensões opcionais | BMad Builder, Creative Intelligence Suite, Game Dev Studio, Test Architect (TEA com 9 workflows) |
| Estado | Arquivos Markdown + YAML versionáveis no filesystem |
| Configuração | TOML (4 camadas: time-base, pessoal-base, overrides-time, overrides-pessoais) |

---

## 6. Pontos fortes

1. **Biblioteca de 50 métodos de elicitação em `methods.csv`** — separação entre definição de método e lógica de seleção. `bmad-advanced-elicitation` seleciona os 5 mais relevantes ao contexto e apresenta menu interativo. O componente de maior densidade de valor para uma ferramenta de elicitação.
2. **Party Mode com subagentes reais em paralelo via Agent Tool** — não é uma simulação: os agentes são processos separados com contexto isolado. O protocolo de discordância autêntica ("discorde quando indicado; não suavize posições") produz perspectivas mais ricas que consenso performativo.
3. **`project-context.md` como constituição compartilhada** — carregado automaticamente por 7 workflows; garante consistência de decisões técnicas entre agentes independentes sem coordenação em tempo real.
4. **`bmad-help` contextual com scan de artefatos** — escaneia o filesystem, detecta artefatos existentes e recomenda ação específica com comando de skill. Funciona como GPS do processo tanto para iniciantes quanto após retomada de sessão.
5. **Arquitetura modular com instalação seletiva** — core + módulos opcionais por domínio (Game Dev, Test Architect) sem poluir o núcleo.

---

## 7. Limitações

1. **Público-alvo exclusivamente técnico** — linguagem dos agentes, artefatos (PRD, arquitetura, épicos, stories, ADRs) e mecanismos de interação são opacos para stakeholders leigos. Sem mecanismo de tradução de jargão ou adaptação de complexidade.
2. **Ausência de padrões formais de requisitos** — sem IEEE 29148, IREB §3.3.3, RFC 2119. O PRD é documento de produto/startup, não SRS auditável academicamente.
3. **Estado conversacional sem controle de versão de artefatos intermediários** — sistema depende de Git externo para histórico; não há mecanismo explícito de rollback de artefatos por marco.
4. **Dependência de IDE específica** — projetado para Claude Code e Cursor. Outros ambientes sem suporte documentado.

---

## 8. Inspirações para nossa ferramenta

| Inspiração | Impacto | Esforço | Decisão afetada |
|---|---|---|---|
| **Biblioteca de métodos em CSV separado da lógica de seleção** (`methods.csv` com 50 técnicas em 12 categorias) | Alto | Baixo | Complementa [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) — criar `catalogo-tecnicas-elicitacao.md` (ou CSV) curado com técnicas adaptadas ao leigo; sub-agentes NLP e Implícitos consultam esse catálogo para escolher técnica mais adequada ao contexto |
| **Party Mode com subagentes reais em paralelo + protocolo de discordância autêntica** | Alto | Médio | Complementa [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) e [D7](../../planejamento/1%20-%20Decisões%20Tomadas.md) — no gate M2, spawnar Conflitos + Implícitos + Recomendação em paralelo, cada um com instrução para discordar autenticamente; Agente Análise sintetiza e apresenta divergências ao usuário |
| **`bmad-help` com scan de artefatos para orientação contextual** | Médio | Baixo | Complementa [D10](../../planejamento/1%20-%20Decisões%20Tomadas.md) — ao iniciar nova sessão após interrupção, a ferramenta escaneia artefatos existentes e recomenda onde retomar; complementa o detection-based recovery do Agente Gerência |
| **Menu interativo numerado do `bmad-advanced-elicitation`** | Médio | Baixo | Complementa [D1](../../planejamento/1%20-%20Decisões%20Tomadas.md) — padrão `[1-4] opção, [r] outra, [x] confirmar` adaptado ao `ask_user choice` apresenta técnicas de refinamento ao stakeholder de forma acessível |
| **`project-context.md` como constituição compartilhada carregada por todos os workflows** | Alto | Baixo | Complementa [D10](../../planejamento/1%20-%20Decisões%20Tomadas.md) e [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) — formalizar um `contexto-projeto.md` com domínio, restrições, decisões de escopo e glossário do negócio, carregado por todos os 6 agentes-etapa |

---

## 9. Diferenças de filosofia

1. **Público e direção da tradução:** BMAD traduz complexidade de desenvolvimento para desenvolvedores experientes. Nossa proposta faz o oposto — traduz necessidades de negócio de um leigo para artefatos técnicos rigorosos. O BMAD pressupõe que o usuário sabe o que quer construir e precisa de suporte no *como*; nossa proposta pressupõe que o usuário não sabe articular o que quer e precisa de suporte no *que*.
2. **Fidelidade a padrões formais vs. agilidade informal:** BMAD usa PRDs, épicos e sprints sem ancoragem em normas internacionais. Nossa proposta ancora a saída em IEEE 29148 / IREB §3.3.3 com RFC 2119 — maior custo de geração, maior auditabilidade e defensabilidade acadêmica.
3. **Autonomia vs. gates de aprovação humana:** a skill `bmad-quick-dev` tem como meta "Intent in, code changes out, with as few human-in-the-loop turns as possible". Nossa proposta tem a filosofia oposta: gates M1/M2/M3 com aprovação explícita e estruturada são inegociáveis ([D3](../../planejamento/1%20-%20Decisões%20Tomadas.md)) — o leigo precisa de mais pontos de controle, não menos.

---

## 10. URLs consultadas

- https://api.github.com/repos/bmad-code-org/BMAD-METHOD
- https://api.github.com/repos/bmad-code-org/BMAD-METHOD/contents (+ subconteúdos de `src/`, `docs/`)
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/README.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/AGENTS.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/index.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/reference/agents.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/reference/workflow-map.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/reference/core-tools.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/reference/commands.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/reference/modules.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/named-agents.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/party-mode.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/advanced-elicitation.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/analysis-phase.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/project-context.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/explanation/quick-dev.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/docs/tutorials/getting-started.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/src/core-skills/bmad-advanced-elicitation/SKILL.md
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/src/core-skills/bmad-advanced-elicitation/methods.csv
- https://raw.githubusercontent.com/bmad-code-org/BMAD-METHOD/main/src/core-skills/bmad-party-mode/SKILL.md
