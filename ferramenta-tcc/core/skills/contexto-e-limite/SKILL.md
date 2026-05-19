---
name: contexto-e-limite
marco: [M1]
description: >-
  Define o que o produto vai fazer e o que está fora do projeto — evita expectativas erradas antes da próxima fase.
  Use após mapear as pessoas envolvidas, para fechar o escopo do Marco 1.
  Define system context and boundaries for a layperson stakeholder; identifies integrations and restrictions.
---

## Filosofia desta skill (Regras Absolutas)

1. **Facilitador de limites** — "O que está fora" é tão importante quanto "o que está dentro". Nunca pular ou minimizar as exclusões.
2. **Restrição sem tipo = não é restrição.** Se o usuário diz "tem algumas restrições", sondar: prazo, orçamento, tecnologia ou legal. Genérico não vai para o artefato.
3. **Contradição dentro/fora é pior que ausência.** Se o usuário listou algo em "o que faz" que contraria "o que não faz", sinalizar imediatamente antes de registrar.

<HARD-GATE>
- NÃO executar antes de `stakeholder-mapping` concluído (verificar que `## Pessoas Envolvidas` existe em `visao-produto.md`)
- ⛔ STOP se respostas 1 e 2 forem semanticamente idênticas (usuário não entendeu a distinção dentro/fora) — re-explicar com exemplo concreto antes de continuar
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## Pessoas Envolvidas` existe em `visao-produto.md`
3. Extrair de skills anteriores: funcionalidades já mencionadas em Situação-Problema → usadas para validar consistência em Fase 2

## Fase 1 — Coleta

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

## Fase 2 — Síntese

Gerar seção de contexto e limites:

```markdown
## Contexto e Limites do Projeto

### O que está no projeto

[Bullet list — resposta 1 + inferências das skills anteriores, verificando consistência com Situação-Problema]

### O que está fora do projeto

[Bullet list — exclusões explícitas da resposta 2]

### Integrações previstas

[Bullet list de sistemas externos — resposta 3]
[Se nenhuma: "Nenhuma integração identificada nesta fase."]

### Restrições

| Tipo | Descrição |
|---|---|
| [Prazo / Orçamento / Técnica / Legal / Outro] | [Detalhe da restrição] |

[Se nenhuma: "Nenhuma restrição identificada nesta fase."]
```

**Regras de síntese:**

- "O que está no projeto" deve ser consistente com funcionalidades listadas em Situação-Problema — divergência = flag de lacuna
- Integrações mencionadas: registrar como "a detalhar em fase seguinte" — não aprofundar agora
- Restrições classificadas por tipo; restrição vaga → marcar como `[a detalhar]`
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

## Fase 3 — Detecção de Lacunas (para `clarificacao-pos-visao` — D16)

Verificar 3 categorias críticas e retornar relatório ao `stakeholder-identifier`:

| Categoria | Lacuna crítica se |
|---|---|
| Escopo funcional | "O que está no projeto" tem < 3 itens OU contradiz Situação-Problema |
| Terminologia do domínio | Termos do domínio sem definição clara no material coletado |
| Restrições de negócio | Restrições legais ou de prazo mencionadas mas não detalhadas |

Retornar: lista de categorias com lacuna + contagem total. O `stakeholder-identifier` decide se ativa `clarificacao-pos-visao` (D16: só se ≥ 2 categorias).

## Fase 4 — Saída

1. Append seção `## Contexto e Limites do Projeto` em `visao-produto.md`
2. Retornar relatório de lacunas ao `stakeholder-identifier`
3. Sinalizar conclusão → `stakeholder-identifier` avalia lacunas → prosseguir para `clarificacao-pos-visao` (se ≥ 2) ou `traducao-gate` (se < 2)

<!-- internal -->
## Anti-Padrão: Dentro/Fora Copia Funcionalidades Sem Distinguir

**Como acontece:** Resposta 1 ("vai fazer") e resposta 2 ("não vai fazer") têm overlap — o usuário lista o mesmo item em ambas com redação diferente (ex: "controlar estoque" em Dentro e "não vai controlar entradas de estoque" em Fora).

**Como detectar:** Tokenizar bullet lists de ambas as seções; checar overlap de substantivos-chave. Overlap > 30% = flag.

**O que fazer:** ⛔ STOP — re-apresentar as duas listas lado a lado e perguntar qual das interpretações é a correta antes de prosseguir. Nunca registrar ambiguidade silenciosamente.
<!-- /internal -->
