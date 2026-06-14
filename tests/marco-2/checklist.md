# Checklist de Verificação — Marco 2: Consenso de Escopo

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-2/execucoes/execucao-NN-<descritor>/`.

---

## Bloco A — Estrutura de artefatos

- [ ] **A1.** `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` gerado pelo collector (arquivo interno, não-gate)
- [ ] **A2.** `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` existe com ≥ 1 RF em formato EARS com o modal (`DEVE`/`DEVERIA`/`PODE`) embutido na frase (sem coluna "Modal" separada)
- [ ] **A3.** `documentos-para-leigo/02-requisitos/02.1-requisitos-funcionais.md` existe (versão leigo correspondente)
- [ ] **A4.** `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` existe com ≥ 1 RNF mensurável (com métrica explícita)
- [ ] **A5.** `documentos-para-leigo/02-requisitos/02.2-requisitos-qualidade.md` existe (versão leigo correspondente)
- [ ] **A6.** `documentos-tecnicos/02-requisitos/02.3-restricoes.md` existe com restrições classificadas por tipo (legal / técnica / organizacional)
- [ ] **A7.** `documentos-para-leigo/02-requisitos/02.3-restricoes.md` existe (versão leigo correspondente)
- [ ] **A8.** `documentos-tecnicos/02-requisitos/02.5-glossario.md` existe com ≥ 5 termos (cada um com definição + exemplos)
- [ ] **A9.** `documentos-tecnicos/02-requisitos/02.6-pautas-reelicitacao.md` existe (pode estar vazio — Gate 2 requer que esteja vazio ou com todos `[x]`)

---

## Bloco B — Qualidade dos artefatos

- [ ] **B1.** ≥ 1 RF com prioridade `Essencial` em `02.1-requisitos-funcionais.md` (sem nenhum Essencial = erro de priorização)
- [ ] **B2.** ≥ 1 RNF com métrica verificável em `02.2-requisitos-qualidade.md` (ex: "tempo de resposta < 2s para 95% das requisições")
- [ ] **B3.** Restrições em `02.3-restricoes.md` classificadas corretamente (não misturadas com RNFs)
- [ ] **B4.** Cada item de `02.1-requisitos-funcionais.md` tem: ID único, descrição EARS (com verbo de obrigatoriedade embutido), prioridade MoSCoW (coluna "Prioridade") — **sem** coluna "Modal" separada
- [ ] **B5.** `02.5-glossario.md` tem ≥ 1 termo que aparecia sem definição na `02-elicitacao-raw.md` (anti-ambiguidade Wiegers Ch11)

---

## Bloco C — Controle do loop

- [ ] **C1.** Se `02.6-pautas-reelicitacao.md` estava não-vazio após Fase B: Gate 2 foi **bloqueado** e loop voltou ao collector
- [ ] **C2.** Após resolução das pautas: `02.6-pautas-reelicitacao.md` final sem itens `[ ]` em aberto
- [ ] **C3.** Loop M2 encerrou por convergência (`02.6-pautas-reelicitacao.md` sem `[ ]`) ou por decisão explícita do usuário (sem teto fixo — `content/constitution.md`)
- [ ] **C4.** Se o loop chegou à 3ª rodada com pauta ainda aberta: usuário foi consultado (yesno conforme `content/constitution.md`)

---

## Bloco D — Guardrail leigo (D1 + D19)

- [ ] **D1.** `documentos-para-leigo/02-requisitos/02.1-requisitos-funcionais.md` sem termos da blacklist (grep: "requisito funcional|RF|elicitação|stakeholder|escopo|iteração|sprint|backlog|caso de uso|SRS|ERS|marco|sub-agente|skill|MoSCoW|Kano|baseline|gate|EARS|RFC|Gherkin|BDD")
- [ ] **D2.** `documentos-para-leigo/02-requisitos/02.2-requisitos-qualidade.md` sem termos da blacklist
- [ ] **D3.** `documentos-para-leigo/02-requisitos/02.3-restricoes.md` sem termos da blacklist
- [ ] **D4.** Perguntas feitas ao usuário durante M2 não contêm termos da blacklist

---

## Bloco E — Arquivos condicionais

- [ ] **E1.** Se `conflitos-detect` detectou ≥ 1 conflito: `02.7-conflitos-detectados.md` foi criado com tipo + estratégia de resolução
- [ ] **E2.** Se `modeler` detectou premissas implícitas: `02.4-premissas.md` foi criado
- [ ] **E3.** Ausência de arquivos condicionais quando não aplicável (não criar arquivo vazio)

---

## Bloco F — Estado e integração

- [ ] **F1.** `estado-projeto.yaml` reflete `marco_corrente: M2` durante execução e `gate_status.gate_2: aprovado` após Gate 2
- [ ] **F2.** `estado-projeto.yaml` registra `gate_status.gate_2: aprovado` e `gate_2_aprovado_em` após aprovação do Gate 2
- [ ] **F3.** Artefatos M2 compatíveis com entrada esperada de M3: `02.1-requisitos-funcionais.md` com modais RFC 2119 preenchidos para `requisito-ears`

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
