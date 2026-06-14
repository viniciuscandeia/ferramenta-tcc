---
name: srs-ireb-montagem
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M3]
description: >-
  Monta o documento completo de especificação do produto com 8 seções — consumindo todos os artefatos produzidos até aqui.
  Use no Marco 3, após formatar os requisitos com padrão de condição e gerar os diagramas, para produzir o documento normativo final.
  Assemble SRS-completo.md; 8 sections (6 obrigatórias + §7 conflitos condicional + §8 glossário); no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de completude** — as seções 1–6 e 8 são obrigatórias; §7 é condicional (só se há conflitos). Seção sem dados suficientes recebe placeholder explícito ("Nenhum identificado nesta fase") — nunca é omitida silenciosamente.
2. **Zero omissão silenciosa.** Contagem de RFs na seção 3 == contagem em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`. Contagem de RNFs na seção 4 == contagem em `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`. Divergência = erro de geração.
3. **Esta skill não gera versão leigo.** Responsabilidade exclusiva de `traducao-gate` (Passo 7 do documenter). Misturar as duas versões aqui contamina o fluxo de aprovação do Gate 3.

<HARD-GATE>
- NÃO executar antes de `requisito-ears` e `modelagem-visual` concluídos (diagramas são embutidos neste passo)
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/02-requisitos/02.3-restricoes.md`, `documentos-tecnicos/02-requisitos/02.5-glossario.md` — artefatos obrigatórios
- `documentos-tecnicos/03-documento/03.3-diagramas.md` é opcional mas recomendado — se ausente, usar fallback textual para §2.1 e omitir diagramas de §3 e §4
- ⛔ STOP se checklist de completude final falhar (seção ausente ou contagem divergente)
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar todos os artefatos obrigatórios existem
3. Carregar artefatos opcionais se existirem: `documentos-tecnicos/02-requisitos/02.4-premissas.md`, `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md`
4. Contar RFs e RNFs de entrada para verificação de completude

## Fase 1 — Cabeçalho de Controle de Versão

Antes de qualquer seção, inserir o cabeçalho de controle de versão do documento:

```markdown
# [Nome do Produto] — Especificação de Requisitos de Software

**Gerado por:** Assistente de Especificação de Software  

> Ver Glossário na Seção 8.

---

## Controle de Versão

| Versão | Data | Responsável | Descrição da Revisão |
|---|---|---|---|
| 1.0 | [DATA-GERAÇÃO] | Assistente de Especificação de Software | Versão inicial — gerada automaticamente via elicitação estruturada |

> Versões subsequentes registradas aqui após cada ciclo de revisão.

---
```

Preencher `[DATA-GERAÇÃO]` com a data atual no formato `YYYY-MM-DD`.

## Fase 2 — Montagem das 6 Seções

**Mapeamento de fontes:**

| Seção | Título | Fonte |
|---|---|---|
| 1 | Introdução | `documentos-tecnicos/01-visao/01-visao-produto.md` (M1) |
| 2 | Descrição Geral | `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.3-restricoes.md` + `documentos-tecnicos/02-requisitos/02.4-premissas.md` + diagrama de contexto de `documentos-tecnicos/03-documento/03.3-diagramas.md` |
| 3 | Requisitos Funcionais | Saída de `requisito-ears` — tabela estruturada, agrupada por módulo + diagrama de caso de uso de `03.3-diagramas.md` |
| 4 | Requisitos de Qualidade | Saída de `requisito-ears` — tabela RNFs com métricas + diagrama ER de `03.3-diagramas.md` (se existir) |
| 5 | Interfaces Externas | `documentos-tecnicos/02-requisitos/02.3-restricoes.md` |
| 6 | Matriz de Rastreabilidade | Cruzamento: OBJ-NNN (M1) → RF/RNF → spec → test |
| 7 | Conflitos Detectados e Resolvidos | `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` (condicional — só se existir) |
| 8 | Glossário | `documentos-tecnicos/02-requisitos/02.5-glossario.md` (conteúdo completo) |

**Seção 1 — Introdução:**
- 1.1 Objetivo: problema resolvido, usuários diretos do produto, contexto geral (de `documentos-tecnicos/01-visao/01-visao-produto.md`)
- 1.2 Referências: artefatos de entrada que compõem este documento

