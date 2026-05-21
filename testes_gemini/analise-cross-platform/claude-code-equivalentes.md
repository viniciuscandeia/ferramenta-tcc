# Claude Code: Estratégias que Mitigam as Fraquezas do Gemini CLI

Referência para o porte D11 da ferramenta-tcc para Claude Code.

---

## 1. Hooks de ciclo de vida — enforcement externo

**Documentação:** [Claude Code hooks guide](https://code.claude.com/docs/en/hooks-guide)

Claude Code tem 12 eventos de hook que permitem executar scripts shell em momentos específicos do ciclo de vida do agente. Relevantes para a ferramenta-tcc:

| Hook | Quando dispara | Uso para a ferramenta-tcc |
|---|---|---|
| `PreToolUse` | Antes de qualquer tool call | Verificar se skill obrigatória foi invocada no turno; emitir nudge se não |
| `PostToolUse` | Após qualquer tool call | Verificar se artefato esperado foi criado após Write |
| `Stop` | Quando agente vai encerrar | Checar se artefatos do marco estão completos antes de encerrar |
| `SessionStart` | Início de sessão | Injetar contexto do `estado-projeto.yaml`; carregar stub do orquestrador |

**Padrão de enforcement PreToolUse** (de barkain/claude-code-workflow-orchestration):

```bash
# hooks/pre-tool-use.sh — exemplo conceitual
# Conta turnos sem delegação; emite nudges escalonados
COUNTER_FILE=".claude/enforcement-counter"
current=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
current=$((current + 1))
echo "$current" > "$COUNTER_FILE"

if [ "$current" -ge 4 ]; then
  echo "STRONG REMINDER: Você deve invocar a skill adequada para este marco. Não avance sem produzir os artefatos canônicos." >&2
elif [ "$current" -ge 3 ]; then
  echo "WARNING: Skill não invocada neste turno." >&2
fi
```

Diferencial em relação ao Gemini CLI: o hook roda **fora** do modelo, independente de a skill ter sido invocada. É camada de enforcement externo.

---

## 2. `Agent` tool — sub-agentes estáveis

**Documentação:** [Sub-agents | Claude Code docs](https://code.claude.com/docs/en/sub-agents)

No Claude Code, sub-agentes são chamados via `Agent` tool de forma programática — não dependem de aprovação do usuário nem de julgamento do modelo quanto ao momento certo. O orquestrador pode chamar `Agent(file=core/agents/collector.md)` explicitamente em cada turno do loop M2.

Isso resolve diretamente o problema do issue #18064 (travamento no Gemini CLI).

---

## 3. `Skill` tool — invocação determinística

No Claude Code, skills são invocadas via `Skill` tool. O sistema `using-superpowers` instrui o modelo a invocar `Skill` antes de qualquer resposta quando houver 1% de chance de uma skill ser relevante. Com essa instrução no `CLAUDE.md`, a auto-invocação passa de "consent-based best-effort" para "obrigatória por instrução de sistema".

**Diferença prática:** no Gemini CLI, a skill pode não ser invocada mesmo com description match. No Claude Code com `using-superpowers`, a skill é invocada porque o modelo é instruído a chamar `Skill` como regra absoluta — não é description-matching, é imperativo de sistema.

---

## 4. @-mention — delegação forçada

No Claude Code, o usuário pode digitar `@nome-do-agente` para forçar delegação ao agente específico, bypassando o julgamento do modelo. Exemplo: `@collector faça a 2ª ronda de elicitação`. Determinístico.

Sem equivalente no Gemini CLI.

---

## 5. Resumo: o que o porte D11 ganha

| Problema no Gemini CLI | Solução no Claude Code (D11) |
|---|---|
| Skills não auto-invocadas (#21968) | Hooks PreToolUse + instrução `using-superpowers` (obrigatório) |
| Sub-agentes instáveis (#18064) | `Agent` tool estável; sem aprovação manual |
| Sem enforcement externo | Hooks Stop + PostToolUse verificam artefatos |
| Loops M2/M3 não iterando | `Agent` pode ser chamado em loop pelo orquestrador |
| Nomes fora do canônico | PostToolUse hook verifica nome antes de confirmar Write |
| `estado-projeto.yaml` inconsistente | SessionStart hook lê YAML e injeta estado atual |

---

## 6. Adaptações necessárias no porte

Para que o porte D11 herde as garantias acima, a ferramenta-tcc precisa:

1. Criar `ferramenta-tcc/.claude/settings.json` com hooks configurados.
2. Criar scripts de hook em `ferramenta-tcc/.claude/hooks/` (enforcement + verificação de artefatos).
3. Atualizar `core/orchestrator.md` para usar `Agent` tool (não "persona adoption") nos sub-agentes.
4. Manter `core/` com lógica canônica — adapters `.claude/` e `.gemini/` são thin wrappers.

Referência de implementação: [vinicius91carvalho/.claude](https://github.com/vinicius91carvalho/.claude) (sistema de workflow do autor) + [barkain/claude-code-workflow-orchestration](https://github.com/barkain/claude-code-workflow-orchestration).
