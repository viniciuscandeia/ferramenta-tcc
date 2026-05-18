# Análise Zoox VEF e Plano de Refatoração da Ferramenta TCC

**Versão:** 2.0 | **Data:** 2026-05-18 | **Autor:** Vinicius Candeia
**Supersede:** versão 1.0 de 2026-05-17 (3.2 KB, 5 pilares genéricos)

---

## TL;DR

1. **25 padrões** do Zoox VEF catalogados (Z1–Z25); 18 ADOPT, 3 ADAPT, 4 SKIP.
2. **Gap crítico:** `.claude/skills/` + `.gemini/skills/` ausentes → CLI não descobre nenhuma skill nativamente (R9, prioridade máxima).
3. **Maior ganho técnico:** Output Discipline na `constitution.md` (R1) + Pass log append-only (R6) + HARD-GATE XML nas skills (R4).
4. **Rejeições explícitas:** Z3 (DOT em skills user-facing), Z10 (JIRA regex), Z11 (estado in-context viola D13), Z12 (MCP retry — sem MCP no TCC).
5. **9 blocos de refatoração** (R1–R9) distribuídos nas Semanas 3–6 sem interferir com build M2/M3.

> **Para o orientador:** leia TL;DR + Parte IV (sequenciamento). Para implementação: Parte I → Parte II → Parte III.

---

## Parte I — Análise: Padrões Zoox VEF (Z1–Z25)

### §1 Metodologia

**Escopo inspecionado:** `/Users/viniciuscandeia/Downloads/zoox-vef-dev-master`
- Plugin `vibe-engineering-po` — 3 skills PO (po-brainstorm, po-interview, po-validation), ~1100 LOC total
- Plugin `zoox-vef` — 9 skills Dev (dev-interview, dev-coding, dev-validation, dev-express, dev-project-bootstrap, dev-project-onboarding, dev-doc-review, dev-prototype-to-code, zoox-task-review), `hooks.json`, `templates/`
- `marketplace.json`, 2× `plugin.json`
- Framework README (541 linhas, fluxo de 6 fases)

**Método:** 3 agentes Explore em paralelo — PO skills, Dev skills + infra, TCC current state — com leitura completa de todos SKILL.md files + manifests. Resultados sintetizados neste documento.

---

### §2 Catálogo Z1–Z25

Formato por padrão: **Nome → Mecanismo → Evidência → Aplicabilidade TCC**

---

#### Z1 — Descrição-trigger bilíngue no frontmatter

**Mecanismo:** Frontmatter contém apenas `name` + `description`. A `description` é preenchida com frases-gatilho em PT-BR e EN que o modelo usa para auto-detectar quando invocar a skill.

**Evidência:** `po-brainstorm/SKILL.md` description inclui: `"estou pensando em", "tive uma ideia", "I'm thinking about", "let's brainstorm"`.

**Aplicabilidade TCC:** 🟢 HIGH — skills TCC têm `when_to_use` como campo separado (3 campos no frontmatter). Zoox coloca os gatilhos dentro de `description` — campo que o Claude Code CLI usa para auto-discover. O `when_to_use` atual da TCC não é indexado para descoberta nativa.

---

#### Z2 — Fases numeradas com Pré-Fase

**Mecanismo:** Toda skill Zoox tem estrutura de `Pré-Fase 0` (inicialização/language lock) + `Fase 0`, `Fase 1`, … `Fase N`. Cada fase tem: objetivo, ações, output esperado, e condição de transição.

**Evidência:** `po-interview/SKILL.md` tem `Pré-Fase 0 (Language Detection)` → `Fase 0 (Contexto)` → … → `Fase 10 (Handoff)`.

**Aplicabilidade TCC:** 🟢 HIGH — skills TCC têm seções PROCESSO/ENTRADA/SAÍDA mas sem numeração consistente de fases. Padronizar como `Fase 0 (Inicialização)` → `Fase N (Conclusão)` melhora legibilidade e manutenção (→ R3).

---

#### Z3 — DOT diagrams (Graphviz) embarcados

**Mecanismo:** Diagrama de fluxo da skill embutido no corpo do SKILL.md como bloco `dot` com `digraph` completo — diamonds para decisões, doublecircles para estados terminais.

**Evidência:** `po-brainstorm/SKILL.md` contém `digraph skill_flow { ... }` com ~25 nós.

**Aplicabilidade TCC:** 🔴 SKIP — skills TCC são lidas pelo Gemini CLI e Claude Code; DOT não é renderizado. Aumenta token weight sem valor de runtime. Manter no arquivo de arquitetura (`3 - Arquitetura da Ferramenta.md`), não nos SKILL.md.

---

#### Z4 — `<HARD-GATE>` XML blocks

**Mecanismo:** Bloco XML `<HARD-GATE>` no topo de cada skill (antes das fases) com lista explícita de `Do NOT` + condições de STOP. HARD-STOPS inline nas fases usam prefixo `⛔ HARD-GATE:`.

**Evidência:** `po-interview`: `<HARD-GATE> Your ONLY role is to extract functional and business requirements... Do NOT ask the PO technical questions such as 'what database should we use'.</HARD-GATE>`.

`dev-express` inline: `⛔ HARD-GATE: Before offering Dev Approval, run git diff --stat AND git status to confirm that ALL THREE of the following are present...`

**Aplicabilidade TCC:** 🟢 HIGH — gates TCC atualmente vivem como prosa no `orchestrator.md`. Promover para blocos XML inline nas skills relevantes (`traducao-gate`, `validacao-checklist-ireb`, `analyze-cross-artifact`) torna os invariantes auto-documentados e mais difíceis de ignorar (→ R4).

---

#### Z5 — "Filosofia / Regras Absolutas" como prior

**Mecanismo:** Bloco `## Filosofia desta skill (Regras Absolutas)` com 5–7 princípios numerados acima das fases. Funciona como persona prior — estabelece o "quem sou" antes do "o que faço". Regras são absolutas, não sugestões.

**Evidência:** `po-brainstorm` regra #1: *"Crítico honesto, não advogado do diabo. Discordância performática vira ruído e a skill é ignorada."* Regra #5: *"Sem 'depende' sem critério. 'Depende de como você implementar' é fuga. Posicione."*

**Aplicabilidade TCC:** 🟢 HIGH — skills TCC carecem de persona prior. O tom (gentil com leigo, rigoroso no checker) está disperso em REGRAS por skill sem hierarquia clara. Centralizar em bloco "Filosofia" por skill (→ R3).

---

#### Z6 — "Output Discipline" 8 regras (cross-skill)

**Mecanismo:** Bloco `## Output Discipline` com 8 regras numeradas, copy-paste idêntico nas 3 skills PO. Define: sem sumários intermediários em prosa, apenas quantitativo; frames visuais (`═══`) reservados para deliverables; tamanho de sumário executivo ≤ 2 linhas; sem repetição de contexto anterior.

**Evidência:** Regra 3 (idêntica nas 3 skills): *"NUNCA escreva 'Nenhum item crítico identificado' — omita a categoria."* Regra 8: *"NUNCA repita contexto anterior. Banido: 'Como vimos antes', 'Resumindo o que foi feito', 'Lembrete:...'."*

