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

- [ ] **B1.** ≥ 1 RF com modal `DEVE` em `03.1-funcionais.md` (necessário para M3 gerar Gherkin — D20)
- [ ] **B2.** ≥ 1 RNF com métrica verificável em `03.2-qualidade.md` (ex: "tempo de resposta < 2s para 95% das requisições")
- [ ] **B3.** Restrições em `03.3-restricoes.md` classificadas corretamente (não misturadas com RNFs)
- [ ] **B4.** Cada item de `03.1-funcionais.md` tem: ID único, modal, descrição EARS, prioridade MoSCoW
- [ ] **B5.** `glossario.md` tem ≥ 1 termo que aparecia sem definição na elicitacao-raw.md (anti-ambiguidade Wiegers Ch11)

---

## Bloco C — Controle do loop

- [ ] **C1.** Se `pautas-reelicitacao.md` estava não-vazio após Fase B: Gate 2 foi **bloqueado** e loop voltou ao collector
- [ ] **C2.** Após resolução das pautas: `pautas-reelicitacao.md` final sem itens `[ ]` em aberto
- [ ] **C3.** Loop M2 encerrou em ≤ 3 iterações (teto do constitution.md)
- [ ] **C4.** Se loop atingiu 3 iterações com pauta ainda aberta: usuário foi consultado (yesno conforme constitution.md)

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
- [ ] **F3.** Artefatos M2 compatíveis com entrada esperada de M3: `03.1-funcionais.md` tem RFs com `DEVE` para `gherkin-spec` (D20)

---

## Registro de execução

| Campo | Valor |
|---|---|
| Caso executado | `caso-N-<descritor>` |
| Plataforma | Gemini CLI / Claude Code |
| Data | AAAA-MM-DD |
| Executado por | |
| Resultado | PASSOU / FALHOU |
| Itens reprovados | (lista) |
| Observações | |