**Seção 2 — Descrição Geral:**
- 2.1 Contexto do Sistema: embutir o **diagrama de contexto** (bloco `## 1. Contexto do Sistema` de `documentos-tecnicos/03-documento/03.3-diagramas.md`) — se `03.3-diagramas.md` não existir ou o bloco estiver ausente, usar descrição textual ("O sistema X interage com Y por meio de Z").
- 2.2 Usuários do Produto: listar **somente os usuários diretos** (camada "Usa diretamente") da tabela `## 3. Pessoas Envolvidas` de `documentos-tecnicos/01-visao/01-visao-produto.md`. Formato: tabela Papel | Interesse | Influência.
- 2.3 Restrições de Design: `documentos-tecnicos/02-requisitos/02.3-restricoes.md` subtipos legal/técnica/organizacional/temporal
- 2.4 Premissas: `documentos-tecnicos/02-requisitos/02.4-premissas.md` com impacto se falsas; se ausente: "Nenhuma premissa formal registrada nesta fase"

**Seção 3 — Requisitos Funcionais:**

Organizar **sempre por módulo** (padrão). Lista plana só como fallback explícito (ver regra abaixo).

**Parágrafo introdutório obrigatório (inserir antes das subseções de módulo):**
> O sistema foi dividido em grupos de funcionalidades relacionadas — chamados **módulos**. Cada módulo reúne as regras de uma área específica do produto. A coluna **Prioridade** classifica cada regra como **Essencial** (obrigatória nesta versão), **Importante** (recomendada, com alternativa temporária) ou **Desejável** (bom ter, postergável). O verbo de obrigatoriedade (`DEVE`/`DEVERIA`/`PODE`) está embutido na própria frase de cada requisito.

**Diagrama de caso de uso (inserir após o parágrafo introdutório, antes das tabelas):**
Embutir o bloco `## 2. Caso de Uso — O que o Sistema Faz` de `documentos-tecnicos/03-documento/03.3-diagramas.md`.  
Se `03.3-diagramas.md` não existir ou o bloco estiver ausente → omitir sem erro.

**Algoritmo de agrupamento (executar antes de inserir os RFs):**

1. **Extrair candidatos a módulo** de duas fontes em paralelo:
   - `documentos-tecnicos/01-visao/01-visao-produto.md` → funcionalidades-chave mencionadas, domínios de negócio citados
   - Lista de RFs → agrupar por verbo/objeto comum ("cadastrar/listar/editar produto" → Módulo Produtos; "autenticar/recuperar senha" → Módulo Acesso)

2. **Nomear módulos** em linguagem de negócio (não técnica):
   - ✅ "Módulo de Agendamento", "Módulo de Usuários", "Módulo de Relatórios"
   - ❌ "Auth Module", "CRUD de Pedidos", "Backend de Pagamentos"

3. **Atribuir cada RF ao módulo mais próximo.** RF que não encaixa em nenhum → módulo "Geral".