**Aplicabilidade TCC:** 🟢 HIGH — TCC `constitution.md` tem D1 (blacklist de termos ER), mas não tem regras de output discipline. Skills geram narrativas de processo hoje. Solução: adicionar §OUTPUT DISCIPLINE na `constitution.md` (não em cada skill — evitar drift de 25 cópias) referenciado por todas (→ R1).

---

#### Z7 — Escala de severidade uniforme 🔴🟠🟡🔵

**Mecanismo:** Escala de 4 níveis com emoji consistente em todas as skills: 🔴 CRÍTICO, 🟠 ALTO, 🟡 MÉDIO, 🔵 BAIXO. Definições atadas a consequências (não subjetivas).

**Evidência:** `zoox-task-review` define: `🔴 CRÍTICO — vulnerabilidade explosiva, data loss, regression que rompe fluxo principal`; `🔵 BAIXO — inconsistência de nomenclatura sem impacto funcional`.

**Aplicabilidade TCC:** 🟢 HIGH — TCC usa CRITICAL/HIGH/MEDIUM/LOW em prosa (D17 em `analyze-cross-artifact` e `validacao-checklist-ireb`). Migrar para escala emoji unificada + definições atadas a consequências (→ R2).

---

#### Z8 — Sumários quantitativos em vez de prosa

**Mecanismo:** Linha única ao fim de cada análise: `🔴 2 | 🟠 1 | 🟡 0 | 🔵 3`. Substitui parágrafos de resumo.

**Evidência:** `po-validation` Output Discipline regra: *"Sumário executivo: 2 linhas max. Use a linha de contagem: '🔴 2 | 🟠 1 | 🟡 0 | 🔵 3'."*

**Aplicabilidade TCC:** 🟢 HIGH — `checker` e `analyze-cross-artifact` hoje produzem sumários em prosa. Sumário quantitativo reduz tokens e melhora escaneabilidade para o usuário leigo (→ R2).

---

#### Z9 — Lista de frases banidas (Output Discipline)

**Mecanismo:** Frases proibidas explicitadas: não só jargão ER (D1) mas anti-padrões de output — frases que sinalizam processamento interno vazando para o usuário.

**Evidência:** Banidas: `"Nenhum item crítico identificado"`, `"Como vimos antes"`, `"Resumindo o que foi feito"`, `"Lembrete:"`, `"Baseado no arquivo X..."`, `"Estou lendo..."`, `"Vou analisar..."`.

**Aplicabilidade TCC:** 🟢 HIGH — extensão natural de D1. D1 bane termos ER; Z9 bane narrativas de processo. Adicionar lista Z9 à `constitution.md` §OUTPUT DISCIPLINE (→ R1).

---

#### Z10 — Multi-mode entry (regex + menu)

**Mecanismo:** Skill detecta modo de entrada: regex `[A-Z]+-\d+` → rota para JIRA flow; senão → `AskUserQuestion` com 4 opções (documento anexado / conversa atual / descrição livre / task JIRA). `entry_mode` salvo no header do artefato.

**Evidência:** `po-interview` Pré-Fase 0: *"Detectar `[A-Z]+-\d+` no prompt → `entry_mode: jira_existing` → saltar para Fase 0."*

**Aplicabilidade TCC:** 🔴 SKIP — TCC não tem JIRA IDs. Entry is always `/iniciar-projeto`. Porém o princípio de **multi-mode entry com menu** é aplicável ao orchestrator para `session-resume vs new-project` (já parcialmente implementado em `orchestrator.md:15-17`). Não adicionar complexity; documentar como decisão consciente de SKIP.

---

#### Z11 — Estado como variáveis nomeadas no contexto

**Mecanismo:** Skills Zoox armazenam estado como variáveis de string nomeadas inline (`"Store as raw_idea for use in Fase 3"`). Sem persistência externa — estado vive no contexto da conversa.

**Evidência:** `po-brainstorm` lista: `session_language, raw_idea, research_findings, steelman, red_team_findings, verdict, target_project_key, jira_task_id`.

**Aplicabilidade TCC:** 🔴 SKIP — TCC tem `estado-projeto.yaml` (D13) como SoT persistente. Estado in-context é anti-padrão para TCC: quebra recovery (D10) e viola D13. Manter `estado-projeto.yaml`. Documentar como rejeição explícita.

---

#### Z12 — MCP HARD STOP com retry + fallback manual

**Mecanismo:** Em qualquer operação MCP (GitHub, Atlassian), HARD STOP se falha. 3 tentativas com mensagem de progresso. Fallback: oferecer conteúdo para copiar/colar manual.

**Evidência:** `po-brainstorm` Fase 8: *"Retry up to 3 times with progress message. If still fails: paste the following text for manual creation in JIRA..."*

**Aplicabilidade TCC:** 🔴 SKIP — TCC não usa MCPs. Ferramenta roda localmente sem integrações externas. Baseline git é o único I/O externo (já gerenciado pelo orchestrator). Documentar como SKIP por design.

---

#### Z13 — Persona distinta por skill

**Mecanismo:** Cada skill define explicitamente sua voz: brainstorm = "Senior critic, cirúrgico"; interview = "PM Sênior, linguagem de produto"; validation = "Tradutor técnico→negócio".

**Evidência:** `po-validation`: *"Traduza o técnico para o negócio: ... 'Falta teste aqui — se o banco falhar, usuário vê tela em branco em vez de mensagem amigável'."*

**Aplicabilidade TCC:** 🟢 HIGH — skills TCC carecem de persona declarada. Mapeamento natural: `checker/analyze-cross-artifact` = critic (rigoroso, conciso); `vision-box/situacao-problema` = facilitador gentil; `traducao-leigo` = tradutor. Adicionar bloco "Filosofia/Persona" via R3.

---

#### Z14 — "Funciona normal não é especificação" / Zero termos técnicos

**Mecanismo:** Regra explícita em `po-interview`: respostas vagas são inválidas. `"Funciona normal" não é especificação.` Oferecer opções quando vago (`AskUserQuestion` com 2–3 opções concretas).

**Evidência:** `po-interview` regra 5: *"'Funciona normal' não é especificação. Sonde até ter um critério mensurável ou uma lista de casos."* Regra 4: *"Ofereça opções quando vago: use `ask_user_input` para oferecer 2 ou 3 opções concretas."*

**Aplicabilidade TCC:** 🟢 HIGH — `entrevista-estruturada` e `questionario-feixe` já fazem perguntas estruturadas, mas sem regra explícita de anti-vagueness. Adicionar via R3 (bloco Filosofia de cada skill de coleta) e promover ao `constitution.md` como regra geral de interação.

---

#### Z15 — `mode: express` no frontmatter do artefato

**Mecanismo:** Campo `mode: express` no header YAML do artefato (SPEC) controla comportamento de skills downstream. `po-validation` lê o campo e relaxa seções obrigatórias; `po-coding` adapta `§6.3`. Abusos ficam visíveis ao PO.

