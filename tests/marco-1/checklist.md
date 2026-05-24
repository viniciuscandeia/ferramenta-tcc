# Checklist de Verificação — Marco 1: Definição da Necessidade

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-1/execucoes/execucao-NN-<descritor>/`.

---

## Bloco A — Vision Box

- [ ] **A1.** `visao-produto-normativo.md` existe com campo "Produto/Nome" preenchido
- [ ] **A2.** Campo "Público-alvo" preenchido (≥ 1 grupo de usuário identificado)
- [ ] **A3.** Campo "Benefício principal" preenchido (valor que o produto entrega)
- [ ] **A4.** Campo "Diferencial" preenchido (por que não usar solução já existente)

---

## Bloco B — Situação-Problema

- [ ] **B1.** Seção "Problema" descrita em linguagem de negócio (o que está errado hoje)
- [ ] **B2.** "Afetados pelo problema" listados (≥ 1 grupo com impacto descrito)
- [ ] **B3.** "Solução esperada" descrita (o que o produto vai mudar)
- [ ] **B4.** "Usuários principais" identificados (quem vai usar o produto no dia a dia)
- [ ] **B5.** "Funcionalidades-chave" listadas (≥ 2 — o que o produto precisa fazer no mínimo)

---

## Bloco C — Stakeholders Mapeados

- [ ] **C1.** ≥ 1 stakeholder com papel definido (usuário direto / decisor / afetado indireto)
- [ ] **C2.** Decisor/aprovador identificado (quem diz "sim" para o produto ser construído)
- [ ] **C3.** Stakeholders mencionados pelo usuário no texto inicial foram preservados (sem omissão silenciosa)

---

## Bloco D — Contexto e Limites

- [ ] **D1.** Seção "Está dentro do escopo" com ≥ 2 funcionalidades confirmadas
- [ ] **D2.** Seção "Está fora do escopo" com ≥ 1 item explicitamente excluído
- [ ] **D3.** Restrições externas identificadas (legal, técnica ou organizacional) — se mencionadas pelo usuário
- [ ] **D4.** Integrações externas (outros sistemas, hardware, APIs) listadas — se aplicável

---

## Bloco E — Guardrail Leigo (D1 + D19)

- [ ] **E1.** `visao-produto-leigo.md` sem termos da blacklist (grep: "requisito funcional|RF|RNF|elicitação|stakeholder|escopo|iteração|sprint|backlog|caso de uso|SRS|ERS|marco|sub-agente|skill|MoSCoW|Kano|baseline|gate|EARS|RFC|Gherkin|BDD")
- [ ] **E2.** Perguntas feitas ao usuário durante M1 não contêm termos da blacklist
- [ ] **E3.** Termos de ER em `visao-produto-normativo.md` **não** aparecem na versão leigo (as duas versões são distintas)

---

## Bloco F — Versão Normativa (IREB §3.3.3)

- [ ] **F1.** `visao-produto-normativo.md` tem estrutura de seções compatível com IREB §3.3.3 Parte I (visão + contexto)
- [ ] **F2.** Stakeholders listados com papéis no formato técnico (nome, papel, interesse, decisor: sim/não)
- [ ] **F3.** Contexto e limites distinguem claramente requisitos dentro vs. fora do escopo
- [ ] **F4.** Restrições (se presentes) classificadas por tipo (legal / técnica / organizacional)

---

## Bloco G — Comportamento de `clarificacao-pos-visao` (D16)

- [ ] **G1.** Se input inicial tinha ≥ 2 lacunas críticas: `clarificacao-pos-visao` foi **ativada** (≤ 3 perguntas adicionais)
- [ ] **G2.** Se input inicial era rico (≤ 1 lacuna crítica): `clarificacao-pos-visao` **não ativada** (sem perguntas extras)
- [ ] **G3.** `clarificacao-pos-visao`, quando ativada, usou ≤ 1 chamada `AskUserQuestion` com ≤ 3 perguntas (D14+D16)

---

## Bloco H — Gate 1 e Estado

- [ ] **H1.** Gate 1 apresenta `visao-produto-leigo.md` ao usuário (nunca a normativa)
- [ ] **H2.** Input "Não" no Gate 1 **não avança** para M2; registra `gate_status.gate_1: pendente`
- [ ] **H3.** Feedback do usuário após "Não" é incorporado nas versões revisadas
- [ ] **H4.** Segunda apresentação do Gate 1 com versão revisada (ciclo de revisão funciona)
- [ ] **H5.** Input "Sim" no Gate 1 → `gate_status.gate_1: aprovado` e `gate_1_aprovado_em` registrados em `estado-projeto.yaml`
- [ ] **H6.** `estado-projeto.yaml` reflete `marco_corrente: M1-concluido` e lista `visao-produto-normativo.md` + `visao-produto-leigo.md` em `artefatos`

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
