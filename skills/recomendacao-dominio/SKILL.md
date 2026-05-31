---
name: recomendacao-dominio
marco: [M2]
description: >-
  Identifica o tipo de produto (loja virtual, app de saúde, painel de relatórios etc.) e sugere funcionalidades típicas daquele setor para confirmar com o usuário.
  Use na Rodada 3 do Marco 2, após os cenários narrativos.
  Domain-based requirement recommendation for layperson stakeholder; matches project to domain catalog and confirms via structured questions.
---

## Filosofia desta skill (Regras Absolutas)

1. **Confirmação de domínio é obrigatória — nunca assumir.** Detecção automática pode errar. O usuário confirma; o catálogo executa. Pular a confirmação = dados de domínio errado invadem `elicitacao-raw.md`.
2. **Perguntas do catálogo são choice ou yesno — nunca text.** Respostas estruturadas aqui facilitam a classificação do modeler mais tarde. Questão aberta nesta rodada = dado não-classificável.
3. **Zero termos técnicos visíveis.** Nunca mencionar "catálogo", "domínio", "seed", "classificação". Usar "o seu tipo de produto" em vez de "domínio".

<HARD-GATE>
- NÃO executar antes de `cenario-narrativa` concluída (verificar seção `## Cenários Narrativos` em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`)
- NÃO executar se nenhum catálogo em `core/catalogos-seed/dominios/` tem ≥ 2 keyword matches E catálogo genérico não está disponível — registrar em `_pendencias.md` e pular esta rodada
- ⛔ STOP se usuário nega o domínio detectado E seleciona "outro" — usar catálogos genéricos sem nova pergunta de confirmação
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## Cenários Narrativos` existe em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`
3. Acessar catálogos disponíveis em `core/catalogos-seed/dominios/`

## Fase 1 — Detecção Automática do Domínio

Ler `documentos-tecnicos/01-visao/01-visao-produto.md` (seções: nome, público-alvo, funcionalidades-chave, contexto). Contar matches de keywords:

| Domínio | Arquivo | Keywords |
|---|---|---|
| E-commerce | `dominios/ecommerce.md` | loja, venda, produto, compra, pedido, carrinho, pagamento, frete, cliente, estoque |
| Educação | `dominios/educacao.md` | aprender, curso, aula, aluno, professor, ensino, escola, turma, nota, quiz, exercício |
| Saúde | `dominios/saude.md` | saúde, médico, paciente, consulta, prontuário, agendamento, farmácia, exame, receita |
| Mobile | `dominios/mobile.md` | app, aplicativo, celular, smartphone, notificação push, offline, GPS, câmera |
| Dashboard | `dominios/dashboard.md` | relatório, análise, gráfico, métricas, indicadores, painel, filtro, exportar |

Selecionar domínio com maior contagem. Empate: mais específico vence. Nenhum com ≥ 2 matches → usar genérico e pular Fase 2.

## Fase 2 — Confirmação com o Usuário

**1 chamada `AskUserQuestion` com 1 pergunta:**

**Domínio único (yesno):**
```
O seu projeto parece ser do tipo [nome do domínio em linguagem leiga — ex: "loja virtual", "app de saúde"].
Isso está certo?
```

**Múltiplos domínios plausíveis (choice):**
```
Qual categoria descreve melhor o seu projeto?
(A) [Domínio 1 — ex: Loja virtual]
(B) [Domínio 2 — ex: App de gestão mobile]
(C) Nenhum dos dois — é algo diferente
```

Se confirmado: usar catálogo do domínio. Se negado: usar catálogo genérico (`rfs-tipicos.md` + `rnfs-tipicos.md`).

## Fase 3 — 4 Perguntas do Catálogo

**1 chamada `AskUserQuestion` com 4 perguntas (choice ou yesno):**

| Seção do catálogo | Pergunta |
|---|---|
| Stakeholders típicos | "Além de [usuários já identificados], existem outros perfis? (Ex: [exemplos do catálogo])" |
| Funcionalidades típicas | "Quais dessas funcionalidades comuns fazem sentido para o seu produto? [choice 3-4 opções, `multiSelect: true`]" |
| RNFs típicos | "Há requisitos de [desempenho/segurança/privacidade] que precisa cumprir? (Ex: [exemplos])" |
| Restrições típicas | "Há lei, regulação ou padrão que o produto precisa seguir? (Ex: [exemplos do domínio])" |

**Tipo obrigatório:** choice ou yesno — nunca `text` nesta fase.

## Fase 4 — Saída

Acrescentar seção em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`:

```markdown
## Recomendações de Domínio (recomendacao-dominio — Fase A)

**Domínio detectado:** [nome] (confirmado pelo usuário)
**Catálogo usado:** `core/catalogos-seed/dominios/[arquivo].md`

**Stakeholders adicionais confirmados:** [lista ou "nenhum"]
**Funcionalidades confirmadas:** [lista com origem no catálogo]
**RNFs confirmados:** [lista]
**Restrições confirmadas:** [lista com referência legal se houver]
```

Sinalizar ao `collector`: recomendacao-dominio concluída → prosseguir para `recomendacao-implicitos`.

<!-- internal -->
## Anti-Padrão: Domínio Confirmado Sem yesno Claro

**Como acontece:** A detecção automática retorna "saúde" com 3 matches. A skill pula a Fase 2 por "confiança alta" e vai direto para as 4 perguntas do catálogo de saúde. Mas o projeto é de saúde animal (pet shop), não saúde humana — as perguntas de catálogo (prontuário, CFM) ficam completamente erradas.

**Como detectar:** Verificar se Fase 2 foi executada. Se não: flag `confirmation_skipped: true` — proibido em qualquer contagem de matches.

**O que fazer:** Fase 2 é sempre obrigatória independente do número de matches. O custo de 1 pergunta de confirmação é zero; o custo de catálogo errado é re-elicitação completa em Fase B.
<!-- /internal -->
