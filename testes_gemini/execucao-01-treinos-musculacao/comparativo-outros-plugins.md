# Comparativo: Como Outros Plugins Lidam com o Mesmo Problema

O problema central: **auto-invocação de skills/agentes não é garantida em LLMs**. Diferentes soluções de mercado adotam estratégias distintas para compensar.

---

## barkain/claude-code-workflow-orchestration

**Plataforma:** Claude Code exclusivamente
**Estratégia:** PreToolUse hooks com escalada adaptativa

Como funciona:
1. **Stub no SessionStart** — um stub leve (~1.1KB) do orquestrador é injetado em cada sessão. O orquestrador completo só é carregado na primeira vez que o agente delega uma tarefa. Net: sessões leves, sem penalidade de tokens quando o agente segue o workflow.
2. **Nudges escalonados** — quando o agente principal pula a delegação e resolve por conta própria, o hook PreToolUse emite:
   - Turno 1: silent
   - Turno 2: hint
   - Turno 3: warning
   - Turno 4+: strong reminder (não bloqueia, mas pressiona)
   - Reset: quando delegação roda, contador zera
3. **@-mention para delegação forçada** — usuário pode digitar `@agente-nome` para forçar delegação ao sub-agente específico, bypassando completamente o julgamento do modelo.

**Aplicável à ferramenta-tcc?**
- Sim, **no porte para Claude Code (D11)**. Hooks PreToolUse + PostToolUse permitiriam: (a) verificar sequência de skills por marco, (b) checar nomes de artefatos antes de fechar gate, (c) bloquear gate se artefatos obrigatórios ausentes.
- Inviável no Gemini CLI — hooks não existem nessa plataforma.

---

## obra/superpowers

**Plataforma:** multi-plataforma (Claude Code + Gemini CLI + outros)
**Estratégia:** fallbacks explícitos por plataforma

Quando uma skill como `dispatching-parallel-agents` ou `subagent-driven-development` é invocada no Gemini CLI, a própria skill detecta a plataforma e degrada graciosamente:
- No Gemini CLI: fallback para `executing-plans` — execução single-session, sem sub-agentes, ordem sequencial manual.
- No Claude Code: execução plena com Agent tool.

A limitação do Gemini CLI v0.36+ é reconhecida explicitamente na issue [superpowers#1045](https://github.com/obra/superpowers/issues/1045): sub-agentes chegaram ao Gemini CLI v0.36+, mas com comportamento ainda não-estável.

**Aplicável à ferramenta-tcc?**
- Sim — o `orchestrator.md` pode incluir seção "modo Gemini CLI" que instrui execução sequencial explícita de cada skill por nome, em vez de depender de auto-invocação.
- Padrão: chamar `Use skill X` explicitamente em cada passo, não "use a skill mais relevante".

---

## wshobson/agents

**Plataforma:** Claude Code
**Estratégia:** @-mention para delegação obrigatória

Cada agente especializado é invocado via `@nome-do-agente` diretamente no prompt do usuário ou em instruções internas. O modelo não decide — a delegação é determinística.

**Aplicável à ferramenta-tcc?**
- Parcialmente no Claude Code (D11). No Gemini CLI, sem equivalente.
- Para M2/M3, onde há loops internos, @-mention no orquestrador poderia forçar o modelo a honrar cada iteração.

---

## vinicius91carvalho/.claude (Workflow System)

**Plataforma:** Claude Code
**Estratégia:** enforcement como cidadão de primeira classe

Combina hooks + agents + skills com enforcement nativo (via `settings.json` e hooks de ciclo de vida). O enforcement não é responsabilidade do modelo — é responsabilidade da infraestrutura de hooks.

**Aplicável à ferramenta-tcc?**
- Exclusivo ao Claude Code. Reforça que **enforcement robusto requer hooks** — não pode ser feito em prompts Markdown executados pelo Gemini CLI.

---

## Documentação oficial do Gemini CLI (Agent Skills)

**Fonte:** [Agent Skills | Gemini CLI docs](https://geminicli.com/docs/cli/skills/)

Modelo oficial: consent-based activation. Quando o Gemini identifica uma tarefa que match uma skill, propõe a ativação — o usuário precisa aprovar via prompt UI. A skill é priorizada "within reason" após aprovação.

**Implicação direta:** "within reason" significa que mesmo após aprovação, o modelo pode não seguir a skill se a conversa derivar. Não há hard enforcement.

---

## Padrão emergente

Todos os sistemas robustos assumem o mesmo princípio:

> **Auto-invocação não-determinística é inerente a LLMs. Sistemas que dependem de auto-invocação para correção funcional falharão em produção.**

Estratégias de compensação, por ordem de robustez:

| Estratégia | Determinismo | Disponível no Gemini CLI | Disponível no Claude Code |
|---|---|---|---|
| Hooks PreToolUse/PostToolUse | Alto | ❌ | ✓ |
| @-mention / delegação explícita | Alto | ❌ (sem equivalente) | ✓ |
| Chamada explícita por nome (`Use skill X`) | Médio | ✓ (workaround) | ✓ |
| Fallback single-session explícito | Médio | ✓ | ✓ |
| Description-matching automático | Baixo | ✓ (buggy, issue #21968) | ✓ (mais confiável) |

**Conclusão para a ferramenta-tcc:** enquanto o porte para Claude Code (D11) não estiver completo, a versão Gemini CLI precisa adotar a estratégia "chamada explícita por nome" para ser minimamente confiável. Description-matching como único mecanismo de invocação não é suficiente.
