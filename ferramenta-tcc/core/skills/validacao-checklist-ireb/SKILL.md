---
name: validacao-checklist-ireb
description: Aplica os 12 critérios de qualidade IREB §3.8 sobre o SRS gerado pelo documenter — 6 critérios por requisito individual e 6 critérios por SRS como documento. Gera seção "Validação IREB §3.8" em analyze-report.md com 1 linha por violação (ID do critério + requisito afetado + severidade). Referência: catalogos-seed/conceitos/qualidade-e-validacao.md.
when_to_use: Invocada pelo checker no Passo 1 do Processo M3. Entrada: SRS-completo.md + 03.1-funcionais.md + 03.2-qualidade.md. Saída: seção em analyze-report.md (não arquivo separado).
---

# Skill: validacao-checklist-ireb

**Referência:** IREB §3.8 (12 critérios de qualidade de requisitos)
**Marco:** M3 — Detalhamento (Fase B, Passo 1)
**Invocada por:** `checker`

---

## 6 CRITÉRIOS POR REQUISITO INDIVIDUAL

Aplicar a cada RF e RNF listado em `03.1-funcionais.md` e `03.2-qualidade.md`:

| Critério | Pergunta de verificação | Exemplo de violação | Severidade |
|---|---|---|---|
| **Adequado** | O requisito descreve algo realmente necessário, sem superespecificar a solução? | RF especifica tecnologia ("DEVE usar PostgreSQL") em vez de comportamento | MEDIUM |
| **Necessário** | Existe justificativa de negócio rastreável até um objetivo declarado em M1? | RF sem ligação a nenhum objetivo de `visao-produto-normativo.md` | HIGH |
| **Sem ambiguidade** | O requisito tem uma única interpretação possível? | Termos vagos: "rápido", "fácil", "intuitivo", "adequado", "flexível" | MEDIUM |
| **Completo** | O requisito é auto-suficiente, sem lacunas ou referências pendentes? | "[TBD]", "[VERIFICAR]", "[pendente]", "[a definir]" no texto do requisito | CRITICAL |
| **Compreensível** | A versão leigo é entendível por não-técnico? A versão normativa é precisa o suficiente para um técnico? | Versão leigo usa jargão; versão normativa é ambígua | MEDIUM |
| **Verificável** | Existe forma objetiva de testar se o requisito foi atendido? | RNF sem métrica quantificável ("o sistema deve ser seguro"); RF sem critério de aceitação claro | HIGH (RNF sem métrica) / MEDIUM (RF sem critério aceite) |

---

## 6 CRITÉRIOS POR SRS COMO DOCUMENTO

Aplicar ao `SRS-completo.md` como um todo:

| Critério | Pergunta de verificação | Exemplo de violação | Severidade |
|---|---|---|---|
| **Completude** | Todos os RFs de `03.1-funcionais.md` e RNFs de `03.2-qualidade.md` aparecem no SRS? | RF-009 presente em `03.1-funcionais.md` mas ausente na seção 3 do SRS | CRITICAL |
| **Consistência** | O SRS é internamente coerente — nenhuma seção contradiz outra? | §3.1 diz "usuário DEVE confirmar e-mail" e §3.5 diz "login sem cadastro prévio possível" | CRITICAL |
| **Viabilidade** | Os requisitos são realizáveis com os recursos e restrições declaradas em `03.3-restricoes.md`? | RNF exige 99,999% de disponibilidade com orçamento de R$500/mês | HIGH |
| **Verificabilidade** | Todos os requisitos do SRS são testáveis em conjunto? | Múltiplos RNFs sem métricas — impossível criar critério de aceite do sistema | HIGH |
| **Modificabilidade** | A estrutura do SRS permite alterar 1 requisito sem impacto em cascata em outros? | RF referenciado por ID em 5 outros RFs — qualquer alteração quebra a cadeia | LOW |
| **Rastreabilidade** | Todos os requisitos do SRS têm origem rastreável até M1 ou M2? | RF no SRS sem origem declarada e sem correspondente em `03.1-funcionais.md` | HIGH |

---

## PROCESSO

### Entrada

- `SRS-completo.md` — documento gerado pelo documenter (Fase A)
- `03.1-funcionais.md` — lista fonte de verdade dos RFs (M2, após Gate 2)
- `03.2-qualidade.md` — lista fonte de verdade dos RNFs (M2, após Gate 2)

### Passo 1 — Carregar listas de referência

Extrair de `03.1-funcionais.md`:
- Lista de todos os IDs de RF (ex.: RF-001, RF-002, ...) com seus modais RFC 2119

Extrair de `03.2-qualidade.md`:
- Lista de todos os IDs de RNF com seus modais e métricas declaradas

### Passo 2 — Verificar cada requisito individualmente

Para cada RF e RNF:
1. Localizar no `SRS-completo.md` a seção correspondente
2. Verificar os 6 critérios individuais na ordem da tabela acima
3. Registrar cada violação com: ID do critério + ID do RF/RNF + descrição da violação + severidade

Não parar na primeira violação — verificar todos os 6 critérios para todos os requisitos.

### Passo 3 — Verificar o SRS como documento

Após varrer todos os requisitos individualmente:
1. Verificar completude: cruzar lista de IDs de `03.1-funcionais.md` contra seção 3 do SRS; cruzar lista de IDs de `03.2-qualidade.md` contra seção 4 do SRS
2. Verificar consistência: buscar afirmações contraditórias entre seções do SRS
3. Verificar viabilidade: comparar RNFs com `03.3-restricoes.md` (se disponível)
4. Verificar verificabilidade: RNFs sem métrica quantificável (número, percentual, tempo)
5. Verificar modificabilidade: RFs referenciados por ID em muitos outros (acoplamento excessivo)
6. Verificar rastreabilidade: RFs no SRS sem correspondente em `03.1-funcionais.md` nem em `visao-produto-normativo.md`

### Passo 4 — Escrever seção no analyze-report.md

Agregar todas as violações encontradas e escrever a seção abaixo. Se não houver violações em uma tabela, escrever "Nenhuma violação encontrada."

---

## SAÍDA — Seção adicionada ao analyze-report.md

```markdown
## Validação IREB §3.8

### Por requisito individual

| Critério | RF/RNF afetado | Violação | Severidade |
|---|---|---|---|
| Verificável | RNF-002 | Métrica ausente: "o sistema deve ser rápido" — sem limites de tempo definidos | HIGH |
| Completo | RF-007 | Campo Verbo contém "[VERIFICAR]" — requisito incompleto | CRITICAL |
| Sem ambiguidade | RF-012 | Termo "intuitivo" sem definição objetiva | MEDIUM |

### Por SRS como documento

| Critério | Violação | Severidade |
|---|---|---|
| Completude | RF-009 presente em 03.1-funcionais.md mas ausente na seção 3 do SRS | CRITICAL |
| Rastreabilidade | RF-011 no SRS sem correspondente em 03.1-funcionais.md nem em visao-produto-normativo.md | HIGH |
| Consistência | §3.2 afirma "cadastro obrigatório" e §3.7 afirma "acesso sem cadastro possível" | CRITICAL |
```

---

## REGRAS DE QUALIDADE

- Sem interação com usuário — análise automática
- Agregar todas as violações antes de escrever a seção (não parar no primeiro CRITICAL)
- Usar português do Brasil nas descrições das violações
- Preservar IDs de RF/RNF exatamente como aparecem nos artefatos-fonte
- Se um RF não for encontrado no SRS: registrar como violação de Completude (CRITICAL), não ignorar
- Não duplicar issues que serão cobertos por `analyze-cross-artifact` no Passo 2
