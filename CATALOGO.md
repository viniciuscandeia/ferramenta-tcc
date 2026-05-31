# Catálogo da Ferramenta — TCC Elicitação de Requisitos

**Arquitetura:** 1 orquestrador + 5 sub-agentes + 27 skills + 3 workflows  
**Canon arquitetural:** `docs/planejamento/3 - Arquitetura da Ferramenta.md`  
**Constituição (guardrails runtime):** `content/constitution.md`

---

## Visão geral — quem faz o quê por marco

| Marco | Sub-agente(s) | Skills ativas | Gate |
|---|---|---|---|
| M1 — Definição da Necessidade | `stakeholder-identifier` | necessidade-visao, stakeholder-mapping, contexto-e-limite, clarificacao-pos-visao¹, traducao-gate, traducao-leigo | Gate 1: usuário aprova `documentos-para-leigo/01-visao/01-visao-produto.md` |
| M2 — Consenso de Escopo | `collector` ⇄ `modeler` (loop) | entrevista-estruturada, cenario-narrativa, recomendacao-dominio, recomendacao-implicitos, questionario-feixe¹, classificacao-rf-rnf, priorizacao, glossario, conflitos-detect, pautas-reelicitacao, traducao-gate, traducao-leigo | Gate 2: aprova versões leigo dos artefatos + `pautas-reelicitacao.md` sem pendências |
| M3 — Detalhamento | `documenter` ⇄ `checker` (loop) | requisito-ears, srs-ireb-template, gherkin-spec, step-defs-red, testing-strategy, readme-tests, validacao-checklist-ireb, analyze-cross-artifact, rastreabilidade-matriz, traducao-gate, traducao-leigo | Gate 3: aprova SRS leigo + `analyze-report.md` sem CRITICAL |
| M4 — Revisão Técnica (opcional) | `checker` modo técnico | (internamente: validacao-checklist-ireb) | Gate 4: dev/tech lead aprova `aprovacao-tecnica.md` |

¹ Skill condicional — ver `when_to_use`.

---

## Orquestrador

**Arquivo:** `content/orchestrator.md`

**Papel:** Entry-point único da ferramenta. Ativado pelo comando `/iniciar-projeto`.  
**Responsabilidades:** Ler `content/constitution.md` + `estado-projeto.yaml`, rotear para o sub-agente do marco corrente, gerenciar 4 gates, acionar detection-based recovery (D10) se `estado-projeto.yaml` ausente.

---

## Sub-agentes

### stakeholder-identifier

**Arquivo:** `agents/stakeholder-identifier.md`  
**Marco:** M1 — Definição da Necessidade  
**Papel:** Conduz o usuário leigo pela definição completa da necessidade — problema/necessidade (5-Whys/JTBD), visão (Moore), metas, stakeholders (Onion) e contexto/limite. Único agente ativo em M1 (sem loop).  
**Workflow:** `content/workflows/m1-visao.md`  
**Skills que invoca:** `necessidade-visao` → `stakeholder-mapping` → `contexto-e-limite` → `clarificacao-pos-visao` (condicional) → `traducao-gate` + `traducao-leigo` (transversal)

---

### collector

**Arquivo:** `agents/collector.md`  
**Marco:** M2 — Consenso de Escopo  
**Papel:** Elicitação ativa — Fase A linear (5 rondas de coleta) e Fase B modo focado (resolve pautas de `pautas-reelicitacao.md`).  
**Workflow:** `content/workflows/m2-requisitos.md`  
**Skills que invoca:** `entrevista-estruturada` → `cenario-narrativa` → `recomendacao-dominio` → `recomendacao-implicitos` → `questionario-feixe` (condicional); na Fase B: skill-alvo indicada pela pauta

---

### modeler

**Arquivo:** `agents/modeler.md`  
**Marco:** M2 — Consenso de Escopo  
**Papel:** Modelagem — classifica RFs/RNFs/Restrições/Premissas, prioriza, constrói glossário, detecta conflitos e gera pautas de reelicitação. Determina se o loop M2 continua ou o Gate 2 pode abrir.  
**Workflow:** `content/workflows/m2-requisitos.md` (Fase B)  
**Skills que invoca:** `classificacao-rf-rnf` → `priorizacao` → `glossario` → `conflitos-detect` → `pautas-reelicitacao` + `traducao-gate` ao final

---

### documenter

