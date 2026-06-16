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
- `documentos-tecnicos/03-documento/03.3-diagramas.md` é opcional mas recomendado — se ausente, usar fallback textual para §2.1 e omitir o diagrama ER de §2.2. Os diagramas de caso de uso da §3 vêm dos RFs e **não** dependem deste arquivo (gerar sempre)
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
| 2 | Descrição Geral | `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.3-restricoes.md` + `documentos-tecnicos/02-requisitos/02.4-premissas.md` + diagrama de contexto + diagrama de estrutura de dados (ER) de `documentos-tecnicos/03-documento/03.3-diagramas.md` |
| 3 | Requisitos Funcionais | Saída de `requisito-ears` — tabela estruturada, agrupada por módulo + **um diagrama de caso de uso por módulo** (gerado na montagem a partir dos RFs do módulo) |
| 4 | Requisitos de Qualidade | Saída de `requisito-ears` — tabela RNFs com métricas |
| 5 | Interfaces Externas | `documentos-tecnicos/02-requisitos/02.3-restricoes.md` |
| 6 | Matriz de Rastreabilidade | Cruzamento: OBJ-NNN (M1) → RF/RNF → Seção SRS → Stakeholder origem |
| 7 | Conflitos Detectados e Resolvidos | `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` (condicional — só se existir) |
| 8 | Glossário | `documentos-tecnicos/02-requisitos/02.5-glossario.md` (conteúdo completo) |

**Moldura de diagrama (regra única — aplicar a TODO diagrama do SRS: contexto §2.1, ER §2.2 e os casos de uso por módulo em §3.X):**

Diagramas vindos de `documentos-tecnicos/03-documento/03.3-diagramas.md` (contexto, ER) trazem um heading próprio (`## N. Título`) e uma linha `> Destinado à Seção …`: ao embutir, **descartar os dois** (o `## N.` colidiria com a numeração de seção do SRS). Os diagramas de caso de uso por módulo são **gerados nesta montagem** (não há heading de origem a remover). Em ambos os casos, montar nesta ordem:

1. **Frase de introdução** em prosa (1 linha) — para contexto/ER, reaproveitar a descrição `> Mostra…` do bloco de origem (sem o `>`); para caso de uso por módulo, uma frase curta ("As situações de uso do módulo [Nome]:").
2. O **bloco ```mermaid** (apenas o conteúdo do diagrama).
3. **Legenda** em linha própria, em itálico: `_Figura N — <título limpo>._`

Numerar `Figura N` sequencialmente pela ordem no documento, contando **só as figuras efetivamente renderizadas**: Contexto = Figura 1 (§2.1) · Estrutura de Dados/ER = Figura 2 (§2.2) · depois **um diagrama por módulo** em §3.1, §3.2, … (Figura 3, Figura 4, …). Se o ER for omitido (nota de omissão), tudo desce 1 (o primeiro caso de uso vira Figura 2). Sem buracos na numeração.

**Seção 1 — Introdução:**
- 1.1 Objetivo: problema resolvido, usuários diretos do produto, contexto geral (de `documentos-tecnicos/01-visao/01-visao-produto.md`)
- 1.2 Referências: artefatos de entrada que compõem este documento

**Seção 2 — Descrição Geral:**
- 2.1 Contexto do Sistema: embutir o **diagrama de contexto** (bloco `## 1. Contexto do Sistema` de `documentos-tecnicos/03-documento/03.3-diagramas.md`) aplicando a **moldura** acima (Figura 1) — se `03.3-diagramas.md` não existir ou o bloco estiver ausente, usar descrição textual ("O sistema X interage com Y por meio de Z").
- 2.2 Estrutura de Dados: embutir o bloco cujo título seja `Estrutura de Dados (Entidade-Relacionamento)` de `documentos-tecnicos/03-documento/03.3-diagramas.md` — casar pelo **título**, não pelo número (a numeração do arquivo é dinâmica, então o ER pode estar em `## 3.`, `## 4.` etc.) — aplicando a **moldura** acima (Figura 2). **Esta subseção existe sempre**: se o bloco estiver ausente ou trouxer nota de omissão (glossário < 3 entidades), copiar a nota de omissão diretamente (não omitir em silêncio). O diagrama ER pertence à §2.2 e **nunca** deve aparecer na §6 (Matriz de Rastreabilidade).
- 2.3 Usuários do Produto: listar **somente os usuários diretos** (camada "Usa diretamente") da tabela `## 3. Pessoas Envolvidas` de `documentos-tecnicos/01-visao/01-visao-produto.md`. Formato: tabela Papel | Interesse | Influência.
- 2.4 Restrições de Design: `documentos-tecnicos/02-requisitos/02.3-restricoes.md` subtipos legal/técnica/organizacional/temporal
- 2.5 Premissas: `documentos-tecnicos/02-requisitos/02.4-premissas.md` com impacto se falsas; se ausente: "Nenhuma premissa formal registrada nesta fase"