**Evidência:** `po-validation` Fase 0: *"Se `mode: express` no header da SPEC: lente menor — não exige §6 detalhada, mas ACHADO ALTO automático se `skipped_gates` foi populado sem justificativa concreta."*

**Aplicabilidade TCC:** 🟡 MEDIUM — aplicável ao fluxo TCC se stakeholder quiser pular validação completa (ex: projeto simples). `analyze-cross-artifact` poderia ler `modo` do `estado-projeto.yaml` e adaptar rigor. Implementar em R7 (Semana 6).

---

#### Z16 — hooks.json mínimo (notificação, não enforcement)

**Mecanismo:** `hooks.json` tem apenas 1 hook: `Stop` → `TaskCompleted` → `echo 'All tasks completed. Triggering dev-validation skill.'` Enforcement acontece via HARD-GATE inline, não via hooks.

**Evidência:** `plugins/zoox-vef/hooks/hooks.json`: `{"Stop": [{"matcher": "TaskCompleted", "hooks": [{"type": "command", "command": "echo 'All tasks completed...'"}]}]}`.

**Aplicabilidade TCC:** 🟡 MEDIUM — TCC não tem hooks hoje. Princípio importante: **hooks são notificações, não control flow**. Estado é computado de artefatos, não sinalizado por hooks. Quando TCC adicionar hooks, seguir este princípio.

---

#### Z17 — Templates copiados para `references/` no bootstrap

**Mecanismo:** Templates canônicos (`coding-standards.md`, `testing-policy.md`, etc.) vivem em `plugins/zoox-vef/templates/`. Skills de bootstrap **copiam** para a pasta `references/` do projeto. Skills de runtime leem `references/` local, não `templates/` do plugin.

**Evidência:** `dev-project-bootstrap` Phase 5: *"Copy `templates/coding-standards.md` → `references/coding-standards.md`. Customize per stack detection."*

**Aplicabilidade TCC:** 🟢 HIGH — TCC já tem `catalogos-seed/` com conhecimento IREB destilado. Skills hoje carregam tabelas IREB completas no seu próprio corpo. Progressive disclosure análogo: skills devem referenciar `catalogos-seed/` e ler sob demanda em vez de embedar tabelas nos SKILL.md (→ R5). Alinha com Pillar 2 original da v1.0.

---

#### Z18 — Invariantes de subagentes (4× NEVER)

**Mecanismo:** `dev-prototype-to-code` declara 4 invariantes absolutos para subagentes: NEVER >2 simultâneos (timeout), NEVER editar arquivos (só orquestrador edita), NEVER pular synthesis, NEVER retry agente falhado.

**Evidência:** `dev-prototype-to-code`: *"NEVER spawn more than 2 agents simultaneously. 3+ will timeout or produce truncated output."* *"NEVER allow agents to edit files directly. Only the orchestrator edits. Agents output findings only."*

**Aplicabilidade TCC:** 🟢 HIGH — `orchestrator.md` invoca sub-agentes via `Task()` (Claude Code) sem declarar invariantes. Adicionar bloco §INVARIANTES DE EXECUÇÃO no `orchestrator.md` (→ R4).

---

#### Z19 — HARD-GATE chaining via git HEAD freshness

**Mecanismo:** `dev-validation` auto-invoca `zoox-task-review` baseado em frescor do artefato: calcula HEAD efetivo via `git log -1 --format=%H -- ':!reports'` (path exclusion impede auto-referência). Artefato stale = auto-invoke modo `verify`; inexistente = auto-invoke modo `task`.

**Evidência:** `dev-validation`: *"`last_commit_reviewed` é o ponto de verdade único. Sempre que esta skill grava um Pass, atualiza este campo com: `git log -1 --format=%H -- ':!reports'`."*

**Aplicabilidade TCC:** 🟡 MEDIUM — TCC tem `git tag gate-N-aprovado` no orchestrator, mas sem freshness check formal. Aplicável: checker poderia verificar se `analyze-report.md` foi gerado antes ou depois do último commit de artefato M3. Implementar em R4 (gate logic no orchestrator).

---

#### Z20 — Pass log append-only

**Mecanismo:** `zoox-task-review` nunca sobrescreve uma análise anterior. Cada execução adiciona `## Pass N — <data> (modo X, commit <sha>)` ao artefato. Histórico de diagnósticos é o artefato.

**Evidência:** `zoox-task-review`: *"Pass 2 nunca reescreve Pass 1. Audit history is the artifact."*

**Aplicabilidade TCC:** 🟢 HIGH — loops M2 (`collector ⇄ modeler`) e M3 (`documenter ⇄ checker`) já têm `loop_m2_iteracoes` / `loop_m3_iteracoes` no `estado-projeto.yaml`. Adicionar Pass log append-only ao `analyze-report.md` e `pautas-reelicitacao.md` — cada iteração adiciona seção, nunca substitui (→ R6).

---

#### Z21 — Audit trail fields nos artefatos

**Mecanismo:** Artefatos persistidos têm frontmatter YAML com campos de auditoria: `mode`, `last_pass`, `last_commit_reviewed`, `skipped_gates`, `skipped_gates_reason`, `dev_owner_email`, `criteria_provided`, `origin`.

**Evidência:** `zoox-task-review` report header: `jira, spec, generated_at, mode, last_pass, last_commit_reviewed, repos_in_scope`.

`dev-express` SPEC header: `mode: express, dev_owner_email, dev_owner_name, skipped_gates: [], skipped_gates_reason: null`.

**Aplicabilidade TCC:** 🟢 HIGH — artefatos TCC (`visao-produto.md`, `SRS-completo.md`, etc.) não têm frontmatter de auditoria hoje. Adicionar campos mínimos: `marco`, `iteracao`, `gate_status`, `aprovado_em`, `modo` (→ R6).

---

#### Z22 — Express escape hatch com classifier matrix

**Mecanismo:** `dev-express` aplica pre-flight com 3-option classifier (simples / médio / complexo ou multi-repo). Complexidade detectada → `🔴 BLOQUEIA` com mensagem orientativa. Abusos ficam auditáveis via `skipped_gates` no artefato.

**Evidência:** `dev-express`: *"DEV declara escopo via 1 AskUserQuestion. Skill aplica matriz de classificação (✅ OK / 🟡 alerta+continua / 🔴 BLOQUEIA com mensagem orientativa)."* *"Honestidade no escopo. O DEV declara escopo no Pre-flight. Mentir aqui compromete o framework e fica registrado."*

**Aplicabilidade TCC:** 🟡 MEDIUM — aplicável quando stakeholder quiser pular etapas (ex: "produto simples, não precisa de tantas perguntas"). `analyze-cross-artifact` pode oferecer modo express com rigor reduzido + registro no `estado-projeto.yaml` (→ R7, Semana 6).

---

#### Z23 — Tokens de rastreabilidade bidirecional

**Mecanismo:** `zoox-task-review` taga cada business finding com `→ [T1]` e cada technical finding back-taga `← Análise de Negócio`. Link ausente é finding próprio.

**Evidência:** `zoox-task-review`: *"Cada item identificado precisa dos quatro elementos: [TN] arquivo:linha + Problema + Impacto + Fix."* *"Bidirectional traceability tags `→ [T1] / ← Análise` in zoox-task-review."*

