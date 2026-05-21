# Recomendações Arquiteturais para a Ferramenta-TCC

Baseado na execução 01 + análise de outros plugins. Ordenado por prioridade e facilidade de implementação.

---

## C1 — Chamada explícita de skills por nome no Gemini CLI (ALTA PRIORIDADE)

**Problema:** orquestrador confia em auto-invocação por description-matching (quebrado pelo issue #21968).

**Mudança proposta:** modificar `core/orchestrator.md` (seção de instrução para o Gemini CLI adapter) para listar explicitamente cada skill a ser chamada em cada passo:

```markdown
## Sequência M1 (modo Gemini CLI)
1. Use skill `vision-box` agora.
2. Use skill `situacao-problema` agora.
3. Use skill `stakeholder-mapping` agora.
4. Use skill `contexto-e-limite` agora.
5. Use skill `clarificacao-pos-visao` se 2+ categorias com lacunas críticas.
6. Use skill `traducao-leigo` para verificar jargão.
7. Use skill `traducao-gate` para gerar `visao-produto-leigo.md` + `visao-produto-normativo.md`.
8. Executar checagem C4.4: verificar que só existem os artefatos da tabela canônica de M1.
```

**Custo:** médio (editar `orchestrator.md` + adapters `.gemini/`). Sem mudança de arquitetura.

**Benefício:** elimina dependência de auto-invocação. Skills são chamadas deterministicamente.

---

## C2 — Fallback single-session para loops M2 e M3 no Gemini CLI (ALTA PRIORIDADE)

**Problema:** loops collector⇄modeler (M2) e documenter⇄checker (M3) dependem de sub-agentes com isolamento de contexto — instável no Gemini CLI.

**Mudança proposta:** se sub-agentes travam ou não isolam contexto, o orquestrador executa os blocos de cada agente sequencialmente na mesma sessão:

```markdown
## Loop M2 (modo Gemini CLI — fallback single-session)
### Bloco COLLECTOR — Ronda 1 (Entrevista)
[Adote persona collector. Use skill `entrevista-estruturada`. Produza perguntas. Espere respostas. Salve em `elicitacao-raw.md` seção "Ronda 1".]

### Bloco MODELER — após Ronda 1
[Adote persona modeler. Analise `elicitacao-raw.md`. Atualize `03.1-funcionais.md`.]

### Bloco COLLECTOR — Ronda 2 (Cenários)
...
```

Inspirado no padrão do obra/superpowers para Gemini CLI (ver `execucao-01-treinos-musculacao/comparativo-outros-plugins.md`).

**Custo:** médio. Requer adapter `.gemini/` com sequência explícita por ronda.

---

## C3 — Hooks de enforcement no porte Claude Code (ALTA PRIORIDADE, D11)

**Problema:** Gemini CLI não tem hooks; Claude Code tem. Quando D11 for implementado, usar hooks.

**Hooks a implementar:**

| Hook | Ação |
|---|---|
| `SessionStart` | Ler `estado-projeto.yaml`; injetar stub do orquestrador; exibir marco corrente |
| `PreToolUse` (Write) | Verificar se nome do arquivo a ser escrito está na tabela canônica do marco corrente; bloquear se não |
| `PostToolUse` (Write) | Incrementar contador de artefatos gerados no marco; atualizar `estado-projeto.yaml` |
| `Stop` | Verificar se todos os artefatos obrigatórios do marco foram produzidos; emitir alerta se não |

Modelo de implementação: `barkain/claude-code-workflow-orchestration` (PreToolUse com escalada silent→strong).

**Custo:** alto. Requer scripts shell + `settings.json` no adapter `.claude/`.

---

## C4 — Checagem fail-closed ao fechar gate (MÉDIA PRIORIDADE)

**Problema:** C4.4 atual verifica nomes proibidos mas não verifica **ausência** de obrigatórios.

**Mudança proposta:** adicionar C4.5 — ao fechar gate, a ferramenta executa:

```
C4.5: Lista todos os arquivos na pasta de saída do projeto.
      Para cada artefato obrigatório da tabela canônica do marco:
        Se não existe → registrar violação em `_pendencias.md` + bloquear gate.
      Se alguma violação registrada → não avançar, exibir lista ao usuário.
```

**Custo:** baixo. Adicionar seção em cada `core/marcos/m{N}.md` com checklist C4.5.

---

## C5 — Documentar modos de garantia no `constitution.md` (BAIXA PRIORIDADE)

**Problema:** usuário e TCC precisam de clareza sobre o que é garantido em cada plataforma.

**Mudança proposta:** adicionar seção ao `constitution.md`:

```markdown
## Modos de Garantia por Plataforma

| Garantia | Gemini CLI | Claude Code (D11) |
|---|---|---|
| Skills invocadas deterministicamente | ⚠ best-effort (C1+C2 aplicados) | ✓ |
| Loops M2/M3 iteram | ⚠ single-session fallback | ✓ |
| Nomes de artefatos validados externamente | ❌ | ✓ (hooks) |
| estado-projeto.yaml sempre consistente | ⚠ best-effort | ✓ (SessionStart hook) |

Enquanto issue google-gemini/gemini-cli#21968 estiver aberto, execuções no Gemini CLI devem 
ser tratadas como "best-effort" e validadas manualmente contra a tabela canônica ao final 
de cada marco.
```

**Custo:** baixo. Editar `constitution.md`.

---

## Priorização sugerida (sequencial)

1. **C4** (checagem fail-closed) — menor custo, maior impacto imediato. Pode ser feito hoje.
2. **C1** (chamada explícita de skills) — médio custo, resolve a causa-raiz no Gemini CLI.
3. **C2** (fallback single-session) — médio custo, torna loops confiáveis.
4. **C5** (documentação de modos) — baixo custo, melhora rastreabilidade do TCC.
5. **C3** (hooks Claude Code) — alto custo, só faz sentido quando D11 iniciar.

---

## Evidência que suporta estas recomendações

- [google-gemini/gemini-cli#21968](https://github.com/google-gemini/gemini-cli/issues/21968) — C1
- [google-gemini/gemini-cli#18064](https://github.com/google-gemini/gemini-cli/issues/18064) — C2
- [obra/superpowers#1045](https://github.com/obra/superpowers/issues/1045) — C2
- [barkain/claude-code-workflow-orchestration](https://github.com/barkain/claude-code-workflow-orchestration) — C3
- [Claude Code hooks guide](https://code.claude.com/docs/en/hooks-guide) — C3
- [Agent Skills | Gemini CLI docs](https://geminicli.com/docs/cli/skills/) — C1, C5
