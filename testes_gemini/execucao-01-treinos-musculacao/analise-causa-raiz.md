# Análise de Causa-Raiz — Execução 01

---

## Causa 1 (primária) — Bug conhecido: Gemini CLI não invoca skills automaticamente

**Issue:** [google-gemini/gemini-cli#21968 — "Gemini does not use skills and sub-agents enough"](https://github.com/google-gemini/gemini-cli/issues/21968)

**Citação do issue:**
> Gemini does not use custom skills and sub-agents automatically; it will use them only if explicitly instructed, even when doing something very related.

**Status:** aberto, prioridade p2, label `area/agent kind/bug`, necessita re-teste.

**Por que isso quebra a ferramenta-tcc:**

A arquitetura da ferramenta assume que o Gemini CLI invoca skills por description-matching: cada skill em `core/skills/` tem frontmatter `description` projetado para que o CLI reconheça o momento certo de ativá-la. Quando esse contrato não é cumprido:

1. O orquestrador avança os marcos sem invocar `traducao-gate` → ausência de pares `-leigo`/`-normativo`.
2. Sem `classificacao-rf-rnf` + `priorizacao` + `glossario` + skills de elicitação das 5 rondas → ausência de toda a estrutura `03.x`.
3. Sem `srs-ireb-template` + `requisito-ears` → SRS fora do canônico (nome errado, 4 seções em vez de 6, sem EARS).
4. Sem `gherkin-spec` + `step-defs-red` + `testing-strategy` + `readme-tests` → pipeline técnico inteiro de M3 ausente.
5. Sem `analyze-cross-artifact` aplicado com os 3 cruzamentos → `analyze-report.md` raso.

**Evidência adicional:** a documentação oficial confirma que o modelo de ativação de skills é "consent-based" (usuário vê prompt de ativação na UI e precisa aprovar). Não há mecanismo de **forçar** invocação de skill no Gemini CLI. Fonte: [Agent Skills | Gemini CLI docs](https://geminicli.com/docs/cli/skills/).

---

## Causa 2 (secundária) — Sub-agentes instáveis no Gemini CLI

**Issue:** [google-gemini/gemini-cli#18064 — "Experimental agents hang indefinitely on 'Starting Agent Creation'"](https://github.com/google-gemini/gemini-cli/issues/18064)

Agentes em `~/.gemini/agents/` podem travar no fluxo de aprovação, especialmente para agentes globais. A ferramenta-tcc define 5 sub-agentes em `core/agents/` que o adapter `.gemini/` deveria mapear. Se o dispatch não funcionar, o "agente" executa no contexto da conversa principal sem isolamento de persona.

**Consequência:** o agente executa na persona do orquestrador, não na persona especializada (ex: `collector` tem uma lista de skills obrigatórias por ronda que simplesmente não é honrada quando não há switch real de persona).

**Workaround do ecossistema:** obra/superpowers#1045 — skills `subagent-driven-development` e `dispatching-parallel-agents` fazem fallback explícito para single-session no Gemini CLI v0.36+. Fonte: [obra/superpowers#1045](https://github.com/obra/superpowers/issues/1045).

---

## Causa 3 (terciária) — Ausência de enforcement externo (hooks)

O Claude Code tem hooks `PreToolUse`/`PostToolUse` que permitem verificação programática a cada turno. O Gemini CLI não tem equivalente. Portanto:

- **C4.4** (auto-checagem de nomes proibidos) só roda se a skill que o implementa for invocada.
- **C4.5** (verificar artefatos esperados ausentes) — não existe hoje na ferramenta; mesmo se existisse, só rodaria dentro de uma skill.
- Não há camada externa que detecte "o turno terminou sem produzir o artefato X" e bloqueie o avanço.

---

## Diagrama de causas

```
Bug #21968 (Gemini não auto-invoca skills)
    └─→ traducao-gate nunca roda
    │       └─→ ausência de pares -leigo / -normativo em todos os marcos
    └─→ classificacao-rf-rnf, glossario, priorizacao nunca rodam
    │       └─→ ausência de 03.1/03.2/03.3 + leigo + glossario (M2 inteiro)
    └─→ srs-ireb-template, requisito-ears nunca rodam
    │       └─→ srs.md com nome errado, 4 seções, sem EARS
    └─→ gherkin-spec, step-defs-red, testing-strategy, readme-tests nunca rodam
            └─→ pipeline técnico M3 ausente

Bug #18064 (sub-agentes travam) + sem hooks de enforcement
    └─→ loops M2 e M3 não iteraram (1 passagem única)
    └─→ C4.4 nunca disparou → nomes proibidos não bloquearam
    └─→ aprovacao-tecnica.md gerada sem revisao-tecnica.md
```

---

## O que a execução revela sobre o contrato de plataforma

A ferramenta-tcc tem **modo Gemini CLI** descrito em CLAUDE.md como "persona adoption" para sub-agentes. Na prática, o Gemini CLI atual não honra o contrato de auto-invocação de skills, o que torna a execução imprevisível. Enquanto o issue #21968 estiver aberto, qualquer execução no Gemini CLI produzirá artefatos com nomes e estrutura dependentes do julgamento do modelo, não da especificação da ferramenta.

Isso **não invalida** o projeto do TCC — é evidência legítima de uma limitação de plataforma que a ferramenta precisa compensar (ver `../analise-cross-platform/recomendacoes-arquiteturais.md`).
