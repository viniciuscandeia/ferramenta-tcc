# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Visão geral

TCC de Vinicius Candeia. Uma ferramenta executada via **Gemini CLI** (porte para **Claude Code** é objetivo MVP — D11, não stretch) que conduz a elicitação e documentação de requisitos de software por perguntas estruturadas ao **stakeholder/cliente leigo**. A ferramenta substitui integralmente o papel do analista de requisitos e gera um SRS no padrão **IREB §3.3.3 (ISO/IEC/IEEE 29148)**.

**Prazo:** 2026-07-01

---

## Layout do repositório (estrutura dupla)

| Pasta | Papel |
|---|---|
| `ferramenta-tcc/` | **A ferramenta** — agentes, skills, catálogos seed, testes |
| `docs/planejamento/` | Decisões de design, arquitetura, vocabulário técnico, roadmap |
| `docs/estudo-skills/` | Notas de pesquisa sobre design de skills |
| `referencias/` | Bibliografia consultada (PDFs, markdowns). **Não distribuível** |
| `sandbox/` | Código e skills exploratórios, não-produção |
| `.gemini/skills/ask-user-info/` | Skill de exemplo no root (sandbox) — não é parte da ferramenta |

A **ferramenta** vive inteiramente em `ferramenta-tcc/`. Tudo fora dela é pesquisa/suporte.

---

## Arquitetura big-picture

A ferramenta tem **3 camadas** (topologia MARE-style — arXiv 2405.03256; D6 revisada 2026-05-17):

```
1 Orquestrador (core/orchestrator.md)  ← entry-point único /iniciar-projeto
      ↓ roteia por marco, gerencia 4 gates, baseline git pós-gate
5 Sub-agentes funcionais ER (core/agents/)
   M1: stakeholder-identifier
   M2: collector ⇄ modeler  (loop interno)
   M3: documenter ⇄ checker (loop interno)
   M4: checker (modo técnico) — opcional, D24
      ↓ cada sub-agente invoca
~22 Skills (core/skills/) + 4 transversais
   + catálogos seed em catalogos-seed/
```

**Estado compartilhado:** `estado-projeto.yaml` (D13, SoT primário) + file-system (detection-based D10, fallback). `constitution.md` (D15) carregado por todos em runtime. Nenhum agente depende de sessão persistente.

### Marcos e gates

| Marco | Sub-agentes | Artefatos esperados | Gate |
|---|---|---|---|
| Marco 1 — Definição da Necessidade | `stakeholder-identifier` | `visao-produto.md` (versão leigo + normativa) | Gate 1: leigo aprova versão leigo |
| Marco 2 — Consenso de Escopo | `collector` ⇄ `modeler` (loop) | `03.1-funcionais.md`, `03.2-qualidade.md`, `glossario.md`, `pautas-reelicitacao.md` — 2 versões | Gate 2: leigo aprova; bloqueado se `pautas-reelicitacao.md` tem pendências |
| Marco 3 — Detalhamento | `documenter` ⇄ `checker` (loop) | `SRS-completo.md` + `spec/*.feature` + `tests/` + `TESTING-STRATEGY.md` + `README-TESTS.md` | Gate 3: leigo aprova versão leigo do SRS; CRITICAL do analyze bloqueia |
| Marco 4 — Revisão Técnica (D24, opcional) | `checker` (modo técnico) | `revisao-tecnica.md` + `aprovacao-tecnica.md` | Gate 4: desenvolvedor/tech lead aprova |

**Orquestrador** cria baselines (snapshot + tag git) após cada gate. `constitution.md` + `estado-projeto.yaml` são os guardrails de runtime.

### Distinção orquestrador / sub-agente / skill

| Tipo | Isolamento de contexto | Tem estado? | Definido em |
|---|---|---|---|
| Orquestrador | Sessão completa do CLI | Sim | `core/orchestrator.md` → adapter |
| Sub-agente funcional ER | Contexto isolado (Claude Code) / persona mesmo contexto (Gemini CLI) | **Não** (apátrida entre marcos) | `core/agents/<nome>.md` → adapter |
| Skill | Carregada no contexto do invocador | Compartilha a sessão | `core/skills/<nome>/SKILL.md` → adapter |

Sub-agentes **não podem chamar outros sub-agentes** (limitação do Gemini CLI — usa persona adoption).

### Primitiva de interação

**Toda** elicitação passa por `ask_user` (Gemini CLI) / `AskUserQuestion` (Claude Code).  
Tipos suportados: `choice`, `text`, `yesno`. Máximo de 4 perguntas por chamada.

---

## Convenções críticas

