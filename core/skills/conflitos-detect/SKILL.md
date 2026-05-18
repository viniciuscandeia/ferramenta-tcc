---
name: conflitos-detect
description: Detecta conflitos entre requisitos ou stakeholders usando os 6 tipos IREB §4.4 e propõe estratégias de resolução. Gera conflitos-detectados.md apenas se ≥ 1 conflito encontrado. Versão M2 foca em duplicatas, contradições escopo-limite e conflitos entre stakeholders — expansão completa em M3 via analyze-cross-artifact.
when_to_use: Invocada pelo modeler no Passo 4 da Fase B. Sempre executar, mas só criar arquivo de saída se ≥ 1 conflito. Sem interação com usuário.
---

# Skill: conflitos-detect

**Referência:** IREB §4.4 (6 tipos de conflito + 4 estratégias de resolução)
**Marco:** M2 — Consenso de Escopo (Fase B, Passo 4)
**Invocada por:** `modeler`

---

## TIPOS DE CONFLITO (IREB §4.4)

| Tipo | Descrição | Sinal de detecção |
|---|---|---|
| **Interesse** | Stakeholders querem coisas opostas | RF-X favorece Stakeholder A mas prejudica B |
| **Dados** | Mesma informação definida diferente em dois lugares | Campo "status" tem valores diferentes em RF-010 e RF-015 |
| **Processo** | Fluxos incompatíveis — A exige B antes de C, mas C já iniciou | RF de fluxo A contradiz fluxo B |
| **Recursos** | Dois requisitos disputam o mesmo recurso limitado (tempo, hardware, orçamento) | RF de alta disponibilidade vs. restrição de orçamento mínimo |
| **Valor** | Prioridades inconsistentes — item marcado `DEVE` em um lugar e `PODE` em outro | RF-005 `DEVE` em 03.1-funcionais vs. implicado como `PODE` em cenario-narrativa |
| **Semântico** | Mesmo termo significa coisas diferentes para stakeholders distintos | "cliente" = pessoa que compra vs. "cliente" = empresa que contratou o sistema |

---

## ESTRATÉGIAS DE RESOLUÇÃO (IREB §4.4)

| Estratégia | Quando usar |
|---|---|
| **Acordo** | Stakeholders podem dialogar e convergir — registrar decisão tomada |
| **Compromisso** | Nenhum lado cede totalmente — solução meio-a-meio documentada |
| **Votação** | Múltiplos stakeholders com peso igual — maioria decide |
| **Análise de alternativas** | Nenhuma das posições é possível — propor terceira opção |

---

## PROCESSO

### Entrada

- `03.1-funcionais.md` rascunho (após priorizacao)
- `03.2-qualidade.md` rascunho
- `03.3-restricoes.md` rascunho
- `visao-produto-normativo.md` (stakeholders + contexto)
- `elicitacao-raw.md`

### Verificações M2 (escopo desta versão)

Focar nas verificações de maior impacto em M2:

**Verificação 1 — Duplicatas**
- Dois IDs descrevendo a mesma funcionalidade com texto diferente?
- Candidatos: itens criados por fontes diferentes (entrevista vs. recomendacao-implicitos vs. recomendacao-dominio)

**Verificação 2 — Contradições escopo-limite**
- Um RF diz que o sistema FAZ X, mas `visao-produto-normativo.md` lista X como "fora do sistema"?
- Um RF implica integração com sistema externo que não foi declarado em M1?

**Verificação 3 — Prioridades inconsistentes (conflito de Valor)**
- Mesmo item tem `DEVE` em um lugar e `PODERIA` em outro?
- Item marcado como "fora do escopo" (NAO_TERA) mas aparece como RF com modal em outro artefato?

**Verificação 4 — Conflito entre stakeholders (conflito de Interesse)**
- RF favorece fortemente um perfil de usuário e prejudica outro?
- Exemplo: RF "O sistema DEVE simplificar o fluxo para o comprador" vs. RF "O sistema DEVE exigir dados detalhados para o vendedor"

**Verificação 5 — Termos semânticos (conflito Semântico)**
- Cruzar `glossario.md` com `elicitacao-raw.md`: mesmo termo com definições diferentes em contextos distintos?

### Sem interação com usuário

Detecção automática. Se conflito requer decisão humana: registrar no `conflitos-detectados.md` com estratégia recomendada; o orquestrador ou o `checker` (M3) poderá escalar ao usuário se necessário.

---

## SAÍDA

### Nenhum conflito detectado

Não criar `conflitos-detectados.md`. Registrar apenas na saída do modeler: "conflitos-detect: 0 conflitos detectados em M2."

### ≥ 1 conflito detectado → conflitos-detectados.md

```markdown
# Conflitos Detectados — M2

> Gerado automaticamente. Conflitos não resolvidos podem bloquear Gate 3 (analyze-cross-artifact — D17).

---

## CONF-001 — [Tipo de conflito]: [Descrição curta]

**Tipo IREB §4.4:** [Interesse / Dados / Processo / Recursos / Valor / Semântico]
**Itens envolvidos:** RF-005, RF-012 (ou stakeholders A vs. B)
**Descrição:** [O que está em conflito e por quê]
**Estratégia recomendada:** [Acordo / Compromisso / Votação / Análise de alternativas]
**Status:** `aberto` | `resolvido`
**Resolução (se resolvido):** [Como foi resolvido]

---
```

---

## REGRAS DE QUALIDADE

- Um mesmo par de itens pode ter no máximo 1 conflito registrado (consolidar múltiplos aspectos num único CONF)
- Status inicial sempre `aberto` — o modeler não resolve conflitos sozinho
- Conflitos do tipo Semântico que têm definição já no `glossario.md` podem ser marcados `resolvido` automaticamente (o glossário resolve a ambiguidade)
- `conflitos-detectados.md` é input do `checker` em M3 (`analyze-cross-artifact`) — não remover o arquivo após M2
