---
name: clarificacao-pos-visao
description: Micro-fase condicional após o Marco 1 — resolve lacunas críticas de escopo, terminologia ou restrições detectadas por contexto-e-limite antes de avançar para elicitação. Ativada apenas se ≥ 2 categorias com lacunas críticas. Máximo 3 perguntas em uma única chamada.
when_to_use: Apenas se contexto-e-limite reportar lacunas críticas em ≥ 2 de 3 categorias (escopo funcional, terminologia do domínio, restrições de negócio). NÃO executar se condição não atendida.
---

# Skill: clarificacao-pos-visao

**Decisão:** D16 — Sub-fase de clarificação pré-elicitação
**Marco:** M1 — Definição da Necessidade (sub-fase condicional)
**Ordem no workflow:** 5ª skill, **condicional**

---

## CONDIÇÃO DE ATIVAÇÃO (D16)

**Ativar se e somente se:** `contexto-e-limite` reportar lacunas críticas em **≥ 2** das 3 categorias:
1. Escopo funcional (lista de funcionalidades incompleta ou contraditória)
2. Terminologia do domínio (termos sem definição clara)
3. Restrições de negócio (restrições legais/prazo sem detalhe)

**Não ativar se:** apenas 0 ou 1 categoria com lacuna — prosseguir diretamente para `traducao-gate`.

---

## REGRAS RÍGIDAS (D16)

- **Exatamente 1 chamada** `AskUserQuestion` — sem segunda rodada nesta skill
- **Máximo 3 perguntas** nessa chamada
- **Tipos de pergunta:** `choice` ou `yesno` apenas — sem perguntas abertas (`text`) nesta skill
- Focar apenas nas 2 ou 3 lacunas mais críticas — não tentar cobrir tudo
- As respostas são incorporadas em `visao-produto.md` **antes** de avançar para M2

---

## SELEÇÃO DE PERGUNTAS

Escolher **exatamente 3** perguntas (ou menos, se houver < 3 lacunas críticas), priorizando na ordem:

### 1. Escopo funcional (se lacuna detectada)

Exemplo de pergunta `choice`:
```
Você mencionou [funcionalidade X]. Isso inclui:
(A) Apenas [interpretação mais simples]
(B) Também [interpretação mais completa]
(C) Algo diferente — vou explicar melhor quando chegarmos nos detalhes
```

### 2. Terminologia do domínio (se lacuna detectada)

Exemplo de pergunta `yesno`:
```
Quando você diz "[termo usado pelo usuário]", você quer dizer [interpretação inferida]?
```

### 3. Restrições de negócio (se lacuna detectada)

Exemplo de pergunta `choice`:
```
Você mencionou [restrição]. Isso significa que:
(A) O produto precisa estar pronto até [data inferida]
(B) Existe um orçamento máximo de [valor inferido]
(C) Há uma regra legal específica que não mencionou ainda
```

---

## PROCESSAMENTO

Após a única chamada `AskUserQuestion`:

1. Incorporar as respostas às seções correspondentes de `visao-produto.md`:
   - Respostas de escopo → atualizar "O que está no projeto"
   - Respostas de terminologia → adicionar à seção "Glossário inicial" (criar se necessário)
   - Respostas de restrições → atualizar tabela "Restrições"

2. Aplicar `traducao-leigo` sobre qualquer texto novo adicionado

3. Sinalizar ao `stakeholder-identifier`: clarificação concluída → prosseguir para `traducao-gate`

---

## SAÍDA

`visao-produto.md` atualizado com as lacunas resolvidas.

**Importante:** Esta skill não gera um artefato novo — atualiza os artefatos das skills anteriores.