**Seção 3 — Requisitos Funcionais:**

Organizar **sempre por módulo** (padrão). Lista plana só como fallback explícito (ver regra abaixo).

**Dois parágrafos introdutórios obrigatórios (nesta ordem, antes das subseções de módulo):**

Primeiro — como os requisitos são escritos (cita o padrão, lista os nomes, não define cada um):
> Os requisitos funcionais seguem o padrão **EARS** (Easy Approach to Requirements Syntax): cada requisito é uma frase estruturada que liga uma condição de ativação (quando/enquanto/se/onde, ou nenhuma) ao comportamento esperado do sistema. A coluna **Classificação** indica o padrão EARS de cada requisito — **Ubíquo**, **Evento**, **Estado**, **Indesejado** ou **Opcional**.

Segundo — organização em módulos e prioridade:
> O sistema foi dividido em grupos de funcionalidades relacionadas — chamados **módulos**. Cada módulo reúne as regras de uma área específica do produto. A coluna **Prioridade** classifica cada regra como **Essencial** (obrigatória nesta versão), **Importante** (recomendada, com alternativa temporária) ou **Desejável** (bom ter, postergável). O verbo de obrigatoriedade (`DEVE`/`DEVERIA`/`PODE`) está embutido na própria frase de cada requisito.

**NÃO inserir legenda de prioridade (MoSCoW).** Os dois parágrafos introdutórios acima já explicam Essencial/Importante/Desejável. Ao copiar as tabelas de `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, **descartar** qualquer linha iniciada por `> **Legenda de prioridade` — ela não entra no SRS.

**Diagrama de caso de uso — UM POR MÓDULO (gerado nesta skill):**

A §3 **não** traz um diagrama global. Cada subseção de módulo (§3.1, §3.2, …) recebe o seu próprio diagrama, posicionado **logo após o título do módulo, antes da tabela de RFs** daquele módulo.

> **Por que gerado aqui, e não em `modelagem-visual`?** O agrupamento por módulo só existe nesta skill (ver Algoritmo de agrupamento abaixo) — `modelagem-visual` roda antes e não conhece os módulos. O caso de uso **global** de `03.3-diagramas.md` segue servindo só ao resumo leigo do cliente; ele **não** é embutido na §3.

Para cada módulo, gerar um `flowchart LR` (atores à esquerda → funcionalidades à direita) seguindo o template do catálogo `content/catalogos-seed/conceitos/modelagem-visual.md §2`, com a **moldura** e estas regras:
- Incluir as funcionalidades **Essencial** e **Importante** daquele módulo. Rótulo = verbo + objeto, sem sintaxe EARS (ex.: "Cadastrar produto", não "O sistema DEVE permitir cadastrar produto").
- Ator = sujeito do RF (inferir do EARS; se ambíguo, usar o perfil principal do onion da §2.3).
- Legenda: `_Figura N — Casos de uso · [Módulo]._` — numerar na ordem do documento (Figura 3, 4, …).
- Módulo com 1 só funcionalidade: gerar mesmo assim (ator → 1 nó). Módulo "Geral" também recebe diagrama.
- Os dados vêm dos RFs, não de `03.3-diagramas.md` — gerar mesmo que o arquivo de diagramas não exista.

**Fallback de lista plana** (N_RF < 5, sem módulos — ver regra 5 abaixo): gerar **um único** diagrama de caso de uso global, antes da tabela única, com a moldura (Figura 3).

**Algoritmo de agrupamento (executar antes de inserir os RFs):**

1. **Extrair candidatos a módulo** de duas fontes em paralelo:
   - `documentos-tecnicos/01-visao/01-visao-produto.md` → funcionalidades-chave mencionadas, domínios de negócio citados
   - Lista de RFs → agrupar por verbo/objeto comum ("cadastrar/listar/editar produto" → Módulo Produtos; "autenticar/recuperar senha" → Módulo Acesso)

2. **Nomear módulos** em linguagem de negócio (não técnica):
   - ✅ "Módulo de Agendamento", "Módulo de Usuários", "Módulo de Relatórios"
   - ❌ "Auth Module", "CRUD de Pedidos", "Backend de Pagamentos"

3. **Atribuir cada RF ao módulo mais próximo.** RF que não encaixa em nenhum → módulo "Geral".

4. **Gerar seção 3 com subseções por módulo (um diagrama POR módulo):**
   ```markdown
   ## 3. Requisitos Funcionais

   > [parágrafo EARS aqui]

   > [parágrafo de módulos aqui]

   ### 3.1 Módulo de [Nome]

   As situações de uso do módulo [Nome]:
   [ diagrama mermaid: flowchart LR — atores → funcionalidades DESTE módulo ]
   _Figura 3 — Casos de uso · [Módulo]._

   | ID | Classificação | Requisito | Prioridade | Critério |
   |---|---|---|---|---|
   | RF-001 | Evento | Quando [evento], o sistema DEVE [verbo] [objeto] | Essencial | ... |

   ### 3.2 Módulo de [Nome]

   As situações de uso do módulo [Nome]:
   [ diagrama mermaid do módulo ]
   _Figura 4 — Casos de uso · [Módulo]._

   | ID | ...
   ```

5. **Fallback — lista plana:** usar SOMENTE se N_RF < 5 **E** não houver nenhum agrupamento natural identificável. Nesse caso: inserir tabela única com todos os RFs e registrar nota:
   > _Nota: menos de 5 requisitos funcionais identificados — agrupamento por módulo omitido._

**Seção 4 — Requisitos de Qualidade:**

**Parágrafo introdutório obrigatório (inserir antes da tabela):**
> Os requisitos de qualidade descrevem **como o sistema deve se comportar**, não o que faz. Estão agrupados por categoria (desempenho, segurança, disponibilidade, etc.) conforme a natureza do comportamento esperado.

> _O diagrama de estrutura de dados (ER) **não** pertence a esta seção — ele é embutido na §2.2 Estrutura de Dados. Não inserir nenhum diagrama na §4._

Inserir tabela RNFs de `requisito-ears`. Por RNF: ID | Categoria | Comportamento | Prioridade | Métrica | Critério de aceite. (O verbo de obrigatoriedade DEVE/DEVERIA/PODE vive embutido na frase da coluna "Comportamento" — sem coluna "Modal" separada.)
Critério de aceite = condição verificável derivada da métrica (ex: "teste de carga com k6 sob 1000 req/s sem degradação > 10%").

**NÃO inserir legenda de prioridade (MoSCoW)** nesta seção. A legenda em `02.x` é combinada RF+RNF e pode ser arrastada junto — ao copiar de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, descartar qualquer linha iniciada por `> **Legenda de prioridade`.

**Seção 5 — Interfaces Externas:**
- 5.1 Interfaces: APIs de terceiros, sistemas legados, dispositivos físicos de `documentos-tecnicos/02-requisitos/02.3-restricoes.md` ou `documentos-tecnicos/01-visao/01-visao-produto.md`; se nenhum: "Interfaces externas não identificadas nesta fase — detalhar em fase de design"

**Seção 6 — Matriz de Rastreabilidade:**
Tabela: `OBJ-NNN` (objetivo de negócio com ID) | RF/RNF | Seção SRS | Stakeholder origem
- IDs de objetivo: derivados de `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` (ou rederivados se arquivo ainda não existir — ver `rastreabilidade-matriz`)
- Esboço nesta fase — a matriz completa com análise de gaps é gerada pelo checker em `03.2-rastreabilidade.md` e entregue como **Apêndice A — Matriz de Rastreabilidade**
- **Após a tabela**, inserir a frase de remissão em linha própria (itálico):
  > _A versão completa, com a análise de lacunas, encontra-se no **Apêndice A — Matriz de Rastreabilidade**._

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
- [ ] Nenhuma linha "Legenda de prioridade (MoSCoW)" presente no documento (§3 e §4)
- [ ] Seção 6 tem linha para cada RF e RNF
- [ ] Seção 8 (Glossário) presente com ao menos 1 verbete
- [ ] Diagrama de contexto embutido em §2.1 (ou nota de fallback)
- [ ] Diagrama de estrutura de dados (ER) embutido em §2.2 (ou nota de omissão)
- [ ] Nenhum diagrama na §4 (o ER vive em §2.2)
- [ ] Cada módulo de §3 (§3.1, §3.2, …) tem o seu diagrama de caso de uso — ou, no fallback de lista plana, um diagrama único
- [ ] Nenhum diagrama de caso de uso GLOBAL embutido na §3 (o global serve só ao resumo leigo)
- [ ] Cada diagrama tem frase de introdução + legenda "Figura N", sem heading órfão `## N.`
- [ ] Numeração `Figura N` sequencial e sem buracos — se o ER (§2.2) foi omitido, o primeiro caso de uso é Figura 2 (não Figura 3)

Se qualquer item `[ ]`: ⛔ STOP — corrigir antes de salvar.

## Fase 4 — Saída

Salvar como `documentos-tecnicos/03-documento/03-srs-completo.md` (tamanho esperado: 400–700 linhas conforme projeto).

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("traducao-gate")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Seção 6 Vazia Sem Flag

**Como acontece:** Não há dados suficientes para preencher a Seção 6 (rastreabilidade) porque a matriz completa ainda não foi gerada pelo checker. A skill gera a seção com 0 linhas e salva sem registrar a situação.

**Como detectar:** Seção 6 com 0 linhas de dados (só cabeçalho de tabela). Isso é normal neste passo — mas precisa ser explícito.

**O que fazer:** Seção 6 deve ter 1 linha por RF e RNF com coluna Stakeholder preenchida e a remissão "a versão completa, com análise de lacunas, encontra-se no Apêndice A — Matriz de Rastreabilidade (gerada na validação)". Nunca deixar a tabela de rastreabilidade completamente vazia.
<!-- /internal -->