**Aplicabilidade TCC:** 🟢 HIGH — TCC tem `rastreabilidade-matriz` skill (D16, 137 LOC) mas sem tokens inline nos artefatos. Adicionar tokens `[R-N]` nos requisitos e back-links `← Stakeholder X / Marco Y` nas entradas da matriz (→ R8).

---

#### Z24 — "Anti-Pattern" sections

**Mecanismo:** Cada skill Zoox tem 1–3 seções nomeadas de anti-padrão: nome do abuso → como acontece → por que é problema → o que fazer.

**Evidência:** `dev-express` anti-pattern: *"'Express para tudo' — DEV usa express para evitar entrevista técnica. Como detectar: grep `skipped_gates` + wc -l. Consequência: PO vê `ACHADO ALTO` na próxima validação."*

**Aplicabilidade TCC:** 🟡 MEDIUM — útil em skills internas (checker, analyze-cross-artifact). **Risco:** se vazar para output user-facing, leigo vê jargão. Implementar com marcação `<!-- internal -->` nos blocos Anti-Pattern (→ R3). Aplicar apenas em skills que não têm saída direta ao usuário leigo.

---

#### Z25 — Concreteness bar: 4 elementos obrigatórios por finding

**Mecanismo:** Nenhum item entra no relatório sem: identificador `[TN]`, localização `arquivo:linha`, problema, impacto, e fix. Item incompleto = excluído do relatório.

**Evidência:** `zoox-task-review`: *"Cada item identificado precisa dos quatro elementos — sem todos, fica fora do relatório: [TN] arquivo:linha + Problema + Impacto + Fix."*

**Aplicabilidade TCC:** 🟢 HIGH — `analyze-cross-artifact` (148 LOC) gera relatório de issues mas sem formato estruturado obrigatório por item. Adicionar template por finding: `[AN-N] artefato:seção | Problema | Impacto no gate | Ação requerida` (→ R8).

---

## Parte II — Gap Analysis: TCC Atual vs Zoox

### Tabela de decisões (Z1–Z25)

| ID | Padrão Zoox | TCC Atual | Decisão | Justificativa |
|---|---|---|---|---|
| Z1 | Descrição bilíngue com gatilhos | `when_to_use` separado (não indexado CLI) | **ADOPT** (→ R9) | Habilita descoberta nativa de skills pelo CLI |
| Z2 | Fases numeradas | Seções PROCESSO/ENTRADA/SAÍDA sem numeração uniforme | **ADOPT** (→ R3) | Legibilidade e manutenção; facilita referências cruzadas |
| Z3 | DOT diagrams | Não existe | **SKIP** | CLI não renderiza DOT; custo token sem valor runtime |
| Z4 | `<HARD-GATE>` XML | Gates em prosa no `orchestrator.md` | **ADOPT** (→ R4) | Self-documenting, harder to ignore than prose |
| Z5 | Filosofia / Regras Absolutas | Disperso em REGRAS por skill | **ADOPT** (→ R3) | Persona prior antes das fases melhora comportamento |
| Z6 | Output Discipline 8 regras | Não existe | **ADOPT** (→ R1) | Evita narrativa de processo vazando ao usuário |
| Z7 | Escala 🔴🟠🟡🔵 | CRITICAL/HIGH/MEDIUM/LOW em prosa (D17) | **ADOPT** (→ R2) | Uniformidade + escaneabilidade visual |
| Z8 | Sumário quantitativo | Sumários em prosa | **ADOPT** (→ R2) | Reduz tokens; melhor UX para leigo |
| Z9 | Frases banidas (output) | Apenas blacklist ER (D1) | **ADOPT** (→ R1) | Complementa D1 com anti-padrões de output |
| Z10 | Multi-mode entry JIRA | Não aplicável (sem JIRA) | **SKIP** | Sem JIRA; session-resume já implementado |
| Z11 | Estado in-context | `estado-projeto.yaml` (D13) | **SKIP** | Viola D13; yaml é SoT persistente por design |
| Z12 | MCP retry + fallback | Sem MCPs | **SKIP** | TCC sem integrações externas por design |
| Z13 | Persona por skill | Não declarada | **ADOPT** (→ R3) | Tom correto por contexto (critic vs facilitador vs tradutor) |
| Z14 | Anti-vagueness rule | Parcial em `entrevista-estruturada` | **ADOPT** (→ R3) | Promover a regra explícita em todas skills de coleta |
| Z15 | `mode:` no frontmatter artefato | Não existe | **ADAPT** (→ R7) | Útil para express path; implementar em Semana 6 |
| Z16 | hooks.json mínimo | Sem hooks | **ADAPT** | Princípio ADOPT: hooks = notificação, não enforcement |
| Z17 | Templates copiados, não embarcados | Tabelas IREB inline nos SKILL.md | **ADOPT** (→ R5) | Progressive disclosure; catalogs-seed já existe |
| Z18 | Invariantes subagentes NEVER | Não declarados | **ADOPT** (→ R4) | Sub-agentes TCC via `Task()` sem invariantes hoje |
| Z19 | HARD-GATE chaining via git HEAD | `git tag gate-N-aprovado` sem freshness check | **ADAPT** (→ R4) | Adaptar para artefatos M3 (checker freshness) |
| Z20 | Pass log append-only | Não existe | **ADOPT** (→ R6) | Loops M2/M3 sobrescrevem hoje; histórico perdido |
| Z21 | Audit trail fields nos artefatos | Sem frontmatter nos artefatos | **ADOPT** (→ R6) | Rastreabilidade IREB; campos mínimos suficientes |
| Z22 | Express escape hatch | Não existe | **ADAPT** (→ R7) | Implementar para stakeholder com projeto simples (Semana 6) |
| Z23 | Tokens bidirecional `→/←` | `rastreabilidade-matriz` sem tokens inline | **ADOPT** (→ R8) | Torna matrix executável, não só doc |
| Z24 | Anti-Pattern sections | Não existe | **ADAPT** (→ R3) | Só em skills internas + marcação `<!-- internal -->` |
| Z25 | Concreteness bar 4 elementos | `analyze-cross-artifact` sem template por item | **ADOPT** (→ R8) | Rigor de output do checker |

---

### §3.1 Gap Estrutural Crítico: `.claude/skills/` + `.gemini/skills/`

**Problema:** `plugin.json` em `.claude/.claude-plugin/` tem `"skills": []` (array vazio). `.gemini/gemini-extension.json` não tem campo `skills`. As 25 skills em `core/skills/*/SKILL.md` são invisíveis para a descoberta nativa de ambos os CLIs.

**Consequência operacional:** Toda invocação de skill hoje depende de referência explícita por prosa dentro dos agentes — o modelo precisa "lembrar" que a skill existe. Auto-trigger por `description` (Z1) é impossível sem o registro nos manifests.

**Evidência:** 
```bash
cat ferramenta-tcc/.claude/.claude-plugin/plugin.json | jq '.skills'
# → []
```

**Solução (R9):** Thin wrappers em `.claude/skills/<name>/SKILL.md` e `.gemini/skills/<name>/SKILL.md`, espelhando o padrão já usado em `.claude/agents/` e `.gemini/agents/`. Detalhe em Parte III §R9.

