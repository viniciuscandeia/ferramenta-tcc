---
name: contexto-e-limite
description: Define o contexto do sistema (o que está no escopo) e os limites (o que está fora). Evita expectativas não-alinhadas e reduz re-elicitação por escopo mal definido. Produz quarto componente de visao-produto.md.
when_to_use: Quarta skill do Marco 1, após stakeholder-mapping. Última skill antes de clarificacao-pos-visao (condicional).
---

# Skill: contexto-e-limite

**Referência:** IREB §3.3.3 Parte II — Contexto e Limite do Sistema
**Marco:** M1 — Definição da Necessidade
**Ordem no workflow:** 4ª skill

---

## OBJETIVO

Estabelecer explicitamente o que o produto vai e não vai fazer. Ambiguidades no contexto e limites são a principal fonte de conflitos entre cliente e equipe técnica — definir agora previne retrabalho caro nas fases seguintes.

---

## PERGUNTAS AO USUÁRIO

**Lote único (≤ 4 perguntas):**

1. **O que o produto vai fazer** (text):
   ```
   O que o produto vai fazer? Liste as principais atividades que ele vai realizar para as pessoas que vão usá-lo.
   ```

2. **O que o produto NÃO vai fazer** (text):
   ```
   O que o produto definitivamente NÃO vai fazer? Há algo que as pessoas podem esperar mas que está fora do projeto?
   ```

3. **Integrações com outros sistemas** (text):
   ```
   O produto precisa se conectar com outros sistemas ou serviços que você já usa? (ex: sistema de pagamento, e-mail, WhatsApp, sistema financeiro)
   ```

4. **Restrições conhecidas** (text):
   ```
   Existe alguma restrição importante? (ex: prazo, orçamento, tecnologia específica que deve ser usada, regras legais que o produto precisa respeitar)
   ```

---

## PROCESSAMENTO

Com as respostas, gerar as seções de contexto e limite:

### Estrutura da saída (versão normativa)

```markdown
## Contexto e Limites do Projeto

### O que está no projeto

[Bullet list com o que o produto vai fazer — resposta 1 + inferências das skills anteriores]

### O que está fora do projeto

[Bullet list com exclusões explícitas — resposta 2]

### Integrações previstas

[Bullet list de sistemas externos com que o produto se conecta — resposta 3]
[Se nenhuma: "Nenhuma integração identificada nesta fase."]

### Restrições

| Tipo | Descrição |
|---|---|
| [Prazo / Orçamento / Técnica / Legal / Outro] | [Detalhe da restrição] |

[Se nenhuma: "Nenhuma restrição identificada nesta fase."]
```

### Regras de geração

- "O que está no projeto" deve ser consistente com as funcionalidades listadas em Situação-Problema
- Verificar contradições: se o usuário listou algo em "o que faz" que contraria "o que não faz", sinalizar como lacuna a resolver
- Se integrações forem mencionadas: registrar como "a detalhar em fase seguinte" — não aprofundar agora
- Restrições devem ser classificadas por tipo (prazo, orçamento, técnica, legal)
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário

---

## DETECÇÃO DE LACUNAS CRÍTICAS (para clarificacao-pos-visao — D16)

Após gerar os artefatos, verificar lacunas nas 3 categorias críticas:

| Categoria | Lacuna crítica se |
|---|---|
| Escopo funcional | "O que está no projeto" tem menos de 3 itens OU contradiz a Situação-Problema |
| Terminologia do domínio | Há termos do domínio usados pelo usuário sem definição clara |
| Restrições de negócio | Restrições legais ou de prazo mencionadas mas não detalhadas |

Retornar ao `stakeholder-identifier`:
- Lista de lacunas por categoria
- Contagem total de categorias com lacuna

O `stakeholder-identifier` decide se ativa `clarificacao-pos-visao` (D16: só se ≥ 2 categorias com lacuna).

---

## SAÍDA

Seção "## Contexto e Limites do Projeto" para compor `visao-produto.md`.

Relatório de lacunas críticas (para decisão de ativar `clarificacao-pos-visao`).

Sinalizar ao `stakeholder-identifier` que contexto-e-limite concluído → avaliar lacunas → prosseguir para `clarificacao-pos-visao` (se necessário) ou diretamente para `traducao-gate`.
