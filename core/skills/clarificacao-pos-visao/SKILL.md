---
name: clarificacao-pos-visao
marco: [M1]
description: >-
  Resolve lacunas críticas detectadas no Marco 1 antes de avançar — ativa apenas se o produto ainda tiver pontos ambíguos em pelo menos duas categorias.
  Use após contexto-e-limite, somente se `estado-projeto.yaml` tiver `lacunas_m1.contagem ≥ 2` (D16).
  Conditional clarification pass for layperson stakeholder; resolves critical gaps with ≤ 3 targeted questions.
---

## Filosofia desta skill (Regras Absolutas)

1. **Condicional rigorosa — padrão é NÃO executar.** Se `lacunas_m1.contagem < 2` no estado, esta skill é invisível. Ativar por precaução gasta turnos do usuário sem retorno (D16).
2. **Uma chamada. Três perguntas. Fim.** Sem segunda rodada, sem perguntas abertas (`text`). Apenas `choice` ou `yesno` — opções fechadas reduzem carga cognitiva e produzem respostas acionáveis.
3. **Foco nas piores lacunas.** Com 3 lacunas e 3 perguntas disponíveis, priorizar: Escopo > Restrições > Itens em aberto.
4. **Ler estado, não memória.** A condição de ativação e as categorias de lacuna são lidas de `estado-projeto.yaml` (`lacunas_m1`). Nunca depender de contexto efêmero — isso garante funcionamento após sessão desconectada.

<HARD-GATE>
- NÃO executar se `estado-projeto.yaml` NÃO tem `lacunas_m1.contagem ≥ 2` (D16)
- NÃO executar se `## 5. Contexto e Limites` não existe (indica que `contexto-e-limite` não rodou)
- ⛔ STOP e registrar erro se houver tentativa de segunda chamada `AskUserQuestion` nesta skill — uma chamada é o limite absoluto
- Esta skill NÃO tem guarda de idempotência para re-elicitação de seções individuais — ela atualiza seções existentes inline (necessário para o loop Gate-1 "Não")
</HARD-GATE>

## Fase 0 — Inicialização e Verificação

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Ler `estado-projeto.yaml` → `lacunas_m1.categorias` e `lacunas_m1.contagem`
3. Se `contagem < 2` → retornar ao `stakeholder-identifier` com `skill_skipped: true, motivo: "D16 — lacunas_m1.contagem < 2"`. Prosseguir para `traducao-gate`.
4. Selecionar as lacunas a resolver (prioridade: `escopo_funcional` > `restricoes_negocio` > `itens_aberto`)

## Fase 1 — Seleção e Coleta (1 `AskUserQuestion`, ≤ 3 perguntas)

Selecionar exatamente as perguntas correspondentes às categorias com lacuna (máx 3), usando os modelos abaixo com os dados reais do projeto.

**Modelo: Escopo funcional** (`choice`, 3 opções):
```
Você mencionou [atividade X inferida]. Isso inclui:
(A) Apenas [interpretação mais simples, ex: só visualizar]
(B) Também [interpretação mais completa, ex: editar e deletar]
(C) Algo diferente — eu explico melhor na próxima conversa
```
*Preencher `[atividade X]`, `[mais simples]` e `[mais completa]` com o conteúdo REAL da Seção 2 e Seção 5 do artefato. Nunca usar o modelo literal.*

Exemplo concreto (domínio: estoque):
```
Você mencionou controlar estoque de produtos. Isso inclui:
(A) Apenas ver quanto tem em estoque (consulta)
(B) Também registrar entradas, saídas e alertas de mínimo
(C) Algo diferente — vou explicar melhor quando chegarmos nos detalhes
```

**Modelo: Restrições de negócio** (`choice`, 3 opções):
```
Você está num setor que tem regras específicas (ex: [domínio detectado]). O produto precisa:
(A) Seguir regras de proteção de dados (como a LGPD) — isso vai exigir cuidado com informações pessoais
(B) Seguir normas do [órgão regulador do domínio] — ex: [norma específica]
(C) Não tenho certeza ainda — vou verificar com quem sabe
```
*Preencher `[domínio]` e `[órgão regulador]` com o que foi inferido pelo `stakeholder-mapping` Fase 0.*