---

## Parte III — Plano de Refatoração (R1–R9)

Cada bloco: **Motivação → Padrões adotados → Arquivos afetados → Critério de aceite → Esforço estimado**

---

### R1 — Output Discipline na constitution.md

**Motivação:** Skills TCC geram narrativas de processo que vazam para o usuário. D1 bane jargão ER mas não bane anti-padrões de output (Z6, Z9). Centralizar na `constitution.md` evita 25 cópias divergentes.

**Padrões:** Z5 (partial), Z6, Z9

**Arquivos:**
- `ferramenta-tcc/core/constitution.md` — adicionar §OUTPUT DISCIPLINE após §REGRAS DE INTERAÇÃO

**Conteúdo da nova seção:**
```
## OUTPUT DISCIPLINE (Z6, Z9)

Aplica a TODOS os agentes e skills em qualquer saída gerada.

### Regras absolutas de output
1. Sumários intermediários: apenas quantitativos (≤ 2 linhas). Ex: `🔴 2 | 🟠 1 | 🟡 0 | 🔵 3`.
2. Frames visuais (`═══`, `───`) reservados para deliverables finais (gate, artefatos aprovados).
3. NUNCA escreva "Nenhum problema identificado" — omita a categoria se vazia.
4. NUNCA repita contexto anterior. Banido: "Como vimos antes", "Resumindo o que fizemos", "Lembrete:".
5. Proibido vazar processo interno: "Estou lendo...", "Baseado no arquivo X...", "Vou agora analisar...".
6. Texto de deliverable ≠ texto de interface. Interface: linguagem leigo. Deliverable normativo: EARS + RFC 2119.
7. Se uma categoria de issues está vazia, omitir — não informar a omissão.
8. Aprovações e gates: apresentar conteúdo, pedir confirmação yesno. Nunca pedir aprovação de processo intermediário.

### Extensão da blacklist D1 (frases de anti-padrão)
Adicionar à tabela §REGRA ABSOLUTA:
| PROIBIDO | USE EM VEZ DISSO |
|---|---|
| "Analisando...", "Processando..." | (omitir — não narrar o processo) |
| "Nenhum item crítico encontrado" | (omitir a categoria) |
| "Como mencionado antes" | (referência direta ao artefato) |
| "Vou agora..." | (agir diretamente) |
```

**Critério de aceite:** `constitution.md` tem §OUTPUT DISCIPLINE com ≥ 8 regras + blacklist estendida. Agentes que carregam constitution não geram frases banidas em dry-run de M1.

**Esforço:** ~1h (edição de 1 arquivo).

---

### R2 — Escala de severidade unificada + sumário quantitativo

**Motivação:** `checker`, `analyze-cross-artifact`, e `validacao-checklist-ireb` usam CRITICAL/HIGH/MEDIUM/LOW em prosa. Zoox usa 🔴/🟠/🟡/🔵 com definições atadas a consequências (Z7, Z8).

**Padrões:** Z7, Z8

**Arquivos:**
- `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` — migrar severity labels + adicionar template de sumário quantitativo
- `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md` — idem
- `ferramenta-tcc/core/agents/checker.md` — atualizar referências a severity

**Mapeamento:**
| Atual | Novo | Definição |
|---|---|---|
| CRITICAL | 🔴 BLOQUEADOR | Impede gate; SRS incompatível com IREB §3.3.3 |
| HIGH | 🟠 ALTO | Não bloqueia gate mas requer correção no loop |
| MEDIUM | 🟡 MÉDIO | Sugestão de melhoria; registrar em `pautas-reelicitacao.md` |
| LOW | 🔵 BAIXO | Inconsistência cosmética; não registrar em pautas |

**Critério de aceite:** `analyze-cross-artifact` produz linha de sumário `🔴 N | 🟠 N | 🟡 N | 🔵 N` ao final de cada análise. Labels CRITICAL/HIGH/MEDIUM/LOW não aparecem mais nos outputs.

**Esforço:** ~2h (3 arquivos).

---

### R3 — Padronização estrutural por skill (Fases + Filosofia + Anti-Pattern)

**Motivação:** 25 skills têm estruturas heterogêneas (PROCESSO/ENTRADA/SAÍDA vs passos numerados vs blocos livres). Zoox padroniza: Filosofia → Fases numeradas → Outputs (Z2, Z5, Z13, Z24).

**Padrões:** Z2, Z5, Z13, Z24

**Arquivos:** Todos 25 `ferramenta-tcc/core/skills/*/SKILL.md`

**Estratégia — piloto em 3, propagar:**
1. Piloto: `core/skills/vision-box/SKILL.md`, `core/skills/situacao-problema/SKILL.md`, `core/skills/stakeholder-mapping/SKILL.md`
2. Rodar M1 E2E (ROADMAP.md:81-84) para confirmar sem regressão
3. Propagar para demais 22 skills em Semanas 4–5

**Template de skill padronizado:**
```markdown
---
name: <nome>
description: <gatilhos bilíngues Z1 — 2-4 frases PT-BR + 1-2 EN>
---

## Filosofia desta skill (Regras Absolutas)
1. [Persona: ex: "Facilitador gentil com leigo — nunca deixo resposta vaga passar"]
2. [Regra crítica de comportamento]
3. [Anti-vagueness: "Resposta vaga não é informação. Sonde com opções."]

<HARD-GATE>
[Quando esta skill NÃO deve ser executada]
[Condições de STOP inline com ⛔]
</HARD-GATE>

## Fase 0 — Inicialização
[carregar constitution + ler estado-projeto.yaml + verificar pré-condições]

## Fase 1 — [Nome]
[ações, outputs esperados, transição]

## Fase N — Conclusão
[artefato gerado, sinalização para agente pai]

<!-- internal -->
## Anti-Padrão: [nome do abuso típico]
[como acontece, como detectar, o que fazer]
<!-- /internal -->
```

**Critério de aceite:** 3 skills piloto têm frontmatter bilíngue + bloco Filosofia + Fases numeradas + HARD-GATE + Anti-Padrão marcado internal. M1 E2E passa sem regressão.

**Esforço:** ~1h por skill. Piloto: 3h. Propagação 22 skills: ~22h (in-flight Semanas 4–5).

---

### R4 — HARD-GATE XML promovido para skills + invariantes de subagentes

**Motivação:** Gates TCC vivem como prosa no `orchestrator.md`. Zoox embarca `<HARD-GATE>` nas próprias skills (Z4) + declara invariantes de subagentes explicitamente (Z18).

**Padrões:** Z4, Z18, Z19 (partial)

**Arquivos:**
- `ferramenta-tcc/core/orchestrator.md` — adicionar §INVARIANTES DE EXECUÇÃO; adaptar gate logic com referência a freshness check
- `ferramenta-tcc/core/skills/traducao-gate/SKILL.md` — adicionar `<HARD-GATE>` no topo
- `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md` — idem
- `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` — idem + freshness check para artefatos M3

