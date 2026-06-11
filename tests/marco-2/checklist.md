# Checklist de Verificação — Marco 2: Consenso de Escopo

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-2/execucoes/execucao-NN-<descritor>/`.

---

## Bloco A — Estrutura de artefatos

- [ ] **A1.** `elicitacao-raw.md` gerado pelo collector (arquivo interno, não-gate)
- [ ] **A2.** `03.1-funcionais.md` existe com ≥ 1 RF em formato EARS + modal RFC 2119 (`DEVE`/`DEVERIA`/`PODE`)
- [ ] **A3.** `03.1-funcionais-leigo.md` existe (versão leigo correspondente)
- [ ] **A4.** `03.2-qualidade.md` existe com ≥ 1 RNF mensurável (com métrica explícita)
- [ ] **A5.** `03.2-qualidade-leigo.md` existe (versão leigo correspondente)
- [ ] **A6.** `03.3-restricoes.md` existe com restrições classificadas por tipo (legal / técnica / organizacional)
- [ ] **A7.** `03.3-restricoes-leigo.md` existe (versão leigo correspondente)
- [ ] **A8.** `glossario.md` existe com ≥ 5 termos (cada um com definição + exemplos)
- [ ] **A9.** `pautas-reelicitacao.md` existe (pode estar vazio — Gate 2 requer que esteja vazio ou com todos `[x]`)

---

## Bloco B — Qualidade dos artefatos

- [ ] **B1.** ≥ 1 RF com modal `DEVE` em `03.1-funcionais.md` (sem nenhum DEVE = erro de priorização)
- [ ] **B2.** ≥ 1 RNF com métrica verificável em `03.2-qualidade.md` (ex: "tempo de resposta < 2s para 95% das requisições")
- [ ] **B3.** Restrições em `03.3-restricoes.md` classificadas corretamente (não misturadas com RNFs)
- [ ] **B4.** Cada item de `03.1-funcionais.md` tem: ID único, modal, descrição EARS, prioridade MoSCoW
- [ ] **B5.** `glossario.md` tem ≥ 1 termo que aparecia sem definição na elicitacao-raw.md (anti-ambiguidade Wiegers Ch11)

---

## Bloco C — Controle do loop

- [ ] **C1.** Se `pautas-reelicitacao.md` estava não-vazio após Fase B: Gate 2 foi **bloqueado** e loop voltou ao collector
- [ ] **C2.** Após resolução das pautas: `pautas-reelicitacao.md` final sem itens `[ ]` em aberto
- [ ] **C3.** Loop M2 encerrou em ≤ 3 iterações (teto do core/constitution.md)
- [ ] **C4.** Se loop atingiu 3 iterações com pauta ainda aberta: usuário foi consultado (yesno conforme core/constitution.md)

---

## Bloco D — Guardrail leigo (D1 + D19)

- [ ] **D1.** `03.1-funcionais-leigo.md` sem termos da blacklist (grep: "requisito funcional|RF|elicitação|stakeholder|escopo|iteração|sprint|backlog|caso de uso|SRS|ERS|marco|sub-agente|skill|MoSCoW|Kano|baseline|gate|EARS|RFC|Gherkin|BDD")
- [ ] **D2.** `03.2-qualidade-leigo.md` sem termos da blacklist
- [ ] **D3.** `03.3-restricoes-leigo.md` sem termos da blacklist
- [ ] **D4.** Perguntas feitas ao usuário durante M2 não contêm termos da blacklist

---

## Bloco E — Arquivos condicionais

- [ ] **E1.** Se `conflitos-detect` detectou ≥ 1 conflito: `conflitos-detectados.md` foi criado com tipo + estratégia de resolução
- [ ] **E2.** Se `modeler` detectou premissas implícitas: `03.4-premissas.md` foi criado
- [ ] **E3.** Ausência de arquivos condicionais quando não aplicável (não criar arquivo vazio)

---

## Bloco F — Estado e integração

- [ ] **F1.** `estado-projeto.yaml` reflete `marco_corrente: M2` durante execução e `gate_status.gate_2: aprovado` após Gate 2
- [ ] **F2.** `estado-projeto.yaml` registra `gate_status.gate_2: aprovado` e `gate_2_aprovado_em` após aprovação do Gate 2
- [ ] **F3.** Artefatos M2 compatíveis com entrada esperada de M3: `03.1-funcionais.md` com modais RFC 2119 preenchidos para `requisito-ears`

---

## Bloco G — Progresso via TodoWrite (D27)

- [ ] **G1.** Ao iniciar M2, lista TodoWrite acrescenta sub-passos da Etapa 2 ao histórico (itens 2.1 + 2.6–2.8 iniciais); primeiro item da Etapa 2 = `in_progress`
- [ ] **G2.** Rodadas 2.1–2.5 semeadas progressivamente (item da rodada só aparece quando a rodada é iniciada, não todas de uma vez)
- [ ] **G3.** Item 2.6 ("Organizar e definir o que é mais importante") avança para `in_progress` após a Rodada 1 e volta a `in_progress` em cada iteração de modeler
- [ ] **G4.** Ao aprovar Gate 2, todos os itens da Etapa 2 estão `completed` antes de semear a Etapa 3
- [ ] **G5.** Loop-back (pautas abertas): apenas o item 2.6 (e rodada collector afetada) volta a `in_progress`; lista não é recriada
- [ ] **G6.** Nenhum texto de todo contém termos da blacklist D1 (sem "skill", "marco", "gate", "stakeholder", "requisito", "elicitação", nome interno de skill)

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