**Arquivo:** `agents/documenter.md`  
**Marco:** M3 — Detalhamento  
**Papel:** Geração dos 5 outputs finais (SRS + Gherkin specs + step defs RED + TESTING-STRATEGY + README-TESTS). No loop M3, recebe `analyze-report.md` com CRITICAL e reexecuta apenas as skills afetadas.  
**Workflow:** `content/workflows/m3-srs-specs-tests.md` (Fase A)  
**Skills que invoca:** `requisito-ears` → `srs-ireb-template` → `gherkin-spec` → `step-defs-red` → `testing-strategy` → `readme-tests` → `traducao-gate` (SRS)

---

### checker

**Arquivo:** `agents/checker.md`  
**Marcos:** M3 (loop validação) + M4 (revisão técnica stub — opcional)  
**Papel M3:** Valida o SRS e artefatos do documenter — aplica IREB §3.8, faz analyze cross-artifact e gera `analyze-report.md`. CRITICAL bloqueia Gate 3 e reinicia o loop.  
**Papel M4:** Gera `revisao-tecnica.md` (checklist técnico) + apresenta `aprovacao-tecnica.md` ao dev/tech lead via yesno.  
**Workflow:** `content/workflows/m3-srs-specs-tests.md` (Fase B)  
**Skills que invoca:** `validacao-checklist-ireb` → `analyze-cross-artifact` → `rastreabilidade-matriz`

---

## Workflows

### m1-visao

**Arquivo:** `content/workflows/m1-visao.md`  
**Sub-agente responsável:** `stakeholder-identifier`  
**Entrada:** Projeto novo ou retomada de M1 incompleto  
**Saída:** `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-para-leigo/01-visao/01-visao-produto.md`  
**Gate de saída:** Gate 1 — usuário aprova versão leigo

---

### m2-requisitos

**Arquivo:** `content/workflows/m2-requisitos.md`  
**Sub-agentes responsáveis:** `collector` (Fase A) → `modeler` (Fase B, loop)  
**Entrada:** `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-para-leigo/01-visao/01-visao-produto.md` (aprovados pelo Gate 1)  
**Saída:** `03.1-funcionais.md` + `03.2-qualidade.md` + `03.3-restricoes.md` + `glossario.md` + `pautas-reelicitacao.md` + versões leigo dos 3 primeiros + condicionais (`03.4-premissas.md`, `conflitos-detectados.md`)  
**Gate de saída:** Gate 2 — usuário aprova versões leigo; `pautas-reelicitacao.md` sem pendências abertas

---

### m3-srs-specs-tests

**Arquivo:** `content/workflows/m3-srs-specs-tests.md`  
**Sub-agentes responsáveis:** `documenter` (Fase A) → `checker` (Fase B, loop de validação)  
**Entrada:** artefatos M1 aprovados (Gate 1) + artefatos M2 aprovados (Gate 2)  
**Saída:** `SRS-completo.md` + `SRS-completo-leigo.md` + `spec/*.feature` + `spec/_skipped.md` + `tests/unit/` + `tests/acceptance/` + `TESTING-STRATEGY.md` + `README-TESTS.md` + `analyze-report.md` + `rastreabilidade.md`  
**Gate de saída:** Gate 3 — usuário aprova `SRS-completo-leigo.md`; `analyze-report.md` sem issues CRITICAL

---

## Skills

### Transversais (2)

---

#### traducao-leigo

**Arquivo:** `skills/traducao-leigo/SKILL.md`

**Descrição:** Verifica e reescreve texto para remover jargão técnico de ER, garantindo que o usuário leigo não receba termos da blacklist D1. Invocada por qualquer agente antes de apresentar texto ao usuário.

**Quando usar:** Antes de qualquer exibição de texto ao usuário — perguntas, resumos, artefatos, confirmações.

---

#### traducao-gate

**Arquivo:** `skills/traducao-gate/SKILL.md`

**Descrição:** Gera duas versões de um artefato de gate — versão normativa (IREB §3.3.3 + EARS + RFC 2119) e versão leigo (linguagem de negócio). O usuário aprova apenas a versão leigo; a equipe técnica recebe a versão normativa.

**Quando usar:** Ao final de cada marco (M1, M2, M3) antes de apresentar artefatos ao usuário para aprovação no gate.

---

### M1 — Definição da Necessidade (5)

---

#### necessidade-visao *(v0.7.0 — substitui vision-box + situacao-problema)*

**Arquivo:** `skills/necessidade-visao/SKILL.md`