4. **Gerar seção 3 com subseções por módulo:**
   ```markdown
   ## 3. Requisitos Funcionais

   > [parágrafo introdutório aqui]

   [diagrama de caso de uso aqui]

   ### 3.1 Módulo de [Nome]
   | ID | Tipo-EARS | Requisito (frase EARS) | Prioridade | Critério |
   |---|---|---|---|---|
   | RF-001 | Evento | Quando [evento], o sistema DEVE [verbo] [objeto] | Essencial | ... |

   ### 3.2 Módulo de [Nome]
   | ID | ...
   ```
   > **Legenda de prioridade (MoSCoW):** Essencial (Must) · Importante (Should) · Desejável (Could) · Fora desta versão (Won't). Inserir esta legenda uma vez, logo após o parágrafo introdutório de §3.

5. **Fallback — lista plana:** usar SOMENTE se N_RF < 5 **E** não houver nenhum agrupamento natural identificável. Nesse caso: inserir tabela única com todos os RFs e registrar nota:
   > _Nota: menos de 5 requisitos funcionais identificados — agrupamento por módulo omitido._

**Seção 4 — Requisitos de Qualidade:**

**Parágrafo introdutório obrigatório (inserir antes da tabela):**
> Os requisitos de qualidade descrevem **como o sistema deve se comportar**, não o que faz. Estão agrupados por categoria (desempenho, segurança, disponibilidade, etc.) conforme a natureza do comportamento esperado.

**Diagrama ER (inserir após o parágrafo introdutório, se existir):**
Embutir o bloco `## 4. Estrutura de Dados (Entidade-Relacionamento)` de `documentos-tecnicos/03-documento/03.3-diagramas.md`.  
Se o bloco estiver ausente ou com nota de omissão → copiar a nota de omissão diretamente (não omitir em silêncio).

Inserir tabela RNFs de `requisito-ears`. Por RNF: ID | Bucket | Comportamento (frase, com DEVE/DEVERIA/PODE embutido) | Prioridade | Métrica | Critério de aceite. (Sem coluna "Modal" — o verbo de obrigatoriedade vive na frase do comportamento. Repetir a legenda de prioridade MoSCoW, se útil.)
Critério de aceite = condição verificável derivada da métrica (ex: "teste de carga com k6 sob 1000 req/s sem degradação > 10%").

**Seção 5 — Interfaces Externas:**
- 5.1 Interfaces: APIs de terceiros, sistemas legados, dispositivos físicos de `documentos-tecnicos/02-requisitos/02.3-restricoes.md` ou `documentos-tecnicos/01-visao/01-visao-produto.md`; se nenhum: "Interfaces externas não identificadas nesta fase — detalhar em fase de design"

**Seção 6 — Matriz de Rastreabilidade:**
Tabela: `OBJ-NNN` (objetivo de negócio com ID) | RF/RNF | Seção SRS | Stakeholder origem
- IDs de objetivo: derivados de `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` (ou rederivados se arquivo ainda não existir — ver `rastreabilidade-matriz`)
- Esboço nesta fase — a matriz completa com análise de gaps é gerada pelo checker em `03.2-rastreabilidade.md`

**Seção 7 — Conflitos Detectados e Resolvidos:**
Incluir **somente se** `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` existir.
- Copiar o conteúdo completo de `02.7-conflitos-detectados.md` como seção 7
- Título da seção: `## 7. Conflitos Detectados e Resolvidos`
- Se o arquivo não existir: omitir a seção inteiramente (sem placeholder)

**Seção 8 — Glossário:**
- Título da seção: `## 8. Glossário`
- Conteúdo completo de `documentos-tecnicos/02-requisitos/02.5-glossario.md` (copiar integralmente)
- Esta é a **única** ocorrência do glossário no documento — não duplicar em §1

## Fase 3 — Verificação de Completude

Antes de salvar, verificar checklist:
- [ ] Seções 1–6 obrigatórias presentes (§7 condicional, §8 obrigatória)
- [ ] Contagem RFs na seção 3 == contagem em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`
- [ ] Contagem RNFs na seção 4 == contagem em `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`
- [ ] Seção 6 tem linha para cada RF e RNF
- [ ] Seção 8 (Glossário) presente com ao menos 1 verbete
- [ ] Diagrama de contexto embutido em §2.1 (ou nota de fallback)
- [ ] Diagrama de caso de uso embutido em §3 (ou nota de fallback)

Se qualquer item `[ ]`: ⛔ STOP — corrigir antes de salvar.

## Fase 4 — Saída

Salvar como `documentos-tecnicos/03-documento/03-srs-completo.md` (tamanho esperado: 400–700 linhas conforme projeto).

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("traducao-gate")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Seção 6 Vazia Sem Flag

**Como acontece:** Não há dados suficientes para preencher a Seção 6 (rastreabilidade) porque a matriz completa ainda não foi gerada pelo checker. A skill gera a seção com 0 linhas e salva sem registrar a situação.

**Como detectar:** Seção 6 com 0 linhas de dados (só cabeçalho de tabela). Isso é normal neste passo — mas precisa ser explícito.

**O que fazer:** Seção 6 deve ter 1 linha por RF e RNF com coluna Stakeholder preenchida e nota "matriz completa com análise de gaps em 03.2-rastreabilidade.md (gerada na validação)". Nunca deixar a tabela de rastreabilidade completamente vazia.
<!-- /internal -->
