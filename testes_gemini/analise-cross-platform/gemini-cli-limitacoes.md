# Limitações Conhecidas do Gemini CLI para Skills e Sub-Agentes

Consolidado de issues, docs e comportamento observado relevantes para a ferramenta-tcc.

---

## 1. Skills não são auto-invocadas (issue #21968)

**Issue:** [google-gemini/gemini-cli#21968](https://github.com/google-gemini/gemini-cli/issues/21968)
**Status:** aberto, prioridade p2, `kind/bug`

O Gemini CLI escaneia `~/.gemini/skills/` na inicialização e injeta nome + descrição de cada skill no system prompt. Quando uma tarefa faz match com uma descrição, o comportamento esperado é que o modelo proponha ativar a skill. Na prática:

- O modelo **não propõe** ativação mesmo com descrição altamente relevante.
- Só invoca a skill quando o usuário instrui explicitamente ("use a skill X").
- Comportamento inconsistente entre sessões e versões.

**Impacto na ferramenta-tcc:** as ~22 skills em `core/skills/` dependem de auto-ativação para o pipeline funcionar. Sem ela, o orquestrador executa sem as skills especializadas.

---

## 2. Sub-agentes travam na aprovação (issue #18064)

**Issue:** [google-gemini/gemini-cli#18064](https://github.com/google-gemini/gemini-cli/issues/18064)
**Status:** documentado

Agentes em `~/.gemini/agents/` (incluindo globais) podem travar indefinidamente em "Starting Agent Creation" / "Framing the Agent Call". O fluxo de aprovação para agentes globais não dispara corretamente.

**Impacto na ferramenta-tcc:** os 5 sub-agentes MARE-style (stakeholder-identifier, collector, modeler, documenter, checker) dependem de dispatch. Se o dispatch trava, o agente roda no contexto principal sem persona especializada.

---

## 3. Suporte a sub-agentes chegou tardio (v0.36+)

**Referência:** [obra/superpowers#1045](https://github.com/obra/superpowers/issues/1045) — "Enable Subagent support for Gemini CLI v0.36+"

Sub-agentes são funcionalidade experimental no Gemini CLI. Antes do v0.36, não existia suporte. Mesmo a partir do v0.36, comportamento em loops (collector⇄modeler, documenter⇄checker) não é garantido.

**Impacto:** CLAUDE.md documenta "persona adoption" como workaround para sub-agentes no Gemini CLI. Porém se nem a skill que implementa a persona é invocada, o workaround não resolve.

---

## 4. Modelo consent-based, sem hard enforcement

**Referência:** [Agent Skills | Gemini CLI docs](https://geminicli.com/docs/cli/skills/)

O design oficial é: Gemini propõe → usuário aprova → skill é priorizada "within reason". Não há:

- Hooks de ciclo de vida (PreToolUse, PostToolUse, SessionStart/Stop) como no Claude Code.
- Bloqueio programático de turno baseado em condição de artefato.
- Mecanismo de fail-closed em caso de skill não invocada.

**Implicação:** qualquer enforcement que a ferramenta-tcc implemente em skills (C4.4, C4.5, Z11) só roda **se a skill for invocada**. É enforcement self-referencial — não há camada externa.

---

## 5. Comparação de ciclo de vida skill: Gemini CLI vs. Claude Code

| Etapa | Gemini CLI | Claude Code |
|---|---|---|
| Discovery | Injeta nome+descrição no system prompt na inicialização | Skill é listada no system prompt |
| Ativação | Modelo propõe → usuário aprova (consent-based) | Modelo invoca `Skill` tool diretamente |
| Enforcement | "within reason" — soft | Hooks externos podem bloquear/redirecionar |
| Isolamento | Mesmo contexto da sessão | Mesmo contexto da sessão |
| Sub-agentes | Experimental (v0.36+), instável | `Agent` tool estável |
| Loops internos | Sem garantia de iteração | `Agent` pode ser chamado N vezes por código |

---

## 6. Checklist de verificação para próximas execuções

Antes de executar a ferramenta-tcc no Gemini CLI:

- [ ] Verificar versão: `gemini --version` deve ser ≥ 0.36
- [ ] Confirmar que as skills estão visíveis: na sessão, listar skills disponíveis
- [ ] Confirmar que o issue #21968 foi resolvido (verificar status do issue)
- [ ] Se issue ainda aberto: usar modo de chamada explícita (ver `recomendacoes-arquiteturais.md`)
- [ ] Ao final de cada marco, listar arquivos gerados e comparar com tabela canônica antes de aprovar o gate