**Descrição:** Captura a necessidade central e a visão do produto em abordagem problema-primeiro (5-Whys/JTBD). Descobre a dor raiz antes de qualquer solução, depois sintetiza frase Moore e metas de sucesso. Produz Seções 1, 2 e 3 do Documento de Visão ISO 29148.

**Quando usar:** Primeira skill do Marco 1, sempre. Uma pergunta adaptativa por turno na fase de descoberta; síntese confirmada em choice (nunca perguntada a frio).

---

#### ~~vision-box~~ *(removida v0.7.0 — ver `necessidade-visao`)*

---

#### ~~situacao-problema~~ *(removida v0.7.0 — ver `necessidade-visao`)*

---

#### stakeholder-mapping *(reformada v0.7.0 — Stakeholder Onion)*

**Arquivo:** `skills/stakeholder-mapping/SKILL.md`

**Descrição:** Identifica e mapeia as pessoas envolvidas usando o modelo Stakeholder Onion (6 camadas: usa/decide-paga/mantém-suporta/afetado/regula/adversário). Inclui colunas de Interesse, Influência e Decisor. Sondagem regulatória proativa para domínios sensíveis. Produz Seção 4 do Documento de Visão.

**Quando usar:** Segunda skill do Marco 1, após `necessidade-visao`. Pré-extrai pessoas já mencionadas — não re-pergunta quem já foi nomeado.

---

#### contexto-e-limite

**Arquivo:** `skills/contexto-e-limite/SKILL.md`

**Descrição:** Define o que está fora do produto e as restrições conhecidas. O que está dentro é INFERIDO das skills anteriores e confirmado em choice — não re-perguntado. Persiste `lacunas_m1` em `estado-projeto.yaml` para controle determinístico do D16. Produz Seção 5 do Documento de Visão.

**Quando usar:** Terceira skill do Marco 1, após `stakeholder-mapping`. Última skill antes de `clarificacao-pos-visao` (condicional).

---

#### clarificacao-pos-visao

**Arquivo:** `skills/clarificacao-pos-visao/SKILL.md`

**Descrição:** Micro-fase condicional após o Marco 1 — resolve lacunas críticas detectadas por `contexto-e-limite` (lidas de `estado-projeto.yaml → lacunas_m1`). Ativada apenas se `lacunas_m1.contagem ≥ 2`. Máx 3 perguntas fechadas (choice/yesno) em 1 chamada. Usa dados reais do projeto — sem placeholders genéricos.

**Quando usar:** Apenas se `estado-projeto.yaml → lacunas_m1.contagem ≥ 2` (D16). Pode ser re-ativada no loop Gate-1 "Não" sem guarda de idempotência.

---

### M2 — collector: Elicitação (5)

---

#### entrevista-estruturada

**Arquivo:** `skills/entrevista-estruturada/SKILL.md`

**Descrição:** Conduz entrevista estruturada com o usuário leigo usando 4 perguntas-âncora baseadas em IREB §4.2 (entrevistas) e Pohl, K. "Requirements Engineering" (2010) §22. Coleta rotina, frustrações, visão ideal e restrições percebidas. Saída: seção de elicitacao-raw.md.

**Quando usar:** Invocada pelo collector na Ronda 1 da Fase A (sempre) ou na Fase B quando skill-alvo de uma pauta. Única chamada AskUserQuestion com exatamente 4 perguntas (ou menos se foco em pauta específica).

---

#### cenario-narrativa

**Arquivo:** `skills/cenario-narrativa/SKILL.md`

**Descrição:** Solicita ao usuário 1–2 cenários narrativos "um dia normal de [perfil]" e extrai RFs candidatos implícitos do texto. Baseado em IREB §4.3 (cenários como técnica de elicitação) e Robertson & Robertson "Mastering the Requirements Process" 3rd ed. (2012) cap. 9. Saída: cenários + RFs candidatos em elicitacao-raw.md.

**Quando usar:** Invocada pelo collector na Ronda 2 da Fase A. Sempre executar após entrevista-estruturada. Única chamada AskUserQuestion com 1–2 perguntas de texto livre.

---

#### recomendacao-dominio

**Arquivo:** `skills/recomendacao-dominio/SKILL.md`

**Descrição:** Detecta o domínio do projeto a partir de `documentos-tecnicos/01-visao/01-visao-produto.md` (matching contra 5 catálogos de domínio), confirma com o usuário e faz 4 perguntas sobre seções do catálogo. Saída: RFs/RNFs/restrições confirmados em elicitacao-raw.md.

