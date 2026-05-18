---
name: stakeholder-mapping
description: Identifica e mapeia as pessoas envolvidas no projeto — quem usa, quem decide, quem é afetado. Produz tabela de personas/papéis para o terceiro componente de visao-produto.md.
when_to_use: Terceira skill do Marco 1, após situacao-problema. Executada antes de contexto-e-limite.
---

# Skill: stakeholder-mapping

**Referência:** Livro 2, cap. 1 (Identificação de Stakeholders)
**Marco:** M1 — Definição da Necessidade
**Ordem no workflow:** 3ª skill

---

## OBJETIVO

Identificar todas as pessoas que têm interesse, serão afetadas, ou precisam aprovar o projeto. O mapeamento correto evita que requisitos importantes sejam ignorados por falta de representação de algum grupo.

---

## PRÉ-PROCESSAMENTO

Antes de perguntar ao usuário, extrair das respostas anteriores (Vision Box + Situação-Problema) os grupos de pessoas já mencionados. Usá-los como ponto de partida para as perguntas — não repetir o que já foi dito.

---

## PERGUNTAS AO USUÁRIO

**Lote único (≤ 4 perguntas):**

1. **Usuários diretos** (text):
   ```
   Além de [pessoas mencionadas antes], quem mais vai usar o produto no dia a dia?
   ```
   *(Se ninguém foi mencionado antes: "Quem vai usar o produto no dia a dia?")*

2. **Decisores** (text):
   ```
   Quem precisa aprovar ou pagar pelo produto? Pode ser uma pessoa, um cargo ou um departamento.
   ```

3. **Afetados indiretamente** (text):
   ```
   Tem alguém que vai ser afetado pelo produto, mesmo sem usá-lo diretamente? (ex: equipe de suporte, clientes dos seus clientes)
   ```

4. **Quem não deve ter acesso** (text):
   ```
   Tem algum grupo de pessoas que NÃO deve ter acesso ou não deve ser impactado pelo produto?
   ```
   *(Esta pergunta ajuda a delimitar o escopo — formulada em linguagem simples)*

---

## PROCESSAMENTO

Com as respostas + dados já extraídos das skills anteriores, gerar a tabela de pessoas envolvidas:

### Estrutura da tabela (versão normativa)

```markdown
## Pessoas Envolvidas

| Papel | Descrição | Tipo de envolvimento | Necessidade principal |
|---|---|---|---|
| [Nome do papel] | [Quem é] | Usuário direto / Decisor / Afetado / Restrito | [O que precisa do projeto] |
```

**Tipos de envolvimento:**
- **Usuário direto** — usa o produto ativamente
- **Decisor** — aprova, financia ou define prioridades
- **Afetado** — impactado pelos resultados, mas não usa diretamente
- **Restrito** — não deve ter acesso

### Regras de geração

- Cada grupo mencionado vira uma linha na tabela
- Inferir "necessidade principal" com base no contexto — sinalizar como "[inferido]" se incerto
- Se o usuário não souber responder alguma pergunta: registrar o papel como "a identificar" na tabela
- Verificar consistência com Vision Box (público-alvo) e Situação-Problema (usuários principais)
- Aplicar `traducao-leigo` antes de exibição ao usuário

---

## SAÍDA

Seção "## Pessoas Envolvidas" para compor `visao-produto.md`.

Sinalizar ao `stakeholder-identifier` que mapeamento concluído → prosseguir para `contexto-e-limite`.