**Invariantes a adicionar no `orchestrator.md`:**
```
## INVARIANTES DE EXECUÇÃO (Z18)
- NUNCA invocar mais de 2 sub-agentes simultaneamente (Claude Code: Task() paralelo limitado a 2)
- Sub-agentes NUNCA editam artefatos diretamente — apenas orquestrador escreve
- NUNCA pular etapa de síntese após retorno de sub-agente
- NUNCA retry de sub-agente falhado na mesma iteração — registrar em `_pendencias.md` e continuar

## FRESHNESS CHECK (Z19 — gate M3)
Antes de Gate 3:
- Verificar se `analyze-report.md` foi gerado APÓS o último commit em `spec/` + `tests/`
- Se stale: forçar re-execução de `checker` antes de apresentar gate
```

**Critério de aceite:** `orchestrator.md` tem §INVARIANTES DE EXECUÇÃO. Skills `traducao-gate`, `validacao-checklist-ireb`, `analyze-cross-artifact` têm `<HARD-GATE>` no topo. Gate M3 verifica freshness de `analyze-report.md`.

**Esforço:** ~3h (4 arquivos, lógica moderada).

---

### R5 — Progressive disclosure: tabelas IREB/Wiegers para catalogos-seed/references/

**Motivação:** Skills carregam tabelas IREB e Wiegers inteiras no corpo do SKILL.md, inflando o contexto sempre. Zoox move referências estáticas para `references/` e as skills leem sob demanda (Z17). TCC já tem `catalogos-seed/` para isso.

**Padrões:** Z17

**Arquivos:**
- `ferramenta-tcc/core/skills/classificacao-rf-rnf/SKILL.md` — extrair tabela ISO 25010 para `catalogos-seed/references/iso25010-rnf.md`
- `ferramenta-tcc/core/skills/priorizacao/SKILL.md` — extrair tabelas MoSCoW e Kano para `catalogos-seed/references/priorizacao-tecnicas.md`
- `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md` — extrair checklist IREB §3.8 para `catalogos-seed/references/ireb-qualidade-checklist.md`
- `ferramenta-tcc/core/skills/srs-ireb-template/SKILL.md` — extrair template SRS para `catalogos-seed/references/srs-template-ireb.md`
- **Novos arquivos:** `ferramenta-tcc/catalogos-seed/references/` (diretório) + 4 arquivos acima

**Padrão de referência inline:** Skills substituem tabelas por:
```
[Referência: caso precise validar categorias ISO 25010, ler `catalogos-seed/references/iso25010-rnf.md`. 
Carregar somente se detectar inconsistência que exige validação profunda.]
```

**Critério de aceite:** 4 skills afetadas reduzem em ≥ 30 LOC cada. `catalogos-seed/references/` tem 4 novos arquivos com o conteúdo extraído.

**Esforço:** ~3h (extração + refatoração de 4 skills + 4 novos arquivos).

---

### R6 — Pass log append-only + audit fields + template estado-projeto

**Motivação:** Loops M2/M3 sobrescrevem artefatos — histórico de diagnósticos perdido. Zoox usa Pass log append-only (Z20). Artefatos TCC sem frontmatter de auditoria (Z21). Falta template de `estado-projeto.yaml` como referência.

**Padrões:** Z20, Z21

**Arquivos:**
- `ferramenta-tcc/core/orchestrator.md` §ESTADO DO PROJETO — expandir schema com campos de auditoria + regra de Pass log
- `ferramenta-tcc/core/agents/checker.md` — adicionar instrução: ao gerar `analyze-report.md`, **appender** seção `## Análise — Iteração N` em vez de sobrescrever
- `ferramenta-tcc/core/agents/documenter.md` — idem para `pautas-reelicitacao.md` em loops M2
- **Novo:** `ferramenta-tcc/catalogos-seed/estado-projeto.exemplo.yaml` — template documentado

**Schema expandido do `estado-projeto.yaml`:**
```yaml
marco_corrente: M1
gate_status:
  gate_1: pendente
  gate_2: pendente
  gate_3: pendente
  gate_4: nao_solicitado
artefatos:
  - nome: visao-produto-leigo.md
    modo: normativo        # novo campo Z21
    iteracao: 1            # novo campo Z20
    aprovado_em: null      # novo campo Z21
    gate: gate_1           # novo campo Z21
pautas_abertas: []
loop_m2_iteracoes: 0
loop_m3_iteracoes: 0
versao_leigo_aprovada: []
ultima_atualizacao: "2026-05-18T00:00:00"
# Pass log — append-only
passes:
  - iteracao: 1
    marco: M2
    agente: checker
    data: "2026-05-18T00:00:00"
    resumo_quantitativo: "🔴 0 | 🟠 2 | 🟡 1 | 🔵 0"
    artefato: analyze-report.md
```

**Regra Pass log:** `analyze-report.md` e `pautas-reelicitacao.md` nunca são sobrescritos após iteração 1. Cada nova iteração adiciona:
```
## Análise — Iteração N — <data>
### Resumo: 🔴 N | 🟠 N | 🟡 N | 🔵 N
[issues desta iteração]

### Resolução vs Iteração N-1
✅ Resolvidos: [lista]
❌ Persistem: [lista]
🆕 Novos: [lista]
```

**Critério de aceite:** `catalogos-seed/estado-projeto.exemplo.yaml` existe com schema completo incluindo `passes[]`. `checker.md` tem instrução explícita de append-only. Artefato `analyze-report.md` após 2 iterações de M3 tem 2 seções distintas sem sobrescrita.

**Esforço:** ~3h (3 arquivos + 1 novo template).

---

### R7 — Express mode com classifier matrix

**Motivação:** Stakeholder com projeto simples pode querer pular etapas de validação. Sem escape hatch controlado, pulam informalmente (sem registro). Z22 oferece escape hatch com audit trail (→ Semana 6, após estabilizar fluxo completo).

**Padrões:** Z15, Z22

**Arquivos:**
- `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` — adicionar modo express com rigor reduzido se `modo: express` em `estado-projeto.yaml`
- `ferramenta-tcc/core/orchestrator.md` — adicionar opção de `modo: express` no `estado-projeto.yaml` com classifier no início do projeto
- `ferramenta-tcc/core/skills/clarificacao-pos-visao/SKILL.md` — adicionar pre-flight que detecta `modo: express` e reduz threshold de lacunas

**Classifier no orchestrator (projeto novo):**
```
AskUserQuestion (yesno): 
"Este projeto é simples (um produto, um time pequeno, escopo conhecido) 
 ou complexo (múltiplos times, integrações, domínio novo)?"
→ Simples: `modo: express` em estado-projeto.yaml
  - Loop M2 máximo 1 iteração (vs 3)
  - `analyze-cross-artifact` em modo reduzido (Z15)
  - Registrado em artefatos finais para rastreabilidade
→ Complexo: fluxo padrão sem alteração
```

**Critério de aceite:** Projeto simples pode completar M1-M3 com 1 loop cada. `estado-projeto.yaml` tem `modo: express` registrado. `analyze-cross-artifact` em modo express produz sumário com aviso `[MODO EXPRESS — RIGOR REDUZIDO]`.

**Esforço:** ~4h (lógica moderada em 3 arquivos, aguardar Semana 6).