**Quando usar:** Invocada pelo collector na Ronda 3 da Fase A. Sempre executar após cenario-narrativa. Duas chamadas AskUserQuestion: 1 yesno/choice para confirmar domínio + 1 lote de 4 perguntas.

---

#### recomendacao-implicitos

**Arquivo:** `skills/recomendacao-implicitos/SKILL.md`

**Descrição:** Sugere RFs/RNFs implícitos (o "óbvio não-dito") usando os catálogos rfs-tipicos.md e rnfs-tipicos.md com algoritmo de filtragem em 3 camadas (D-S4.3) para produzir 5–10 candidatos em vez de 38. Confirma com o usuário em 1 lote de 4 perguntas. Referência: Vazquez & Simões (2016) §4.4.

**Quando usar:** Invocada pelo collector na Ronda 4 da Fase A. Sempre executar após recomendacao-dominio. 1 chamada AskUserQuestion com até 4 perguntas de confirmação.

---

#### questionario-feixe

**Arquivo:** `skills/questionario-feixe/SKILL.md`

**Descrição:** Skill condicional — agrupa perguntas de detalhamento por tema (feixes) para cobrir áreas do sistema sem cobertura após as Rondas 1–4. Ativa apenas se ≥ 3 áreas com lacunas de detalhamento. Máximo 2 feixes (2 chamadas AskUserQuestion de 4 perguntas cada).

**Quando usar:** Invocada pelo collector na Ronda 5 da Fase A SOMENTE SE ≥ 3 áreas do sistema ainda não têm detalhamento claro após entrevista-estruturada + cenario-narrativa + recomendacao-dominio + recomendacao-implicitos.

---

### M2 — modeler: Classificação e Modelagem (5)

---

#### classificacao-rf-rnf

**Arquivo:** `skills/classificacao-rf-rnf/SKILL.md`

**Descrição:** Classifica itens de elicitacao-raw.md nos tipos RF (o que faz), RNF (como se comporta), Restrição (escolha imposta) e Premissa (pressuposto aceito). Gera rascunhos de 03.1-funcionais.md, 03.2-qualidade.md, 03.3-restricoes.md e 03.4-premissas.md (condicional). Segue IREB §1.1 e 9 buckets Wiegers Ch7.

**Quando usar:** Invocada pelo modeler no Passo 1 da Fase B do workflow M2. Entrada obrigatória: elicitacao-raw.md completo.

---

#### priorizacao

**Arquivo:** `skills/priorizacao/SKILL.md`

**Descrição:** Atribui modal RFC 2119 (DEVE/DEVERIA/PODE) e campo de prioridade de negócio a cada RF e RNF classificado. Usa MoSCoW como base obrigatória; aciona Kano e IEEE como sub-rotinas automáticas conforme gatilhos (D9). Usuário nunca vê os nomes das técnicas.

**Quando usar:** Invocada pelo modeler no Passo 2 da Fase B após classificacao-rf-rnf. Entrada: rascunhos de 03.1-funcionais.md e 03.2-qualidade.md.

---

#### glossario

**Arquivo:** `skills/glossario/SKILL.md`

**Descrição:** Detecta termos do domínio usados pelo usuário sem definição clara e constrói glossario.md com definição, exemplos e sinônimos. Previne ambiguidade nos artefatos M2 e M3. Referência: Wiegers Ch11 (anti-ambiguidade).

**Quando usar:** Invocada pelo modeler no Passo 3 da Fase B. Entrada: elicitacao-raw.md + rascunhos M2. Sem interação com usuário — opera sobre texto já coletado.

---

#### conflitos-detect

**Arquivo:** `skills/conflitos-detect/SKILL.md`

**Descrição:** Detecta conflitos entre requisitos ou stakeholders usando os 6 tipos IREB §4.4 e propõe estratégias de resolução. Gera conflitos-detectados.md apenas se ≥ 1 conflito encontrado. Versão M2 foca em duplicatas, contradições escopo-limite e conflitos entre stakeholders — expansão completa em M3 via analyze-cross-artifact.

**Quando usar:** Invocada pelo modeler no Passo 4 da Fase B. Sempre executar, mas só criar arquivo de saída se ≥ 1 conflito. Sem interação com usuário.

---

#### pautas-reelicitacao

