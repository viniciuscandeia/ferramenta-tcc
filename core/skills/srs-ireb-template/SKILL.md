---
name: srs-ireb-template
description: Monta o SRS-completo.md com as 6 seções IREB §3.3.3 (ISO/IEC/IEEE 29148), consumindo todos os artefatos M1+M2 e a saída formatada de requisito-ears. Seção 3 com RFs EARS+RFC2119; seção 4 com RNFs mensuráveis; seção 5 com restrições+premissas+glossário; seção 6 com rastreabilidade. Não gera versão leigo (traducao-gate faz isso no Passo 7 do documenter).
when_to_use: Invocada pelo documenter como Passo 2 do Processo M3. Depende de requisito-ears (Passo 1) ter executado primeiro.
---

# Skill: srs-ireb-template

**Referências:** IREB §3.3.3 · ISO/IEC/IEEE 29148:2018 · Wiegers Software Requirements Ch12
**Marco:** M3 — Detalhamento (Passo 2)
**Invocada por:** `documenter`

---

## ESTRUTURA DO SRS — 6 SEÇÕES IREB §3.3.3

| Seção | Título | Fonte dos dados |
|---|---|---|
| 1 | Introdução | `visao-produto-normativo.md` (M1) |
| 2 | Descrição Geral | `visao-produto-normativo.md` + `03.3-restricoes.md` + `03.4-premissas.md` |
| 3 | Requisitos Funcionais | Saída de `requisito-ears` (Passo 1) — tabela EARS + RFC 2119 |
| 4 | Requisitos de Qualidade | Saída de `requisito-ears` (Passo 1) — tabela RNFs com métricas |
| 5 | Interfaces Externas e Glossário | `03.3-restricoes.md` + `glossario.md` |
| 6 | Matriz de Rastreabilidade | Cruzamento: objetivos M1 → RF/RNF → spec → test |

**Regra de completude:** todas as 6 seções devem estar presentes no SRS gerado. Se não houver dados suficientes para uma seção ou subseção, escrever um placeholder explícito — nunca omitir a seção.

---

## PROCESSO

### Entrada

Artefatos obrigatórios:
- `visao-produto-normativo.md` (M1) — contexto, objetivos, stakeholders
- `03.1-funcionais.md` (M2) — lista de RFs com modais
- `03.2-qualidade.md` (M2) — lista de RNFs com buckets e métricas
- `03.3-restricoes.md` (M2) — restrições (legal, técnica, organizacional, temporal)
- `glossario.md` (M2) — termos do domínio com definições
- Saída de `requisito-ears` (Passo 1) — tabelas EARS formatadas

Artefatos opcionais (usar se existirem):
- `03.4-premissas.md` — premissas aceitas com impacto se falsas
- `conflitos-detectados.md` — conflitos entre stakeholders ou itens (registrar em seção 2 se existir)

### Algoritmo de montagem

**Seção 1 — Introdução:**
- 1.1 Objetivo: extrair de `visao-produto-normativo.md` — qual problema resolve, quem usa, contexto geral
- 1.2 Definições e Abreviações: siglas e termos técnicos usados no documento (RF, RNF, DEVE, EARS, IREB, etc.)
- 1.3 Referências: listar artefatos de entrada utilizados + norma ISO/IEC/IEEE 29148

**Seção 2 — Descrição Geral:**
- 2.1 Contexto do Produto: diagrama textual de fronteira (o sistema X interage com Y por meio de Z)
- 2.2 Stakeholders: tabela extraída de `visao-produto-normativo.md` (papel + interesse + influência)
- 2.3 Ambiente de Operação e Restrições de Design: consolidar `03.3-restricoes.md` (subtipos: legal, técnica, organizacional, temporal)
- 2.4 Premissas e Dependências: consolidar `03.4-premissas.md`; se não existir → "Nenhuma premissa formal registrada nesta fase"

**Seção 3 — Requisitos Funcionais:**
- Inserir tabela EARS de RFs da saída de `requisito-ears`
- Organizar por módulo ou processo de negócio se `visao-produto-normativo.md` indicar agrupamentos naturais; caso contrário, manter ordem de IDs (RF-001, RF-002...)
- Incluir todos os RFs — nenhum pode ser omitido silenciosamente

**Seção 4 — Requisitos de Qualidade:**
- Inserir tabela de RNFs da saída de `requisito-ears`
- Para cada RNF: ID | Bucket | Modal | Comportamento | Métrica | Critério de aceite
- Critério de aceite = condição de verificação mensurável (ex.: "teste de carga com k6 atingindo 1000 req/s sem degradação > 10%")

**Seção 5 — Interfaces Externas e Glossário:**
- 5.1 Interfaces Externas: APIs de terceiros, sistemas legados, dispositivos físicos mencionados em `03.3-restricoes.md` ou `visao-produto-normativo.md`; se nenhum identificado → "Interfaces externas não identificadas nesta fase — detalhar em fase de design"
- 5.2 Glossário: integrar `glossario.md` completo (termos + definições + sinônimos + fonte)

