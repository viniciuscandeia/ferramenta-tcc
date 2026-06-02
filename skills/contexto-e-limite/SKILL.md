---
name: contexto-e-limite
marco: [M1]
description: >-
  Define o que está fora do produto e as restrições conhecidas — a fronteira do sistema.
  O que está dentro é INFERIDO das skills anteriores e confirmado, não re-perguntado.
  Use após mapear pessoas, para fechar o contexto do Marco 1.
  Define system context and boundaries for a layperson stakeholder; emphasizes out-of-scope and restrictions.
---

## Filosofia desta skill (Regras Absolutas)

1. **Dentro = inferido + confirmado; Fora = perguntado.** O que o produto faz já foi descrito em `necessidade-visao` e `stakeholder-mapping`. Esta skill NÃO re-pergunta isso. Ela confirma rapidamente o que está dentro (inferido) e sonda o que está FORA — que é onde o valor real está para evitar scope creep.
2. **"Fora do projeto" é tão importante quanto "dentro".** Pelo menos 1 exclusão explícita é obrigatória. Se o usuário não sugerir nenhuma, o agente oferece candidatos baseados no domínio.
3. **Restrição sem tipo = não é restrição.** Se o usuário diz "tem algumas limitações", sondar: prazo, orçamento, tecnologia ou legal. Genérico não vai para o artefato.
4. **Lacunas persistidas em estado, não perdidas no contexto.** O relatório de lacunas (D16) é salvo em `estado-projeto.yaml` para sobreviver a sessões desconectadas.

<HARD-GATE>
- NÃO executar antes de `stakeholder-mapping` concluído (verificar que `## 4. Pessoas Envolvidas` existe em `documentos-tecnicos/01-visao/01-visao-produto.md`)
- ⛔ STOP se "dentro" e "fora" forem semanticamente idênticos (usuário não entendeu a distinção) — re-explicar com exemplo concreto antes de continuar
</HARD-GATE>

## Fase 0 — Inicialização e Pré-Inferência

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## 4. Pessoas Envolvidas` existe
3. **Pré-inferência do dentro:** ler seções `## 2. Problema & Necessidade` e `## 1. Visão` → extrair atividades e capacidades mencionadas pelo usuário → montar lista provisória de "O que o produto faz"
4. Extrair integrações já mencionadas (sistemas, dispositivos, serviços citados) → lista provisória

## Fase 1 — Coleta (1 `AskUserQuestion`, 3 perguntas)

**Lote único (≤ 3 perguntas — enxuto porque "dentro" já é inferido):**

1. **O que o produto NÃO vai fazer** (text — obrigatória):
   ```
   O que o produto definitivamente NÃO vai fazer? Mesmo que as pessoas esperem — o que está fora?
   ```
   *(Se o usuário travar: oferecer candidatos baseados no domínio via `multi-choice` com `multiSelect: true` — ex: para estoque → "financeiro/caixa", "contabilidade", "RH". O usuário pode excluir mais de um ao mesmo tempo. Candidatos vêm do catálogo de domínio ou são inferidos.)*

2. **Integrações externas** (text — só se lista provisória da Fase 0 estiver vazia):
   ```
   O produto precisa se conectar com outros sistemas ou serviços que você já usa? (ex: pagamento, e-mail, WhatsApp, sistema financeiro)
   ```
   *(Se integrações já foram mencionadas antes: omitir esta pergunta e usar a lista provisória.)*

3. **Restrições conhecidas** (text):
   *(Consultar `{PLUGIN_ROOT}/content/catalogos-seed/restricoes-tipicas.md` para identificar restrições típicas do domínio e incluir exemplos relevantes na pergunta abaixo.)*
   ```
   Existe alguma restrição importante? (ex: prazo, orçamento, tecnologia específica que deve ser usada, regras que o produto precisa respeitar)
   ```

## Fase 2 — Síntese e Confirmação do "Dentro"

Apresentar lista provisória de "O que está no projeto" (inferida) para confirmação rápida — **1 `AskUserQuestion`, choice**:

```
Pelo que conversamos, o produto vai:
[bullet list inferida]

Está certo? Tem algo que ficou de fora ou que deveria ser diferente?
```

Opções: `"Está correto"` / `"Tem algo para ajustar"` / `"Quero adicionar uma coisa"`

