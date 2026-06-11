# Checklist de Verificação — Marco 3: Detalhamento (SRS)

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-3/execucoes/execucao-NN-<descritor>/`.

> **Nota v0.22.0:** blocos de specs Gherkin, step definitions e estratégia de testes removidos junto com o pipeline de testes.

---

## Bloco A — SRS estrutura IREB §3.3.3

- [ ] **A1.** `documentos-tecnicos/03-documento/03-srs-completo.md` existe com as seções IREB §3.3.3: (1) Introdução, (2) Descrição Geral, (3) Requisitos Funcionais, (4) Requisitos de Qualidade, (5) Interfaces externas, (6) Rastreabilidade — + §7 Conflitos (condicional) e §8 Glossário
- [ ] **A2.** `documentos-para-leigo/03-documento/03-documento-do-projeto.md` existe (versão leigo gerada por `traducao-gate`)
- [ ] **A3.** Seção 3 do SRS contém todos os RFs de `02.1-requisitos-funcionais.md` em formato EARS + RFC 2119
- [ ] **A4.** Seção 4 do SRS contém todos os RNFs de `02.2-requisitos-qualidade.md` com métricas preservadas
- [ ] **A5.** Seção 5 do SRS referencia restrições de `02.3-restricoes.md`; §8 contém o glossário de `02.5-glossario.md`

---

## Bloco B — Diagramas (modelagem-visual)

- [ ] **B1.** `documentos-tecnicos/03-documento/03.3-diagramas.md` existe com diagrama de Contexto + Caso de Uso (ER condicional: glossário ≥ 3 entidades)
- [ ] **B2.** Todos os blocos Mermaid têm sintaxe válida (renderizam sem erro)
- [ ] **B3.** Bloco `<!-- LEIGO-SAFE-START/END -->` presente com rótulos em linguagem de negócio (sem jargão D1)
- [ ] **B4.** Diagramas embutidos no SRS: contexto em §2.1, caso de uso em §3, ER em §4 (ou nota de omissão explícita)

---

## Bloco C — Análise cross-artifact e rastreabilidade (D17)

- [ ] **C1.** `03.1-analyze-report.md` existe com resultados de `validacao-checklist-ireb` + `analyze-cross-artifact` + gaps de `rastreabilidade-matriz`
- [ ] **C2.** `03.1-analyze-report.md` sem issues CRITICAL ao abrir Gate 3 (D17 — CRITICAL bloqueia gate)
- [ ] **C3.** Issues HIGH/MEDIUM/LOW listados no report (não bloqueiam gate, apenas informativos)
- [ ] **C4.** `03.2-rastreabilidade.md` com colunas: Objetivo (M1) | RF/RNF | Modal | Seção SRS | Stakeholder origem
- [ ] **C5.** Resumo de Gaps presente na matriz (mesmo que zerado)

---

## Bloco D — Guardrail leigo (D1+D19)

- [ ] **D1.** `03-documento-do-projeto.md` sem termos da blacklist (grep: "requisito funcional|RF|elicitação|stakeholder|escopo|iteração|sprint|backlog|caso de uso|SRS|ERS|marco|sub-agente|skill|MoSCoW|Kano|baseline|gate|EARS|RFC|Gherkin|BDD")
- [ ] **D2.** Perguntas apresentadas ao leigo no Gate 3 (aprovação do documento) sem termos da blacklist
- [ ] **D3.** Artefatos internos (`03.1-analyze-report.md`, `03.2-rastreabilidade.md`, `03.3-diagramas.md`) **não** têm versão leigo separada (exceção D18+D19); bloco leigo-safe dos diagramas embutido no documento leigo

---

## Bloco E — Controle do loop M3

- [ ] **E1.** Se `03.1-analyze-report.md` tinha CRITICAL: Gate 3 foi **bloqueado** e loop voltou ao documenter
- [ ] **E2.** Após correção pelo documenter: CRITICAL resolvido antes de Gate 3 abrir
- [ ] **E3.** A partir da 3ª rodada com CRITICAL persistente: usuário foi consultado (yesno conforme `content/constitution.md`)
- [ ] **E4.** Documenter em modo correção re-executou **apenas** as skills afetadas (não refez toda a Fase A)

---

## Bloco F — Estado e integração

- [ ] **F1.** `estado-projeto.yaml` reflete `marco_corrente: M3` durante execução e `gate_status.gate_3: aprovado` após Gate 3
- [ ] **F2.** `estado-projeto.yaml` registra `gate_3_aprovado_em` após aprovação do Gate 3
- [ ] **F3.** `loop_m3_iteracoes ≥ 1` registrado; `modelagem_visual_gerada: true` se diagramas existem
- [ ] **F4.** Commit git do gate registrado (`git_track.sh`) se git disponível

---

## Bloco G — Progresso via TodoWrite (D27)

- [ ] **G1.** Ao iniciar M3, lista TodoWrite acrescenta sub-passos da Etapa 3 ao histórico (itens 3.1–3.6); primeiro item = `in_progress`
- [ ] **G2.** Cada passo do documenter (3.1–3.3) tica `completed` e avança para o próximo ao concluir
- [ ] **G3.** Bloco checker (3.4) tica `completed` quando analyze-report sem CRITICAL
- [ ] **G4.** Loop-back CRITICAL: apenas item 3.4 ("Conferir se está tudo consistente") volta a `in_progress`; lista não é recriada
- [ ] **G5.** Ao aprovar Gate 3, todos os itens da Etapa 3 estão `completed`
- [ ] **G6.** Nenhum texto de todo contém termos da blacklist D1 (sem "skill", "marco", "gate", "stakeholder", "requisito", "SRS", "EARS", nome interno de skill)

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
