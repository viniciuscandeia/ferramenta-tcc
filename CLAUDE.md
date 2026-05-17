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

A ferramenta tem **4 camadas**:

```
Orquestração: Marcos 1 / 2 / 3 com gates de aprovação humana
      ↓
6 Agentes-etapa: Visão | Elicitação | Análise | SRS | Validação | Gerência
      ↓ invocam sob demanda
5 Sub-agentes transversais: NLP | Implícitos | Conflitos | Recomendação | Visualização
      ↓ cada agente chama suas
~30 Skills (SKILL.md) — uma por técnica/seção, reutilizando ask_user
```

**Estado compartilhado = file-system.** O agente Gerência infere o marco corrente lendo artefatos em disco (`detection-based recovery`, D10). Nenhum agente depende de sessão persistente.

### Marcos e gates

| Marco | Agentes | Gate |
|---|---|---|
| Marco 1 — Definição da Necessidade | Visão do Produto | Gate 1: usuário aprova os 4 artefatos (`situacao-problema.md`, `vision-box.md`, `stakeholders.md`, `contexto-e-limite.md`) |
| Marco 2 — Consenso de Escopo | Elicitação ⇄ Análise (loop) | Gate 2: bloqueado enquanto `pautas-reelicitacao.md` tiver pendências |
| Marco 3 — Detalhamento | SRS ⇄ Validação (loop) | Gate 3: leigo aprova `aprovacao-cliente.md` (sem jargão) |

**Agente Gerência** é transversal — cria baselines, commits e changelog após cada gate.

### Distinção agente / sub-agente / skill

| Tipo | Isolamento de contexto | Tem estado? | Definido em |
|---|---|---|---|
| Agente-etapa | Sessão completa do CLI | Sim (conversação) | `.gemini/agents/<nome>.md` |
| Sub-agente transversal | Contexto isolado | **Não** (apátrida) | `.gemini/agents/<nome>.md` |
| Skill | Carregada no contexto do invocador | Compartilha a sessão | `.gemini/skills/<nome>/SKILL.md` |

Sub-agentes **não podem chamar outros sub-agentes** (limitação do Gemini CLI).

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
- **Empacotamento (D11)**: `gemini-extension.json` e `.claude-plugin/plugin.json` devem ser criados em paralelo ao desenvolvimento, não como etapa final.
- **Recuperação de falha em agentes**: salvar `.draft` + registrar em `_pendencias.md`. Nunca encerrar sessão com erro.

---

## Como rodar / testar

Não há toolchain (sem build, lint, ou testes unitários automatizados). O projeto é composto de prompts em Markdown.

**Testes E2E são executados manualmente no Gemini CLI:**

1. Ler os casos em `ferramenta-tcc/tests/marco-1/casos.md` (3 casos canônicos).
2. Executar cada caso no Gemini CLI com o agente `visao-produto`.
3. Preencher `ferramenta-tcc/tests/marco-1/checklist.md` com `[x]` / `[ ]`.
4. Salvar resultados em `ferramenta-tcc/tests/marco-1/execucoes/execucao-NN-<descritor>/` com os 4 artefatos + checklist + `notas.md`.

Critério de "passou": checklist 100% `[x]`.

Semanas futuras terão pastas equivalentes em `ferramenta-tcc/tests/marco-2/` e `marco-3/`.

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
| `docs/planejamento/3 - Arquitetura da Ferramenta.md` | Arquitetura completa: 11 agentes, 5 sub-agentes, ~30 skills, diretórios de saída, cronograma |
| `docs/planejamento/1 - Decisões Tomadas.md` | 11 decisões fundadoras (D1–D11) com justificativas; comparação com Problem-Based-SRS |
| `docs/planejamento/2 - Vocabulário Técnico: Agentes, Skills e Subagentes.md` | Definições plataforma-neutras + tabela de equivalências |
| `docs/planejamento/ROADMAP.md` | Progresso semana-a-semana; próximo passo concreto |
| `sandbox/ask_user_instructions.md` | Referência da primitiva `ask_user` (tipos, parâmetros, exemplos) |
| `ferramenta-tcc/.gemini/agents/visao-produto.md` | Agente de referência — único marco completamente implementado |