- Se "Está correto" → Fase 3 (síntese final)
- Se ajuste: coletar texto, atualizar a lista, sem nova rodada

## Fase 3 — Síntese Final

Gerar seção de contexto e limites:

```markdown
## 5. Contexto e Limites

### O que o produto faz

[Bullet list confirmada — da pré-inferência + ajustes da Fase 2]

### O que o produto NÃO faz

[Bullet list — exclusões explícitas da resposta 1]

### Integrações previstas

[Bullet list de sistemas externos]
[Se nenhuma: "Nenhuma integração identificada nesta fase."]

### Restrições

| Tipo | Descrição |
|---|---|
| [Prazo / Orçamento / Técnica / Legal / Organizacional] | [Detalhe] |

[Se nenhuma: "Nenhuma restrição identificada nesta fase."]
```

**Regras de síntese:**
- "O que está no projeto" deve ser consistente com a Seção 2 (Problema) — divergência = flag de lacuna
- Integrações mencionadas: registrar como "a detalhar em fase seguinte"
- Restrições vagas → marcar como `[a detalhar]`
- Verificar consistência com restrições regulatórias da Seção 4 (Pessoas Envolvidas, Camada Regula) — se Regula presente → deve haver ao menos 1 restrição do tipo Legal
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

## Fase 4 — Detecção e Persistência de Lacunas (para `clarificacao-pos-visao` — D16)

Verificar 3 categorias críticas:

| Categoria | Lacuna crítica se | Severidade |
|---|---|---|
| Escopo funcional | "O que está no projeto" tem < 3 itens OU contradiz Seção 2 (Problema) | Alta |
| Restrições de negócio | Domínio regulado (Fase 0 de `stakeholder-mapping`) E nenhuma restrição Legal identificada | Alta |
| Itens em aberto críticos | Decisor `[a identificar]` OU metas de sucesso `[a definir]` em Seção 3 | Média |

**Persistir em `estado-projeto.yaml`:**
```yaml
lacunas_m1:
  categorias: [escopo_funcional, restricoes_negocio, itens_aberto]  # só as que têm lacuna
  contagem: N
```

`stakeholder-identifier` lê `estado-projeto.yaml` para decidir se ativa `clarificacao-pos-visao` (D16: só se `contagem ≥ 2`). Isso garante que a decisão sobrevive a sessões desconectadas.

## Fase 5 — Saída

1. Append seção `## 5. Contexto e Limites` em `documentos-tecnicos/01-visao/01-visao-produto.md`
2. Persistir `lacunas_m1` em `estado-projeto.yaml` (ver Fase 4)
3. Sinalizar conclusão → `stakeholder-identifier` avalia `lacunas_m1.contagem` → prosseguir para `clarificacao-pos-visao` (se ≥ 2) ou `traducao-gate` (se < 2)

<!-- internal -->
## Anti-Padrão: Re-Perguntar "O Que O Produto Faz"

**Como acontece:** A skill pergunta "O que o produto vai fazer?" mesmo que `necessidade-visao` já tenha capturado a solução e as funcionalidades centrais. Resulta em 3ª pergunta sobre o mesmo território — dentro/fora repetido 3 vezes entre as skills.

**Como detectar:** Se `## 1. Visão` e `## 2. Problema & Necessidade` estão preenchidos e mencionam atividades do produto → a lista de "dentro" JÁ EXISTE. Pré-inferir e confirmar em choice, nunca re-perguntar aberto.

**O que fazer:** Fase 0 é obrigatória. Se a pré-inferência retornar < 2 itens, aí sim perguntar abertamente. Mas isso é exceção (para inputs muito vagos já cobertos por `clarificacao-pos-visao`).

---

## Anti-Padrão: Lacunas Perdidas ao Desconectar

**Como acontece:** `contexto-e-limite` detecta 2 lacunas críticas mas as retorna apenas em contexto efêmero (em memória). Se a sessão é interrompida antes de `clarificacao-pos-visao`, a contagem é perdida e o gate pode abrir sem clarificação.

**Como detectar:** `estado-projeto.yaml` sem campo `lacunas_m1` após `contexto-e-limite` executar.

**O que fazer:** Fase 4 persiste `lacunas_m1` em disco — obrigatório. `stakeholder-identifier` e `clarificacao-pos-visao` leem do estado, nunca dependem de contexto efêmero.
<!-- /internal -->