Exemplo concreto (domínio: saúde):
```
Você está na área de saúde. O produto precisa:
(A) Seguir a LGPD (proteção de dados dos pacientes)
(B) Seguir normas do CFM (Conselho Federal de Medicina) para registro de atendimentos
(C) Não tenho certeza ainda — vou verificar antes de decidir
```

**Modelo: Itens em aberto críticos** (`yesno` ou `choice`):

Para decisor `[a identificar]`:
```
Você mencionou que quem aprova ou paga pelo produto ainda não está definido. Você tem ideia de quem seria essa pessoa ou cargo? (pode ser informal)
```
*(1 pergunta `text` — exceção ao formato fechado, pois a resposta é um nome/cargo)*

Para metas `[a definir]`:
```
Quando o produto estiver pronto, como você vai saber que valeu a pena? Qual seria um sinal claro de sucesso?
```
*(1 pergunta `text`)*

## Fase 2 — Incorporação

Após a única chamada `AskUserQuestion`:

1. **Escopo** → atualizar `### O que o produto faz` e `### O que o produto NÃO faz` em `## 5. Contexto e Limites`
2. **Restrições** → atualizar tabela `### Restrições` em `## 5. Contexto e Limites`
3. **Decisor** → atualizar linha correspondente em `## 4. Pessoas Envolvidas` (remover `[a identificar]` se respondido)
4. **Metas** → atualizar `## 3. Objetivos e Metas de Sucesso` (remover `[a definir]` se respondido)
5. Atualizar `estado-projeto.yaml`: `lacunas_m1.contagem: 0` (ou remover categorias resolvidas)
6. Aplicar `traducao-leigo` sobre qualquer texto novo adicionado (D1)

## Fase 3 — Saída

1. `documentos-tecnicos/01-visao/01-visao-produto.md` atualizado com lacunas resolvidas inline (esta skill NÃO cria arquivo novo)
2. Sinalizar ao `stakeholder-identifier`: clarificação concluída → prosseguir para `traducao-gate`

<!-- internal -->
## Anti-Padrão: Ativação por Precaução

**Como acontece:** `stakeholder-identifier` ativa esta skill com `lacunas_m1.contagem = 1` porque "é melhor prevenir". Resulta em 3 perguntas extras que o usuário responde sem entender o propósito, desgastando a sessão antes mesmo de M2.

**Como detectar:** `estado-projeto.yaml` tem `lacunas_m1.contagem: 1`. Se < 2, rejeitar ativação.

**O que fazer:** Retornar ao `stakeholder-identifier` com `skill_skipped: true, motivo: "D16 — lacunas < 2"`. Prosseguir para `traducao-gate`.

---

## Anti-Padrão: Usar Modelos Genéricos Literais

**Como acontece:** O agente apresenta ao usuário a pergunta template com `[atividade X]` e `[interpretação mais simples]` literais — sem preencher com dados do projeto. O usuário não entende o que está sendo perguntado.

**Como detectar:** Qualquer `[` ou `]` na mensagem exibida ao usuário.

**O que fazer:** SEMPRE preencher todos os `[placeholders]` com conteúdo real extraído do artefato antes de apresentar ao usuário. Se não for possível inferir o conteúdo (dados insuficientes), omitir aquela pergunta e usar outra lacuna disponível.

---

## Anti-Padrão: Guard de Idempotência Bloqueia Re-Elicitação

**Contexto:** No loop Gate-1 "Não", o orquestrador pode precisar re-invocar esta skill para resolver pontos que o usuário rejeitou. As skills `necessidade-visao`, `stakeholder-mapping` e `contexto-e-limite` têm guarda de idempotência (não executam se seção já existe). Esta skill NÃO tem — ela atualiza seções existentes inline.

**Comportamento esperado:** Se chamada novamente com feedback do Gate-1 "Não", esta skill resolve os pontos específicos do feedback (ex: canal errado → atualizar Seção 1 e Seção 5) sem re-executar o fluxo completo.
<!-- /internal -->
