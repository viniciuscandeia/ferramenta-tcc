---
name: clarificacao-pos-visao
marco: [M1]
description: >-
  Resolve lacunas críticas detectadas no Marco 1 antes de avançar — ativa apenas se o produto ainda tiver pontos ambíguos em pelo menos duas áreas.
  Use após contexto-e-limite, somente se houver lacunas críticas em ≥ 2 categorias (escopo, terminologia, restrições).
  Conditional clarification pass for layperson stakeholder; resolves critical gaps with ≤ 3 targeted questions.
---

## Filosofia desta skill (Regras Absolutas)

1. **Condicional rigorosa — padrão é NÃO executar.** Se `contexto-e-limite` reportou < 2 categorias com lacuna, esta skill é invisível. Ativar por precaução gasta turnos do usuário sem retorno.
2. **Uma chamada. Três perguntas. Fim.** Sem segunda rodada, sem perguntas abertas (`text`). Apenas `choice` ou `yesno` — opções fechadas reduzem carga cognitiva e produzem respostas acionáveis.
3. **Foco nas piores lacunas, não em todas.** Com 3 lacunas e 3 perguntas disponíveis, priorizar na ordem: Escopo > Restrição > Terminologia.

<HARD-GATE>
- NÃO executar se `contexto-e-limite` reportou < 2 categorias com lacuna (D16)
- NÃO executar se `contexto-e-limite` não foi executado (verificar `## Contexto e Limites do Projeto` existe em `visao-produto.md`)
- ⛔ STOP e registrar erro se houver tentativa de segunda chamada `AskUserQuestion` nesta skill — uma chamada é o limite absoluto
</HARD-GATE>

## Fase 0 — Inicialização e Verificação

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Receber relatório de lacunas do `stakeholder-identifier` (saído de `contexto-e-limite` Fase 3)
3. Verificar condição D16: se `contagem_lacunas < 2`, retornar ao `stakeholder-identifier` sem executar

## Fase 1 — Seleção e Coleta

Selecionar exatamente 3 perguntas (ou menos se < 3 lacunas), priorizando na ordem Escopo → Restrição → Terminologia.

**Modelos de pergunta por categoria:**

**Escopo funcional** (`choice`):
```
Você mencionou [funcionalidade X]. Isso inclui:
(A) Apenas [interpretação mais simples]
(B) Também [interpretação mais completa]
(C) Algo diferente — vou explicar melhor quando chegarmos nos detalhes
```

**Restrições de negócio** (`choice`):
```
Você mencionou [restrição]. Isso significa que:
(A) O produto precisa estar pronto até [data inferida]
(B) Existe um orçamento máximo de [valor inferido]
(C) Há uma regra legal específica que não mencionou ainda
```

**Terminologia do domínio** (`yesno`):
```
Quando você diz "[termo usado pelo usuário]", você quer dizer [interpretação inferida]?
```

**Regra de seleção:** adaptar o template ao conteúdo real do projeto — nunca usar o modelo genérico literal. Preencher `[X]`, `[data inferida]` etc. com o que foi dito pelo usuário.

## Fase 2 — Incorporação

Após a única chamada `AskUserQuestion`:

1. **Escopo** → atualizar "O que está no projeto" em `visao-produto.md`
2. **Terminologia** → adicionar à seção "Glossário inicial" (criar se necessário)
3. **Restrições** → atualizar tabela "Restrições"
4. Aplicar `traducao-leigo` sobre qualquer texto novo adicionado (D1)

## Fase 3 — Saída

1. `visao-produto.md` atualizado com lacunas resolvidas (esta skill não cria arquivo novo)
2. Sinalizar ao `stakeholder-identifier`: clarificação concluída → prosseguir para `traducao-gate`

<!-- internal -->
## Anti-Padrão: Ativação por Precaução

**Como acontece:** O `stakeholder-identifier` ativa esta skill com apenas 1 lacuna detectada porque "é melhor prevenir". Resulta em 3 perguntas extras que o usuário responde sem entender o propósito, desgastando a sessão antes mesmo de M2.

**Como detectar:** Verificar `contagem_lacunas` do relatório de `contexto-e-limite`. Se < 2, rejeitar a ativação — não há margem de interpretação aqui (D16 é explícito).

**O que fazer:** Retornar ao `stakeholder-identifier` com `skill_skipped: true, motivo: "D16 — lacunas < 2"`. Prosseguir diretamente para `traducao-gate`.
<!-- /internal -->
