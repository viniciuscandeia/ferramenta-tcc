---
name: priorizacao
marco: [M2]
description: >-
  Atribui nível de importância e obrigatoriedade a cada funcionalidade e comportamento levantado — define o que vem primeiro, o que vem depois e o que fica de fora desta versão.
  Use após classificar os itens do Marco 2, antes de verificar conflitos.
  Assign RFC 2119 modals and MoSCoW priority to classified RF/RNF items; triggers Kano and IEEE sub-routines automatically per D9.
---

## Filosofia desta skill (Regras Absolutas)

1. **MoSCoW sempre, sem exceção.** Não existe item sem prioridade. "Não sei" do usuário = `DEVERIA_TER` por padrão conservador + flag para revisão.
2. **Kano e IEEE são sub-rotinas automáticas, não opcionais.** Os gatilhos de D9 são verificados a cada execução — se atendidos, as sub-rotinas rodam. Pular = violação de D9.
3. **Nunca perguntar ao usuário sobre prioridade diretamente.** O usuário não conhece MoSCoW, Kano nem IEEE. A prioridade é inferida do contexto de negócio e das restrições declaradas.

<HARD-GATE>
- NÃO executar antes de `classificacao-rf-rnf` concluída (verificar que `03.1-funcionais.md` e `03.2-qualidade.md` existem com itens)
- ⛔ STOP se `03.1-funcionais.md` contém 0 itens — retornar ao modeler com erro de pré-condição
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `03.1-funcionais.md` e `03.2-qualidade.md` existem e têm itens
3. Acessar `03.3-restricoes.md` e `visao-produto-normativo.md` para âncoras de prioridade

## Fase 1 — MoSCoW (sempre executar)

**Mapeamento de saída:**

| Valor interno | Apresentado ao usuário | Modal RFC 2119 |
|---|---|---|
| `DEVE_TER` | "vem primeiro / é essencial" | `DEVE` |
| `DEVERIA_TER` | "vem logo depois / importante mas não crítico" | `DEVERIA` |
| `PODERIA_TER` | "fica para depois / bom ter se der" | `PODE` |
| `NAO_TERA` | "fica fora desta versão" | (sem modal) |

**Critérios MoSCoW por item:**
- **DEVE_TER:** sem este item o produto falha ou viola restrição legal. "Se removermos, o produto não funciona ou é ilegal?"
- **DEVERIA_TER:** importante com alternativa temporária. "O produto funciona com limitação aceitável?"
- **PODERIA_TER:** desejável, postergável sem impacto mínimo. "Funciona normalmente sem este item?"
- **NAO_TERA:** explicitamente fora do escopo desta versão

**Âncoras de consistência:**
- Restrição legal em `03.3-restricoes.md` → RFs que implementam = `DEVE_TER`
- Funcionalidades-chave de `visao-produto-normativo.md` → geralmente `DEVE_TER`
- Itens vindos apenas de catálogo (`recomendacao-implicitos`) → geralmente `PODERIA_TER`

## Fase 2 — Sub-Rotina Kano (condicional — D9)

**Gatilho:** ativar automaticamente se RFs com `DEVERIA_TER` + `PODERIA_TER` ≥ 8 E stakeholders distintos ≥ 2.

Para cada item `DEVERIA_TER`/`PODERIA_TER`:

| Pergunta interna | Categoria Kano | Ação |
|---|---|---|
| "Se ausente, usuário reclama ativamente?" → SIM | Obrigatório (must-be) | Promover para `DEVE_TER` |
| "Surpreende positivamente quando presente?" → SIM | Encantador (attractive) | Reclassificar para `PODERIA_TER` |
| Nenhum dos dois | Proporcional (one-dimensional) | Manter posição atual |

## Fase 3 — Sub-Rotina IEEE (condicional — D9)

**Gatilho:** ativar automaticamente se total RF + RNF ≥ 25 E `03.3-restricoes.md` tem restrição de prazo fixo.

Ordenar `DEVE_TER` em sequência de implementação:

| Critério | Peso | Resultado |
|---|---|---|
| Estabilidade (improvável de mudar) | Alta → primeiro | campo `ordem_impl: N` |
| Dependências (outros RFs dependem deste?) | Muitas → primeiro | |
| Risco (incerto de implementar?) | Alto risco → primeiro (fail fast) | |

## Fase 4 — Saída

Atualizar `03.1-funcionais.md` e `03.2-qualidade.md` com campos preenchidos:

```markdown
| ID | Descrição | Modal | MoSCoW | Kano | ordem_impl | Fonte |
|---|---|---|---|---|---|---|
| RF-001 | O sistema DEVE permitir cadastro de produto com nome, preço e foto | DEVE | DEVE_TER | — | 1 | cenario-narrativa §2 |
| RF-002 | O sistema DEVERIA enviar confirmação por e-mail após pedido | DEVERIA | DEVERIA_TER | Proporcional | — | recomendacao-implicitos |
| RF-003 | O sistema PODE exibir sugestões de produtos relacionados | PODE | PODERIA_TER | Encantador | — | recomendacao-dominio |
```

Itens `NAO_TERA` → seção "Fora do escopo desta versão" ao final de `03.1-funcionais.md`.

Criar pauta para `pautas-reelicitacao` (Passo 5) se: RNF `DEVE_TER` sem métrica OU RF `DEVE` sem critério de aceitação claro.

Sinalizar ao `modeler`: priorizacao concluída → prosseguir para `glossario` (Passo 3).

<!-- internal -->
## Anti-Padrão: Modal Inferido Sem Verificar Gatilhos Kano

**Como acontece:** `DEVERIA_TER` é atribuído a 10 itens sem ativar Kano (gatilho: ≥ 8 itens e ≥ 2 stakeholders). Resultado: 3 itens que seriam "Obrigatório" (Kano) ficam como `DEVERIA` — potencial retrabalho no Gate 2 quando o usuário percebe que algo essencial foi marcado como secundário.

**Como detectar:** Antes de finalizar Fase 1, contar `DEVERIA_TER` + `PODERIA_TER` e stakeholders. Se gatilho atendido e Kano não executou → executar agora.

**O que fazer:** Verificar gatilho explicitamente no início da Fase 2. Não assumir que "8 itens ou mais é raro" — em projetos médios com catálogo, essa contagem é a norma.
<!-- /internal -->
