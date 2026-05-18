---
name: recomendacao-dominio
description: Detecta o domínio do projeto a partir de visao-produto-normativo.md (matching contra 5 catálogos de domínio), confirma com o usuário e faz 4 perguntas sobre seções do catálogo. Saída: RFs/RNFs/restrições confirmados em elicitacao-raw.md.
when_to_use: Invocada pelo collector na Ronda 3 da Fase A. Sempre executar após cenario-narrativa. Duas chamadas AskUserQuestion: 1 yesno/choice para confirmar domínio + 1 lote de 4 perguntas.
---

# Skill: recomendacao-dominio

**Catálogos:** `ferramenta-tcc/catalogos-seed/dominios/`
**Marco:** M2 — Consenso de Escopo (Fase A, Ronda 3)
**Invocada por:** `collector`

---

## OBJETIVO

Usar o conhecimento pré-compilado dos catálogos de domínio para sugerir funcionalidades, stakeholders e restrições típicas do setor do projeto — reduzindo o esforço do usuário e aumentando a completude da elicitação.

---

## DOMÍNIOS DISPONÍVEIS

| Domínio | Arquivo | Keywords de detecção |
|---|---|---|
| E-commerce | `catalogos-seed/dominios/ecommerce.md` | loja, venda, produto, compra, pedido, carrinho, pagamento, frete, cliente, estoque |
| Educação | `catalogos-seed/dominios/educacao.md` | aprender, curso, aula, aluno, professor, ensino, escola, turma, nota, quiz, exercício |
| Saúde | `catalogos-seed/dominios/saude.md` | saúde, médico, paciente, consulta, prontuário, agendamento, farmácia, exame, receita |
| Mobile | `catalogos-seed/dominios/mobile.md` | app, aplicativo, celular, smartphone, notificação push, offline, GPS, câmera |
| Dashboard | `catalogos-seed/dominios/dashboard.md` | relatório, análise, gráfico, métricas, indicadores, painel, filtro, exportar |

---

## PROCESSO

### Etapa 1 — Detecção automática do domínio

1. Ler `visao-produto-normativo.md` (seções: nome do produto, público-alvo, funcionalidades-chave, contexto)
2. Contar matches de keywords para cada domínio
3. Selecionar o domínio com maior contagem de matches
4. Se empate: selecionar o mais específico (ex: ecommerce > mobile se ambos têm matches)
5. Se nenhum domínio tem ≥ 2 matches: usar `rfs-tipicos.md` + `rnfs-tipicos.md` genéricos (pular confirmação)

### Etapa 2 — Confirmação com o usuário (1 chamada AskUserQuestion)

**Opção A — Domínio único detectado (yesno):**
```
O seu projeto parece ser do tipo [nome do domínio em linguagem leiga — ex: "loja virtual", "app educacional", "sistema de saúde"].
Isso está certo?
```

**Opção B — Múltiplos domínios plausíveis (choice):**
```
Qual categoria descreve melhor o seu projeto?
(A) [Domínio 1 — ex: Loja virtual / e-commerce]
(B) [Domínio 2 — ex: App de gestão mobile]
(C) Nenhum dos dois — é algo diferente
```

**Se usuário confirma:** prosseguir com catálogo do domínio confirmado
**Se usuário nega/seleciona "outro":** usar catálogo genérico (`rfs-tipicos.md` + `rnfs-tipicos.md`)

### Etapa 3 — 4 perguntas do catálogo (1 lote AskUserQuestion)

Ler o arquivo de domínio e formular 4 perguntas — uma por seção principal do catálogo:

**Estrutura típica dos catálogos (adaptar ao domínio):**

| Seção do catálogo | Pergunta para o usuário |
|---|---|
| Stakeholders típicos | "Além de [usuários já identificados], existem outros perfis que vão usar ou ser afetados pelo produto? (Ex: [exemplos do catálogo])" |
| Funcionalidades típicas | "Qual dessas funcionalidades comuns em [domínio] faz sentido para o seu produto? [lista choice de 3–4 opções]" |
| RNFs típicos | "Existem requisitos de [desempenho/segurança/privacidade] que você já sabe que precisa cumprir? (Ex: [exemplos do catálogo])" |
| Restrições típicas | "Existe alguma lei, regulação ou padrão que o produto precisa seguir? (Ex: [exemplos específicos do domínio])" |

**Tipo de pergunta:** choice (lista de opções) ou yesno — **não usar text** nesta ronda (garante respostas estruturadas)

### Etapa 4 — Registrar no elicitacao-raw.md

```markdown
## Recomendações de Domínio (recomendacao-dominio — Fase A)

**Domínio detectado:** [nome] (confirmado pelo usuário)
**Catálogo usado:** `catalogos-seed/dominios/[arquivo].md`

**Stakeholders adicionais confirmados:** [lista ou "nenhum"]
**Funcionalidades confirmadas:** [lista com origem no catálogo]
**RNFs confirmados:** [lista]
**Restrições confirmadas:** [lista com referência legal se houver]
```

---

## REGRAS (D14 + D19)

- Etapa 2: 1 chamada AskUserQuestion com 1 pergunta (yesno ou choice)
- Etapa 3: 1 chamada AskUserQuestion com exatamente 4 perguntas (lote único)
- Total desta skill: máximo 2 chamadas AskUserQuestion
- Proibido mencionar "catálogo", "domínio", "seed", "classificação" ao usuário
- Usar linguagem: "o seu tipo de produto" em vez de "o seu domínio"

---

## SAÍDA

Seção adicionada a `elicitacao-raw.md` com domínio confirmado + funcionalidades/RNFs/restrições do catálogo validadas pelo usuário.