**Arquivo:** `skills/pautas-reelicitacao/SKILL.md`

**Descrição:** Identifica lacunas nos artefatos M2 que impedem avanço para Gate 2 e gera pautas-reelicitacao.md com checkboxes e skill-alvo para resolução. Arquivo vazio = Gate 2 pode abrir. Referência: Vazquez & Simões (2016) cap. 8 Fig. 8.3.

**Quando usar:** Invocada pelo modeler no Passo 5 da Fase B. Determina se o loop collector⇄modeler deve continuar. Sem interação com usuário.

---

### M3 — documenter: Geração de Artefatos (6)

---

#### requisito-ears

**Arquivo:** `skills/requisito-ears/SKILL.md`

**Descrição:** Formata todos os RFs e RNFs de M2 com sintaxe EARS (5 padrões) e modais RFC 2119 (DEVE/DEVERIA/PODE), gerando tabela estruturada com colunas: ID | Tipo-EARS | Sujeito | Modal | Verbo | Objeto | Condição | Modal-original. Base para srs-ireb-template e gherkin-spec.

**Quando usar:** Invocada pelo documenter como Passo 1 do Processo M3. Entrada obrigatória: 03.1-funcionais.md e 03.2-qualidade.md com campos modal RFC 2119 já atribuídos pela skill priorizacao (M2).

---

#### srs-ireb-template

**Arquivo:** `skills/srs-ireb-template/SKILL.md`

**Descrição:** Monta o SRS-completo.md com as 6 seções IREB §3.3.3 (ISO/IEC/IEEE 29148), consumindo todos os artefatos M1+M2 e a saída formatada de requisito-ears. Seção 3 com RFs EARS+RFC2119; seção 4 com RNFs mensuráveis; seção 5 com restrições+premissas+glossário; seção 6 com rastreabilidade. Não gera versão leigo (traducao-gate faz isso no Passo 7 do documenter).

**Quando usar:** Invocada pelo documenter como Passo 2 do Processo M3. Depende de requisito-ears (Passo 1) ter executado primeiro.

---

#### gherkin-spec

**Arquivo:** `skills/gherkin-spec/SKILL.md`

**Descrição:** Gera arquivos .feature Gherkin para cada RF com modal DEVE (RFC 2119 MUST). RFs com modal DEVERIA ou PODE são listados em spec/_skipped.md com justificativa. 1 arquivo .feature por RF-DEVE com nome `<id-rf>-<slug-descricao>.feature`. Cada feature tem `Feature:` + ≥ 1 `Scenario` (caminho feliz) + até 2 Scenarios borda. Referências: D20, D22.

**Quando usar:** Invocada pelo documenter como Passo 3 do Processo M3. Depende de srs-ireb-template (Passo 2) ter executado. Entrada obrigatória: 03.1-funcionais.md com campo modal preenchido (DEVE/DEVERIA/PODE) pela priorizacao de M2.

---

#### step-defs-red

**Arquivo:** `skills/step-defs-red/SKILL.md`

