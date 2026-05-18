---
name: pautas-reelicitacao
description: Identifica lacunas nos artefatos M2 que impedem avanço para Gate 2 e gera pautas-reelicitacao.md com checkboxes e skill-alvo para resolução. Arquivo vazio = Gate 2 pode abrir. Referência: Livro SON cap. 8 Fig. 8.3.
when_to_use: Invocada pelo modeler no Passo 5 da Fase B. Determina se o loop collector⇄modeler deve continuar. Sem interação com usuário.
---

# Skill: pautas-reelicitacao

**Referência:** Livro SON cap. 8 Fig. 8.3 (critérios de completude de elicitação)
**Marco:** M2 — Consenso de Escopo (Fase B, Passo 5)
**Invocada por:** `modeler`

---

## OBJETIVO

Ser o **critério de parada do loop M2**. Se esta skill produz `pautas-reelicitacao.md` vazio (ou sem itens `[ ]`), o Gate 2 pode abrir. Se produz ≥ 1 item `[ ]`, o loop retorna ao `collector` em modo focado.

---

## TIPOS DE LACUNA QUE GERAM PAUTA

| Tipo de lacuna | Critério de detecção | Skill-alvo no collector |
|---|---|---|
| RF sem critério de aceitação | RF em `03.1-funcionais.md` não tem condição verificável ("o sistema DEVE fazer X" — mas como saber se fez?) | `entrevista-estruturada` (pergunta focada) |
| RNF sem métrica | RNF em `03.2-qualidade.md` com campo Métrica = `LACUNA` | `entrevista-estruturada` (pergunta focada) |
| Restrição sem detalhe suficiente | `03.3-restricoes.md` tem restrição legal/técnica sem referência normativa ou valor explícito | `entrevista-estruturada` (pergunta focada) |
| Conflito não resolvido | `conflitos-detectados.md` tem item com `status: aberto` que afeta escopo ou modal de RF | `entrevista-estruturada` ou `cenario-narrativa` |
| Termo do glossário com `[DEFINIÇÃO INCERTA]` | `glossario.md` tem entrada marcada | `entrevista-estruturada` (pergunta de terminologia) |
| Premissa crítica sem validação | `03.4-premissas.md` tem premissa cujo impacto é alto e não foi confirmada pelo usuário | `entrevista-estruturada` (yesno de confirmação) |

---

## PROCESSO

### Entrada

- `03.1-funcionais.md` rascunho (com campos modal e MoSCoW preenchidos)
- `03.2-qualidade.md` rascunho (com campo Métrica)
- `03.3-restricoes.md` rascunho
- `03.4-premissas.md` (se existir)
- `glossario.md`
- `conflitos-detectados.md` (se existir)

### Algoritmo

Para cada tipo de lacuna acima:

1. Varrer os artefatos buscando o sinal de detecção
2. Para cada lacuna encontrada:
   - Verificar se é **crítica** (afeta RF `DEVE`, RNF `DEVE`, ou restrição legal) → sempre gera pauta
   - Verificar se é **importante** (afeta RF `DEVERIA`) → gera pauta se não há informação suficiente para inferência
   - Verificar se é **cosmética** (afeta RF `PODE` ou PODERIA_TER) → não gera pauta (resolver em M3 se necessário)
3. Criar entrada em `pautas-reelicitacao.md` para cada lacuna crítica ou importante

### Sem interação com usuário

A detecção é automática. As perguntas de re-elicitação serão feitas pelo `collector` em modo focado na próxima iteração do loop.

---

## SAÍDA

### pautas-reelicitacao.md (vazio = Gate pode abrir)

```markdown
# Pautas de Detalhamento

> Itens que precisam de informação adicional antes de finalizar esta fase.
> Quando todos os itens estiverem marcados `[x]`, a próxima fase pode começar.

- [ ] RF-005 não tem critério de aceitação claro: como saber se o sistema "enviou a notificação com sucesso"? (skill-alvo: entrevista-estruturada)
- [ ] RNF-002 sem métrica de disponibilidade: qual % de uptime é aceitável? (skill-alvo: entrevista-estruturada)
- [ ] LGPD em REST-001 sem referência ao art. específico: aplicar arts. 7–9 (consentimento) ou arts. 14–15 (menores)? (skill-alvo: entrevista-estruturada)
```

### Arquivo vazio (sem pautas)

```markdown
# Pautas de Detalhamento

> Nenhuma pauta aberta. Gate 2 pode ser apresentado ao usuário.
```

---

## REGRAS DE QUALIDADE

- Cada pauta tem: checkbox `[ ]` + descrição da lacuna + `(skill-alvo: nome-da-skill)`
- Pautas devem ser específicas: "RNF-002 sem métrica de disponibilidade" é válido; "revisar RNFs" não é
- O collector em modo focado recebe este arquivo como instrução: "resolver pautas marcadas `[ ]` usando a skill-alvo indicada"
- Ao resolver uma pauta, o `modeler` marca `[x]` no item correspondente
- `pautas-reelicitacao.md` persiste após M2 — o `checker` (M3) pode criar novas pautas se necessário