**Seção 6 — Matriz de Rastreabilidade:**
- Tabela com colunas: Objetivo de negócio (M1) | RF/RNF | Arquivo spec (.feature) | Arquivo test
- Coluna spec: preencher com nome do arquivo `spec/<id>.feature` para RFs DEVE; N/A para DEVERIA/PODE (ainda sem spec nesta iteração)
- Coluna test: N/A nesta fase (preenchida após Passo 4 — step-defs-red)
- Objetivo de negócio extraído de `visao-produto-normativo.md` seção de objetivos/visão

### Verificação de completude antes de salvar

Antes de salvar `SRS-completo.md`, verificar:
- [ ] Todas as 6 seções presentes
- [ ] Contagem de RFs na seção 3 == contagem em `03.1-funcionais.md`
- [ ] Contagem de RNFs na seção 4 == contagem em `03.2-qualidade.md`
- [ ] Seção 6 tem uma linha para cada RF e cada RNF

---

## SAÍDA — Estrutura de SRS-completo.md

```markdown
# [Nome do Produto] — Especificação de Requisitos

**Versão:** 1.0 | **Data:** [data de geração] | **Gerado por:** ferramenta-tcc
**Norma:** ISO/IEC/IEEE 29148:2018 — IREB §3.3.3

---

## 1. Introdução

### 1.1 Objetivo
[Descrição do problema resolvido, usuários-alvo e contexto geral]

### 1.2 Definições e Abreviações
| Abreviação | Significado |
|---|---|
| RF | Requisito Funcional |
| RNF | Requisito de Qualidade (Não-Funcional) |
| DEVE | Obrigatório — RFC 2119 MUST |
| DEVERIA | Recomendado — RFC 2119 SHOULD |
| PODE | Opcional — RFC 2119 MAY |
| EARS | Easy Approach to Requirements Syntax |

### 1.3 Referências
- `visao-produto-normativo.md` — visão e objetivos do produto (Marco 1)
- `03.1-funcionais.md`, `03.2-qualidade.md`, `03.3-restricoes.md` — artefatos Marco 2
- ISO/IEC/IEEE 29148:2018 — Systems and software engineering — Requirements engineering

---

## 2. Descrição Geral

### 2.1 Contexto do Produto
[Diagrama textual de fronteira: o sistema X interage com Y via Z]

### 2.2 Stakeholders
| Papel | Interesse | Nível de influência |
|---|---|---|
| [extraído de visao-produto-normativo.md] | ... | Alto / Médio / Baixo |

### 2.3 Ambiente de Operação e Restrições de Design
[Restrições de 03.3-restricoes.md — legal, técnica, organizacional, temporal]

### 2.4 Premissas e Dependências
[Premissas de 03.4-premissas.md com impacto se falsas; ou "Nenhuma premissa formal registrada nesta fase"]

---

## 3. Requisitos Funcionais

[Tabela EARS de RFs da saída de requisito-ears — ID | Tipo-EARS | Sujeito | Modal | Verbo | Objeto | Condição]

---

## 4. Requisitos de Qualidade

[Tabela de RNFs — ID | Bucket | Modal | Comportamento | Métrica | Critério de aceite]

---

## 5. Interfaces Externas e Glossário

### 5.1 Interfaces Externas
[APIs, sistemas legados, dispositivos; ou "Interfaces externas não identificadas nesta fase — detalhar em fase de design"]

### 5.2 Glossário
[Conteúdo completo de glossario.md]

---

## 6. Rastreabilidade

| Objetivo de negócio | RF / RNF | Spec (.feature) | Test |
|---|---|---|---|
| [objetivo M1] | RF-001 | spec/rf-001-slug.feature | N/A |
| [objetivo M1] | RF-002 | N/A (modal DEVERIA) | N/A |
| [objetivo M1] | RNF-001 | N/A | N/A |
```

---

## REGRAS

- Todas as 6 seções devem estar presentes — escrever placeholder explícito se não houver dados (nunca omitir)
- O SRS deve conter 100% dos itens de `03.1-funcionais.md` e `03.2-qualidade.md` — nenhuma omissão silenciosa
- A seção 6 pode usar N/A nas colunas spec e test (serão preenchidas pelos Passos 3 e 4 do documenter)
- Não gerar versão leigo — essa responsabilidade é exclusiva de `traducao-gate` (Passo 7 do documenter)
- Não interagir com o usuário — processamento totalmente automatizado
- Se `conflitos-detectados.md` existir: registrar nota na seção 2.3 indicando que conflitos foram detectados e resolvidos ou pendentes
- Tamanho esperado: 300 a 600 linhas dependendo do tamanho do projeto
