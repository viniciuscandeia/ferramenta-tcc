---
name: srs-ireb-template
marco: [M3]
description: >-
  Monta o documento completo de especificação do projeto com 6 seções padronizadas — consumindo todos os artefatos produzidos até aqui.
  Use no Marco 3, após formatar os requisitos com padrão de condição, para produzir o documento normativo final.
  Assemble SRS-completo.md following IREB §3.3.3 / ISO 29148; 6 mandatory sections; no user interaction; candidate for R5.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de completude** — todas as 6 seções devem estar presentes. Seção sem dados suficientes recebe placeholder explícito ("Nenhum identificado nesta fase") — nunca é omitida.
2. **Zero omissão silenciosa.** Contagem de RFs na seção 3 == contagem em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`. Contagem de RNFs na seção 4 == contagem em `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`. Divergência = erro de geração.
3. **Esta skill não gera versão leigo.** Responsabilidade exclusiva de `traducao-gate` (Passo 7 do documenter). Misturar as duas versões aqui contamina o fluxo de aprovação do Gate 3.

<HARD-GATE>
- NÃO executar antes de `requisito-ears` (Passo 1) concluído
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/02-requisitos/02.3-restricoes.md`, `documentos-tecnicos/02-requisitos/02.5-glossario.md` — artefatos obrigatórios
- ⛔ STOP se checklist de completude final falhar (seção ausente ou contagem divergente)
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar todos os artefatos obrigatórios existem
3. Carregar artefatos opcionais se existirem: `documentos-tecnicos/02-requisitos/02.4-premissas.md`, `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md`
4. Contar RFs e RNFs de entrada para verificação de completude

## Fase 1 — Montagem das 6 Seções

**Mapeamento de fontes:**

| Seção | Título | Fonte |
|---|---|---|
| 1 | Introdução | `documentos-tecnicos/01-visao/01-visao-produto.md` (M1) |
| 2 | Descrição Geral | `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.3-restricoes.md` + `documentos-tecnicos/02-requisitos/02.4-premissas.md` |
| 3 | Requisitos Funcionais | Saída de `requisito-ears` — tabela EARS + RFC 2119 |
| 4 | Requisitos de Qualidade | Saída de `requisito-ears` — tabela RNFs com métricas |
| 5 | Interfaces Externas e Glossário | `documentos-tecnicos/02-requisitos/02.3-restricoes.md` + `documentos-tecnicos/02-requisitos/02.5-glossario.md` |
| 6 | Matriz de Rastreabilidade | Cruzamento: objetivos M1 → RF/RNF → spec → test |

**Seção 1 — Introdução:**
- 1.1 Objetivo: problema resolvido, usuários-alvo, contexto geral (de `documentos-tecnicos/01-visao/01-visao-produto.md`)
- 1.2 Definições e Abreviações: RF, RNF, DEVE, DEVERIA, PODE, EARS, IREB, etc.
- 1.3 Referências: artefatos de entrada + norma ISO/IEC/IEEE 29148

**Seção 2 — Descrição Geral:**
- 2.1 Contexto: diagrama textual de fronteira ("o sistema X interage com Y por meio de Z")
- 2.2 Stakeholders: tabela (papel + interesse + influência) de `documentos-tecnicos/01-visao/01-visao-produto.md`
- 2.3 Restrições de Design: `documentos-tecnicos/02-requisitos/02.3-restricoes.md` subtipos legal/técnica/organizacional/temporal
- 2.4 Premissas: `documentos-tecnicos/02-requisitos/02.4-premissas.md` com impacto se falsas; se ausente: "Nenhuma premissa formal registrada nesta fase"
- Se `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` existir: nota em 2.3 indicando conflitos detectados + status

**Seção 3 — Requisitos Funcionais:**
Inserir tabela EARS de `requisito-ears`. Organizar por módulo/processo se `documentos-tecnicos/01-visao/01-visao-produto.md` indicar agrupamentos naturais; caso contrário, manter ordem de IDs.

**Seção 4 — Requisitos de Qualidade:**
Inserir tabela RNFs de `requisito-ears`. Por RNF: ID | Bucket | Modal | Comportamento | Métrica | Critério de aceite.
Critério de aceite = condição verificável derivada da métrica (ex: "teste de carga com k6 sob 1000 req/s sem degradação > 10%").

**Seção 5 — Interfaces Externas e Glossário:**
- 5.1 Interfaces: APIs de terceiros, sistemas legados, dispositivos físicos de `documentos-tecnicos/02-requisitos/02.3-restricoes.md` ou `documentos-tecnicos/01-visao/01-visao-produto.md`; se nenhum: "Interfaces externas não identificadas nesta fase — detalhar em fase de design"
- 5.2 Glossário: conteúdo completo de `documentos-tecnicos/02-requisitos/02.5-glossario.md`

**Seção 6 — Matriz de Rastreabilidade:**
Tabela: Objetivo de negócio (M1) | RF/RNF | Spec (.feature) | Test
- Coluna spec: `documentos-tecnicos/03-documento/04-spec/<id>.feature` para RFs DEVE; N/A para DEVERIA/PODE
- Coluna test: N/A nesta fase (preenchida após Passo 4)

## Fase 2 — Verificação de Completude

Antes de salvar, verificar checklist:
- [ ] Todas as 6 seções presentes
- [ ] Contagem RFs na seção 3 == contagem em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`
- [ ] Contagem RNFs na seção 4 == contagem em `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`
- [ ] Seção 6 tem linha para cada RF e RNF

Se qualquer item `[ ]`: ⛔ STOP — corrigir antes de salvar.

## Fase 3 — Saída

Salvar como `documentos-tecnicos/03-documento/03-srs-completo.md` (tamanho esperado: 300–600 linhas conforme projeto).

Sinalizar ao `documenter`: srs-ireb-template concluído → prosseguir para `gherkin-spec` (Passo 3).

<!-- internal -->
## Anti-Padrão: Seção 6 Vazia Sem Flag

**Como acontece:** Não há dados suficientes para preencher a Seção 6 (rastreabilidade) porque spec/ ainda não existe neste passo. A skill gera a seção com 0 linhas e salva sem registrar a situação.

**Como detectar:** Seção 6 com 0 linhas de dados (só cabeçalho de tabela). Isso é normal neste passo — mas precisa ser explícito.

**O que fazer:** Seção 6 deve ter 1 linha por RF e RNF com coluna Spec = "a gerar (Passo 3)" e coluna Test = "N/A (Passo 4)". Nunca deixar a tabela de rastreabilidade completamente vazia — mesmo que os valores sejam N/A ou "a gerar".
<!-- /internal -->