---

### R8 — Tokens de rastreabilidade bidirecional + concreteness bar

**Motivação:** `rastreabilidade-matriz` skill existe (D16) mas sem tokens inline nos artefatos. Issues do checker sem formato estruturado obrigatório. Z23 + Z25 tornam rastreabilidade e diagnóstico executáveis.

**Padrões:** Z23, Z25

**Arquivos:**
- `ferramenta-tcc/core/skills/rastreabilidade-matriz/SKILL.md` — adicionar instrução de geração de tokens `[R-N]` nos requisitos e back-links nas entradas da matriz
- `ferramenta-tcc/core/agents/checker.md` — adicionar template obrigatório por finding: `[AN-N] artefato:seção | Problema | Impacto no gate | Ação requerida`
- `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` — idem para issues cross-artifact

**Template de finding (concreteness bar Z25):**
```
[AN-N] <artefato>:<seção> | 🔴/🟠/🟡/🔵 | <problema> | <impacto no gate> | <ação requerida>

Exemplo:
[AN-1] 03.1-funcionais.md:RF-04 | 🟠 ALTO | RF-04 não tem critério mensurável ("rápido") | 
        Gate 2 bloqueado se não corrigido | Adicionar: "≤ 2s em 95% das requisições"
```

**Token de rastreabilidade (Z23):**
```
Em 03.1-funcionais.md, cada requisito recebe: [R-01], [R-02], ...
Em rastreabilidade.md, cada entrada tem back-link: ← Stakeholder X / Marco M1 / Sessão 1
Link ausente = finding 🟡 MÉDIO automático
```

**Critério de aceite:** `analyze-cross-artifact` produz findings com formato 4-elementos. `rastreabilidade-matriz` gera tokens `[R-N]`. Finding sem os 4 elementos não aparece no relatório final.

**Esforço:** ~3h (3 arquivos).

---

### R9 — Frontmatter Z1 + scaffolding `.claude/skills/` + `.gemini/skills/`

**Motivação:** Gap crítico: 25 skills invisíveis para descoberta nativa do CLI (§3.1). Frontmatter atual usa `when_to_use` não indexado. Z1 exige `description` com gatilhos bilíngues.

**Padrões:** Z1 + §3.1 fix

**Arquivos (modificados):**
- Todos 25 `ferramenta-tcc/core/skills/*/SKILL.md` — reescrever `description` com gatilhos bilíngues + remover campo `when_to_use` (consolidar em description)
- `ferramenta-tcc/.claude/.claude-plugin/plugin.json` — popular array `"skills": [...]`
- `ferramenta-tcc/.gemini/gemini-extension.json` — adicionar campo `"skills": [...]`

**Arquivos (novos — 50 wrappers):**
- `ferramenta-tcc/.claude/skills/<name>/SKILL.md` × 25
- `ferramenta-tcc/.gemini/skills/<name>/SKILL.md` × 25

**Forma do thin wrapper (mesma do agents pattern):**
```markdown
---
name: vision-box
description: >
  Use quando o stakeholder descreve o que quer construir pela primeira vez.
  Quando alguém diz "quero criar um app pra...", "preciso de um sistema que...",
  "minha ideia é...". Use this when stakeholder describes their product idea
  for the first time — "I want to build...", "I need a system that...".
---

# Adapter Claude Code — vision-box

Lógica canônica: `ferramenta-tcc/core/skills/vision-box/SKILL.md`

## Instruções de execução (Claude Code)
1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/vision-box/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário
```

**Nota sobre Gemini CLI:** Gemini CLI não tem first-class skill discovery via manifesto (persona adoption). Wrappers `.gemini/skills/` são documentação e forward-compat. Não assumir parity de runtime com Claude Code até confirmação de suporte no Gemini CLI.

**`plugin.json` atualizado:**
```json
{
  "name": "ferramenta-tcc",
  "version": "1.0.0",
  "skills": [
    "vision-box", "situacao-problema", "stakeholder-mapping",
    "contexto-e-limite", "clarificacao-pos-visao",
    "entrevista-estruturada", "cenario-narrativa", "recomendacao-dominio",
    "recomendacao-implicitos", "questionario-feixe",
    "classificacao-rf-rnf", "priorizacao", "glossario",
    "conflitos-detect", "pautas-reelicitacao",
    "requisito-ears", "srs-ireb-template", "gherkin-spec",
    "step-defs-red", "testing-strategy", "readme-tests",
    "validacao-checklist-ireb", "analyze-cross-artifact", "rastreabilidade-matriz",
    "traducao-leigo", "traducao-gate"
  ]
}
```

**Critério de aceite:**
- `find .claude/skills -name SKILL.md | wc -l` = 25; idem `.gemini/skills`
- `diff` frontmatter wrapper vs core → `name` e `description` idênticos
- `plugin.json` array `"skills"` tem 25 entradas e é JSON válido
- Pergunta que deveria triggar `vision-box` dispara skill automaticamente no Claude Code CLI

**Esforço:** ~6h (reescrita de 25 descriptions + 50 wrappers + 2 manifests — alto volume, baixa complexidade).

---

## Parte IV — Sequenciamento e Integração ao ROADMAP

| Semana | Atividade TCC existente (ROADMAP) | Atividade desta refatoração |
|---|---|---|
| **Semana 3 (fim — agora)** | Verificação E2E M1 pendente | **Step 1:** Doc rewrite (este doc) ✅ **Step 2:** R9 skills/ scaffolding **Step 3:** R1 constitution Output Discipline **Step 4:** R6 template estado-projeto |
| **Semana 4** | Build M2: skills collector/modeler, workflows | R2 (severity scale) em `analyze-cross-artifact` R3 piloto 3 skills M1 → rodar E2E M1 → propagar R6 (Pass log nas skills de checker e documenter) |
| **Semana 5** | Build M3: skills documenter/checker, workflows, SRS template | R3 propagação M2/M3 skills (22 restantes) R4 HARD-GATE inline + invariantes R5 Progressive disclosure (extrair tabelas) |
| **Semana 6** | Estudo de caso (validação com stakeholder real) | R7 Express mode (se tempo permitir — baixa prioridade) R8 Tokens rastreabilidade bidirecional |
| **Semana 7** | Escrita da monografia — capítulo de implementação | Retrospectiva apendada aqui (§Parte VIII) |

**Regra de não-interferência:** Refatorações de Semanas 4–5 são feitas **in-flight** com o build de M2/M3 — novas skills já nascem no template padronizado (R3). Não refatorar skills de M1 durante build de M2.

---

## Parte V — Padrões Rejeitados

| ID | Padrão | Razão da Rejeição |
|---|---|---|
| Z3 | DOT diagrams em skills | CLI não renderiza Graphviz. Custo de tokens (~500-800 tokens por diagrama) sem valor de runtime. Diagramas vivem no doc de arquitetura (já existem). |
| Z10 | Multi-mode entry via JIRA regex | TCC não integra JIRA. Entry point é sempre `/iniciar-projeto`. Session-resume já implementado em `orchestrator.md:15-17`. Complexidade sem benefício. |
| Z11 | Estado in-context (variáveis nomeadas) | Viola D13 (estado-projeto.yaml como SoT persistente). In-context state quebra recovery (D10) e não sobrevive a crashes de sessão — exatamente o problema que D13 resolve. |
| Z12 | MCP retry + fallback manual | TCC é offline-first sem integrações externas. Baseline git é o único I/O externo. MCPs podem ser adicionados em versão futura (D24 opcional). |

