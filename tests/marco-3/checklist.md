# Checklist de Verificação — Marco 3: Detalhamento (SRS + Specs + Tests)

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-3/execucoes/execucao-NN-<descritor>/`.

---

## Bloco A — SRS estrutura IREB §3.3.3

- [ ] **A1.** `SRS-completo.md` existe com as 6 seções IREB §3.3.3: (1) Introdução, (2) Descrição Geral, (3) Requisitos Funcionais, (4) Requisitos de Qualidade, (5) Interfaces externas, (6) Rastreabilidade
- [ ] **A2.** `SRS-completo-leigo.md` existe (versão leigo gerada por `traducao-gate`)
- [ ] **A3.** Seção 3 do SRS contém todos os RFs de `03.1-funcionais.md` em formato EARS + RFC 2119
- [ ] **A4.** Seção 4 do SRS contém todos os RNFs de `03.2-qualidade.md` com métricas preservadas
- [ ] **A5.** Seção 5 do SRS referencia restrições de `03.3-restricoes.md` e glossário de `glossario.md`

---

## Bloco B — Specs Gherkin (D20+D22)

- [ ] **B1.** `spec/` contém exatamente o mesmo número de arquivos `.feature` que o número de RFs com modal `DEVE` em `03.1-funcionais.md` (ex: 6 RFs DEVE → 6 `.feature` files para Caso 1; 8 para Caso 2)
- [ ] **B2.** Cada `.feature` tem estrutura Gherkin válida: `Feature`, ≥ 1 `Scenario` com `Given/When/Then`
- [ ] **B3.** `spec/_skipped.md` existe listando RFs com modal `DEVERIA`/`PODE` sem spec + razão ("não-obrigatório — RFC 2119")
- [ ] **B4.** Nenhum `.feature` gerado para RF com modal `DEVERIA` ou `PODE` (filtro D22 respeitado)

---

## Bloco C — Step definitions RED (D20)

- [ ] **C1.** `tests/unit/` e `tests/acceptance/` existem e contêm arquivos de step definitions
- [ ] **C2.** Step defs Pytest-BDD: usa `@scenario`/`@given`/`@when`/`@then`; corpo lança `NotImplementedError` ou similar — sem falso-pass
- [ ] **C3.** Step defs Cucumber-js: usa callbacks `Given/When/Then`; corpo lança `'PENDING'` ou `new Error('PENDING')` — sem falso-pass
- [ ] **C4.** Step defs SpecFlow: usa atributos `[Given]/[When]/[Then]`; corpo lança `PendingStepException` — sem falso-pass
- [ ] **C5.** 1 step def file por `.feature` (estrutura espelha spec/)

---

## Bloco D — TESTING-STRATEGY e README-TESTS (D21+D23)

- [ ] **D1.** `TESTING-STRATEGY.md` existe com ≥ 1 entrada **para cada RNF** de `03.2-qualidade.md` (deve ter tantas entradas quanto RNFs: 4 para Caso 1, 6 para Caso 2)
- [ ] **D2.** Cada entrada em `TESTING-STRATEGY.md` tem: categoria (Performance/Security/Usability/etc.), ferramenta sugerida, métrica, critério-aceite, framework alvo
- [ ] **D3.** `README-TESTS.md` existe com seção para Pytest-BDD (Python), Cucumber-js (JS/TS) e SpecFlow (.NET)
- [ ] **D4.** Cada seção do README tem: pré-requisitos + comando `install` + comando `run` + estrutura de pastas esperada

---

## Bloco E — Análise cross-artifact e rastreabilidade (D17)

- [ ] **E1.** `analyze-report.md` existe com resultados de `validacao-checklist-ireb` + `analyze-cross-artifact` + `rastreabilidade-matriz`
- [ ] **E2.** `analyze-report.md` sem issues CRITICAL ao abrir Gate 3 (D17 — CRITICAL bloqueia gate)
- [ ] **E3.** Issues HIGH/MEDIUM/LOW listados no report (não bloqueiam gate, apenas informativos)
- [ ] **E4.** `rastreabilidade.md` com colunas: Objetivo (M1) | RF/RNF (M2) | Seção SRS | Spec (.feature) | Test | Stakeholder origem

---

## Bloco F — Guardrail leigo (D1+D19)

- [ ] **F1.** `SRS-completo-leigo.md` sem termos da blacklist (grep: "requisito funcional|RF|elicitação|stakeholder|escopo|iteração|sprint|backlog|caso de uso|SRS|ERS|marco|sub-agente|skill|MoSCoW|Kano|baseline|gate|EARS|RFC|Gherkin|BDD|feature file|step def") — aplica SOMENTE a `SRS-completo-leigo.md` (artefatos técnicos spec/tests/ são versão única, sem versão leigo)
- [ ] **F2.** Perguntas apresentadas ao leigo no Gate 3 (aprovação SRS) sem termos da blacklist
- [ ] **F3.** `spec/`, `tests/`, `TESTING-STRATEGY.md`, `README-TESTS.md` **não** têm versão leigo (D18+D19 exceção artefatos técnicos)

---

## Bloco G — Controle do loop M3

- [ ] **G1.** Se `analyze-report.md` tinha CRITICAL: Gate 3 foi **bloqueado** e loop voltou ao documenter
- [ ] **G2.** Após correção pelo documenter: CRITICAL resolvido antes de Gate 3 abrir
- [ ] **G3.** Loop M3 encerrou em ≤ 3 iterações (teto do core/constitution.md)
- [ ] **G4.** Se loop atingiu 3 iterações com CRITICAL persistente: usuário foi consultado (yesno conforme core/constitution.md)

---

## Bloco H — Estado e integração

- [ ] **H1.** `estado-projeto.yaml` reflete `marco_corrente: M3` durante execução e `gate_status.gate_3: aprovado` após Gate 3
- [ ] **H2.** `estado-projeto.yaml` registra `gate_status.gate_3: aprovado` e `gate_3_aprovado_em` após aprovação do Gate 3
- [ ] **H3.** Artefatos M3 prontos para M4 (opcional): `spec/`, `tests/`, `TESTING-STRATEGY.md`, `README-TESTS.md` existem para revisão técnica do `checker` modo M4

---

## Bloco I — Progresso via TodoWrite (D27)

- [ ] **I1.** Ao iniciar M3, lista TodoWrite acrescenta sub-passos da Etapa 3 ao histórico (itens 3.1–3.6); primeiro item = `in_progress`
- [ ] **I2.** Cada bloco do documenter (3.1–3.3) tica `completed` e avança para o próximo ao concluir
- [ ] **I3.** Bloco checker (3.4) tica `completed` quando analyze-report sem CRITICAL
- [ ] **I4.** Loop-back CRITICAL: apenas item 3.4 ("Conferir se está tudo consistente") volta a `in_progress`; lista não é recriada
- [ ] **I5.** Ao aprovar Gate 3, todos os itens da Etapa 3 estão `completed`
- [ ] **I6.** Nenhum texto de todo contém termos da blacklist D1 (sem "skill", "marco", "gate", "stakeholder", "requisito", "SRS", "EARS", "Gherkin", nome interno de skill)

---

## Registro de execução

| Campo | Valor |
|---|---|
| Caso executado | `caso-N-<descritor>` |
| Plataforma | Claude Code |
| Data | AAAA-MM-DD |
| Executado por | |
| Resultado | PASSOU / FALHOU |
| Itens reprovados | (lista) |
| Observações | |