### Lista-negra de jargão de ER (D1 — usuário-alvo é leigo)

Estas expressões são **proibidas** em qualquer prompt ou pergunta gerada para o usuário final:

| Proibido | Use em vez disso |
|---|---|
| Requisito funcional / RF | "O que o produto precisa fazer" |
| Requisito não-funcional / RNF | "Como o produto precisa se comportar" |
| Elicitar / elicitação | "Descobrir" / "levantar" / "entender" |
| Rastreabilidade | "Saber de onde veio cada decisão" |
| Stakeholder | "Pessoa envolvida" / "quem tem interesse" |
| Escopo | "O que está dentro e fora do projeto" |
| Iteração / Sprint | "Etapa" / "rodada de trabalho" |
| Backlog | "Lista de coisas a fazer" |
| Caso de uso | "Situação de uso" / "como a pessoa vai usar" |
| SRS / ERS | "Documento de requisitos" / "documento do projeto" |
| Marco | "Etapa principal" / "fase" |

### Outras regras que afetam a implementação

- **Skills sempre com frontmatter `name` + `description`** — necessário para auto-detecção por match de descrição pelo Gemini CLI.
- **Catálogos seed em `ferramenta-tcc/catalogos-seed/`** contêm conhecimento destilado das referências bibliográficas. A ferramenta **não** lê `referencias/` em runtime.
- **Empacotamento (D11)**: `gemini-extension.json` e `.claude-plugin/plugin.json` criados na Semana 3 (início), não como etapa final.
- **Engine canônico (D12)**: toda lógica em `ferramenta-tcc/core/`. Adapters `.gemini/` e `.claude/` são thin wrappers — sem lógica de negócio.
- **Recuperação de falha em agentes**: `estado-projeto.yaml` (D13) é SoT; detection-based (D10) é fallback. Salvar `.draft` + registrar em `_pendencias.md`. Nunca encerrar sessão com erro.

---

## Como rodar / testar

Não há toolchain (sem build, lint, ou testes unitários automatizados). O projeto é composto de prompts em Markdown.

**Testes E2E são executados manualmente no Gemini CLI e Claude Code:**

1. Ler os casos em `ferramenta-tcc/tests/marco-{N}/casos.md` (3 casos canônicos por marco).
2. Executar `/iniciar-projeto` em cada caso nas **duas plataformas** (Gemini CLI + Claude Code).
3. Preencher `ferramenta-tcc/tests/marco-{N}/checklist.md` com `[x]` / `[ ]`.
4. Salvar resultados em `ferramenta-tcc/tests/marco-{N}/execucoes/execucao-NN-<descritor>/` com artefatos + checklist + `notas.md`.

Critério de "passou": checklist 100% `[x]`; CRITICAL do analyze = 0 antes do Gate M3.

---

## Equivalências Gemini CLI ↔ Claude Code (para o porte)

| Conceito | Gemini CLI | Claude Code |
|---|---|---|
| Contexto persistente | `GEMINI.md` | `CLAUDE.md` |
| Sub-agentes | `.gemini/agents/<nome>.md` | `.claude/agents/<nome>.md` |
| Skills | `.gemini/skills/<nome>/SKILL.md` | `~/.claude/skills/<nome>/SKILL.md` |
| Slash commands | `.gemini/commands/<nome>.toml` | `.claude/commands/<nome>.md` |
| Pergunta interativa bloqueante | `ask_user` (tool) | `AskUserQuestion` (tool) |

Referência completa: `docs/planejamento/2 - Vocabulário Técnico: Agentes, Skills e Subagentes.md`

---

## Documentos essenciais para ler primeiro

| Arquivo | Conteúdo |
|---|---|
| `docs/planejamento/3 - Arquitetura da Ferramenta.md` | **Arquitetura canônica** (este é o doc de referência): 1 orquestrador + 5 sub-agentes MARE-style + ~22 skills, 4 marcos e gates, engine D12 |
| `docs/planejamento/1 - Decisões Tomadas.md` | 24 decisões (D1–D24) com justificativas; comparação com Problem-Based-SRS |
| `docs/planejamento/2 - Vocabulário Técnico: Agentes, Skills e Subagentes.md` | Definições plataforma-neutras + tabela de equivalências |
| `docs/planejamento/ROADMAP.md` | Progresso semana-a-semana; próximo passo concreto |
| `sandbox/ask_user_instructions.md` | Referência da primitiva `ask_user` (tipos, parâmetros, exemplos) |
| `ferramenta-tcc/catalogos-seed/` | Catálogos seed (únicos artefatos da ferramenta já implementados) |