---

## Parte VI — Riscos

| # | Risco | Trigger | Mitigação |
|---|---|---|---|
| RK1 | Output Discipline copy-paste em 25 skills gera drift | Alguém edita uma skill individualmente | Bloco vive SOMENTE em `constitution.md`; skills referenciam por nome, não incluem cópia |
| RK2 | Anti-Pattern sections (Z24) vazam jargão ao leigo | Skill com `<!-- internal -->` mal implementada expõe seção | `traducao-leigo` deve filtrar conteúdo marcado internal antes de apresentar ao usuário |
| RK3 | Persona "senior critic" contradiz D1 (tom leigo) | Bloco Filosofia de `checker` usa linguagem técnica/agressiva | Critic persona SOMENTE em internal-facing skills (`checker`, `analyze-cross-artifact`). Skills user-facing mantêm tom facilitador gentil (já especificado em `vision-box/SKILL.md:80-83`) |
| RK4 | `<HARD-GATE>` XML confunde parser Gemini CLI | Gemini não tem semântica XML; pode renderizar tags literalmente ao usuário | Posicionar `<HARD-GATE>` ACIMA de qualquer seção user-facing. Testar em Gemini CLI no piloto R3 antes de propagar |
| RK5 | git freshness check (Z19 adapt) quebra se projeto sem `.git` | Usuário roda ferramenta fora de repo git | Pre-flight no orchestrator: se sem `.git/`, skip freshness check + registrar warning em `_pendencias.md` |
| RK6 | Descriptions Z1 bilíngues inflam token cost | Cada sessão carrega 25 descriptions para indexação | ~25 skills × 80 tokens = ~2k tokens por sessão — aceitável; paga-se na primeira auto-trigger |
| RK7 | R3 mass-rewrite regride M1 não testado | E2E M1 ainda não passou (ROADMAP:81-84 `[ ]`) | Piloto R3 em 3 skills ANTES de rodar E2E M1. Só propagar após E2E verde. |
| RK8 | Doc rewrite (este arquivo) causa scope creep nas Semanas 4-5 | Expansão contínua de seções durante o build | Hard cap: se este arquivo ultrapassar 32 KB, mover §R7-R8 para `8 - Refatoracao-Fase2.md` |
| RK9 | Wrapper frontmatter drift vs core | Edição de `description` no core sem atualizar wrapper | Regra documentada: wrappers DEVEM ter `name`+`description` verbatim de core. Verificar com: `diff <(grep -A2 "^---" core/skills/<n>/SKILL.md) <(grep -A2 "^---" .claude/skills/<n>/SKILL.md)` |

---

## Parte VII — Verificação

### V1–V5 — Verificação do doc

| # | Check | Como verificar |
|---|---|---|
| V1 | Este arquivo entre 22–32 KB | `wc -c "7 - Refatoracao-Zoox-VEF.md"` |
| V2 | Z1–Z25 todos presentes com decisão | Grep: `grep -c "^\| Z" "7 - Refatoracao-Zoox-VEF.md"` ≥ 25 |
| V3 | Todos paths absolutos em R1–R9 resolvem | `find ferramenta-tcc -name "*.md" \| xargs grep -l "constitution"` — spot check |
| V4 | Semanas Parte IV não conflitam com ROADMAP | Abrir `ROADMAP.md` e confirmar que Semana 4-5 TCC não tem conflito de files |
| V5 | TL;DR + Parte IV suficientes para orientador | Ler TL;DR (5 bullets) + Parte IV (tabela) sem resto do doc — contexto claro? |

### V6–V10 — Verificação do scaffolding skills/ (após R9)

| # | Check | Comando |
|---|---|---|
| V6 | 25 wrappers em cada diretório | `find ferramenta-tcc/.claude/skills -name SKILL.md \| wc -l` = 25 |
| V7 | Frontmatter wrapper = core | `for s in ferramenta-tcc/core/skills/*/; do name=$(basename $s); diff <(head -5 $s/SKILL.md) <(head -5 ferramenta-tcc/.claude/skills/$name/SKILL.md); done` |
| V8 | `plugin.json` válido com 25 skills | `jq '.skills \| length' ferramenta-tcc/.claude/.claude-plugin/plugin.json` = 25 |
| V9 | Auto-trigger no CLI | No Claude Code: digitar prompt que inclua "quero criar um app pra..." → confirmar que `vision-box` é invocada automaticamente |
| V10 | M1 E2E sem regressão | Executar `ferramenta-tcc/tests/marco-1/checklist.md` após R9 — todos `[x]` |

### V11–V13 — Verificação dos refactors R1–R8

| # | Check | Quando verificar |
|---|---|---|
| V11 | `constitution.md` tem §OUTPUT DISCIPLINE com ≥ 8 regras | Após R1 (Semana 3) |
| V12 | `analyze-cross-artifact` produz `🔴 N \| 🟠 N \| 🟡 N \| 🔵 N` sem labels CRITICAL/HIGH/LOW | Após R2 (Semana 4) |
| V13 | `analyze-report.md` tem 2 seções após 2 loops M3 sem sobrescrita | Após R6 (Semana 4) |

---

## Notas sobre Diferenças de Domínio (Zoox Dev vs TCC ER)

Zoox VEF é uma ferramenta de **engenharia de software** para devs. TCC é uma ferramenta de **elicitação de requisitos** para leigos. Adaptações necessárias além das listadas:

1. **Sem "código como artefato":** Zoox valida código contra spec. TCC valida artefatos de texto (SRS, glossário) contra critérios IREB. Padrões de validação (Z23, Z25) precisam de adaptação para artefatos textuais, não arquivos de código.

2. **Sem git log de código:** Z19 usa `git log` sobre código-fonte para freshness. TCC usa `git tag gate-N-aprovado` sobre artefatos Markdown — equivalente válido, mas sem path exclusion via `:!reports` (adaptar conforme necessário).

3. **Stakeholder leigo vs developer:** Tudo exposto ao usuário final TCC passa por `traducao-leigo`. Personas "critic" e "diagnóstico estruturado" (Z13, Z25) são internas — nunca expostas.

4. **Sem MCP = sem tool calls de I/O externo:** Zoox depende de GitHub + JIRA MCPs para handoff. TCC depende de arquivos locais. Padrão de handoff adaptado: artefatos em disco + git tags.

5. **Gaps que TCC endereça e Zoox não:** glossário gerenciado (`glossario` skill), detecção de conflitos entre requisitos (`conflitos-detect`), requisitos EARS com RFC 2119 (`requisito-ears`), traceabilidade IREB (D16), critérios de qualidade ISO 29148 (`validacao-checklist-ireb`). Estas são vantagens diferenciadoras do TCC frente ao Zoox no domínio de ER.