**Descrição:** Gera arquivos de step definitions em estado RED (falham imediatamente — sem implementação real) para os 3 frameworks alvo: Pytest-BDD (Python), Cucumber-js (JavaScript/TypeScript) e SpecFlow (.NET C#). Lê spec/*.feature gerado por gherkin-spec e gera 1 step def file por .feature em cada framework. Estado RED garantido: `NotImplementedError` (Python), `throw new Error('PENDING')` (JS), `throw new PendingStepException()` (C#).

**Quando usar:** Invocada pelo documenter como Passo 4 do Processo M3. Depende de gherkin-spec (Passo 3) ter executado. Entrada: spec/*.feature. Saída: tests/unit/ e tests/acceptance/ com step defs RED em 3 frameworks.

---

#### testing-strategy

**Arquivo:** `skills/testing-strategy/SKILL.md`

**Descrição:** Gera TESTING-STRATEGY.md com 1 entrada por RNF de 03.2-qualidade.md. Cada entrada define: categoria do bucket Wiegers (Performance/Security/Usability/Reliability/Maintainability/Portability/Privacy+Compliance/Accessibility), ferramenta sugerida, métrica alvo, critério de aceite e framework de teste alvo. Referência: D21.

**Quando usar:** Invocada pelo documenter como Passo 5 do Processo M3. Entrada: 03.2-qualidade.md. Saída: TESTING-STRATEGY.md com entrada por RNF.

---

#### readme-tests

**Arquivo:** `skills/readme-tests/SKILL.md`

**Descrição:** Gera README-TESTS.md documentando como configurar e rodar os testes nos 3 frameworks: Pytest-BDD (Python), Cucumber-js (JavaScript/TypeScript) e SpecFlow (.NET C#). Cada seção inclui: pré-requisitos, comandos de instalação, comando para rodar todos os testes, comando para rodar teste específico, e estrutura de pastas esperada. Referência: D23.

**Quando usar:** Invocada pelo documenter como Passo 6 do Processo M3. Depende de step-defs-red (Passo 4) ter executado. Saída: README-TESTS.md na raiz do projeto.

---

### M3 — checker: Validação (3)

---

#### validacao-checklist-ireb

**Arquivo:** `skills/validacao-checklist-ireb/SKILL.md`

**Descrição:** Aplica os 12 critérios de qualidade IREB §3.8 sobre o SRS gerado pelo documenter — 6 critérios por requisito individual e 6 critérios por SRS como documento. Gera seção "Validação IREB §3.8" em analyze-report.md com 1 linha por violação (ID do critério + requisito afetado + severidade). Referência: content/catalogos-seed/conceitos/qualidade-e-validacao.md.

**Quando usar:** Invocada pelo checker no Passo 1 do Processo M3. Entrada: SRS-completo.md + 03.1-funcionais.md + 03.2-qualidade.md. Saída: seção em analyze-report.md (não arquivo separado).

---

#### analyze-cross-artifact

**Arquivo:** `skills/analyze-cross-artifact/SKILL.md`

**Descrição:** Valida consistência entre artefatos de diferentes marcos: Visão (M1) ↔ Elicitação (M2) ↔ SRS (M3) ↔ Specs (M3). Detecta 4 tipos de defeito (Omissão, Contradição, Superespecificação, Inexequibilidade) com severidades CRITICAL/HIGH/MEDIUM/LOW. CRITICAL bloqueia Gate 3. Referência: D17 + content/catalogos-seed/conceitos/qualidade-e-validacao.md §5.

**Quando usar:** Invocada pelo checker no Passo 2 do Processo M3. Depende de validacao-checklist-ireb (Passo 1) ter executado. Entrada: todos os artefatos M1+M2+M3. Saída: seção "Análise Cross-Artifact (D17)" adicionada a analyze-report.md.

---

#### rastreabilidade-matriz

**Arquivo:** `skills/rastreabilidade-matriz/SKILL.md`

**Descrição:** Gera rastreabilidade.md com matriz bidirecional ligando Objetivo de negócio (M1) → RF/RNF (M2) → Seção SRS (M3) → Spec (.feature) → Step definitions → Stakeholder origem. Detecta lacunas (células vazias = candidatos a issues para analyze-cross-artifact). Referência: content/catalogos-seed/conceitos/qualidade-e-validacao.md §4 (rastreabilidade bidirecional forward+backward).

**Quando usar:** Invocada pelo checker no Passo 3 do Processo M3. Entrada: `documentos-tecnicos/01-visao/01-visao-produto.md` + 03.1-funcionais.md + 03.2-qualidade.md + SRS-completo.md + spec/*.feature. Saída: rastreabilidade.md.

---

## Como navegar

| Objetivo | Por onde começar |
|---|---|
| Entender a sequência completa M1→M2→M3 | `content/workflows/m1-visao.md` → `content/workflows/m2-requisitos.md` → `content/workflows/m3-srs-specs-tests.md` |
| Saber o que cada sub-agente faz | Seção "Sub-agentes" acima ou `agents/<nome>.md` |
| Ver uma técnica específica de ER | Seção "Skills" acima ou `skills/<nome>/SKILL.md` |
| Canon teórico (decisões D1–D26, arquitetura) | `docs/planejamento/3 - Arquitetura da Ferramenta.md` |
| Guardrails e blacklist de jargão | `content/constitution.md` |
| Skills e agentes | `ferramenta-tcc/skills/`, `ferramenta-tcc/agents/` |
| Hook scripts (gate_guard, blacklist_guard, etc.) | `ferramenta-tcc/scripts/` |
| Catálogos seed (stakeholders, RFs, domínios) | `ferramenta-tcc/content/catalogos-seed/` |
| Testes E2E (casos + checklist por marco) | `ferramenta-tcc/tests/marco-{1,2,3}/` |
