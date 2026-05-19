# Plano de Conclusão do TCC

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Entregar o TCC completo até 2026-07-01, com ênfase na escrita (4 semanas) e compressão da fase de testes (2 semanas).

**Architecture:** Ferramenta já implementada (agentes, skills, adapters). Pendente: testes E2E, estudo de caso com stakeholder real, e redação do TCC. Escrita começa em S5 em paralelo ao estudo de caso — intro/fundamentação/metodologia não dependem dos resultados.

**Tech Stack:** Gemini CLI + Claude Code (adapters prontos); redação em Markdown/LaTeX; estudo de caso manual com stakeholder real.

---

## Situação atual (2026-05-18)

### Ferramenta — tudo implementado ✅
- `core/constitution.md`, `core/orchestrator.md`
- 5 sub-agentes completos (`stakeholder-identifier`, `collector`, `modeler`, `checker`, `documenter`)
- ~22 skills em `core/skills/`
- 3 workflows (`m1-visao.md`, `m2-requisitos.md`, `m3-srs-specs-tests.md`)
- Adapters `.claude/agents/` e `.gemini/agents/` para todos os marcos
- `tests/marco-{1,2,3}/casos.md` e `checklist.md` criados

### O que ainda falta
1. **Testes E2E** — M1, M2, M3 não executados
2. **Estudo de caso** — projeto real não definido, stakeholder não agendado
3. **Redação do TCC** — zero escrito

---

## Cronograma (6 semanas restantes)

### S3 restante — Testes E2E Marco 1 (18–26/mai) · 9 dias

**Objetivo:** Confirmar que M1 funciona em ambas as plataformas. Gate 1 funcionando = ferramenta validável.

- [ ] **Tarefa 1: Executar Caso 1 M1 (Gemini CLI)**
  - Abrir Gemini CLI com `ferramenta-tcc/` carregado
  - Digitar `/iniciar-projeto` com frase curta (ex: "Quero um app de receitas")
  - Preencher `tests/marco-1/checklist.md` linha-a-linha
  - Salvar resultado em `tests/marco-1/execucoes/execucao-01-frase-curta/`

- [ ] **Tarefa 2: Executar Caso 2 M1 (Gemini CLI)**
  - Mesma sequência com texto livre longo (Caso 2)
  - Salvar em `tests/marco-1/execucoes/execucao-02-texto-longo/`

- [ ] **Tarefa 3: Executar Caso 3 M1 — fluxo de revisão (Gemini CLI)**
  - Responder NÃO no Gate 1 → confirmar que revisão funciona → SIM
  - Salvar em `tests/marco-1/execucoes/execucao-03-revisao-gate/`

- [ ] **Tarefa 4: Repetir Casos 1–3 no Claude Code**
  - Mesma sequência com `/iniciar-projeto` via Claude Code
  - Confirmar que adapters `.claude/agents/` carregam corretamente
  - Salvar em `tests/marco-1/execucoes/execucao-0{4,5,6}-cc-*/`

- [ ] **Tarefa 5: Gate M1 — verificar blacklist D1**
  - Varrer `visao-produto.md` gerado manualmente
  - Confirmar: nenhum dos 11 termos proibidos (D1) aparece na versão leigo
  - Registrar qualquer ocorrência como bug em `tests/marco-1/bugs.md`

---

### S4 — Testes M2 + M3 + Reunião orientador (27/mai–02/jun) · 7 dias

**Objetivo:** Fechar testes de todos os marcos. Definir estudo de caso com orientador ESTA semana.

#### Testes E2E Marco 2 (27–29/mai)

- [ ] **Tarefa 6: Executar loop collector ⇄ modeler (Gemini CLI)**
  - Usar artefato `visao-produto.md` do Caso 1 de M1 como entrada
  - Confirmar que loop para quando `pautas-reelicitacao.md` está vazio
  - Salvar em `tests/marco-2/execucoes/execucao-01-loop/`

- [ ] **Tarefa 7: Testar bloqueio do Gate 2 (Gemini CLI)**
  - Forçar `pautas-reelicitacao.md` com pendências abertas
  - Confirmar gate bloqueado
  - Resolver pendências → confirmar gate abre
  - Salvar em `tests/marco-2/execucoes/execucao-02-gate-bloqueado/`

- [ ] **Tarefa 8: Verificar blacklist D1 nos artefatos M2**
  - Varrer `03.1-funcionais.md`, `03.2-qualidade.md`, `glossario.md` (versões leigo)
  - Registrar ocorrências em `tests/marco-2/bugs.md`

#### Testes E2E Marco 3 (30/mai–01/jun)

- [ ] **Tarefa 9: Executar loop documenter ⇄ checker (Gemini CLI)**
  - Usar artefatos M2 como entrada
  - Confirmar que `analyze-report.md` tem 0 CRITICAL antes do Gate 3
  - Salvar em `tests/marco-3/execucoes/execucao-01-loop/`

- [ ] **Tarefa 10: Verificar outputs completos de M3**
  - Checar: SRS com 6 seções IREB §3.3.3 ✓
  - Checar: `spec/*.feature` gerado para RFs `DEVE` ✓
  - Checar: `tests/{unit,acceptance}/` com step defs RED ✓
  - Checar: `TESTING-STRATEGY.md` com entradas por RNF ✓
  - Checar: `README-TESTS.md` cobrindo 3 frameworks ✓

#### Reunião com orientador (02/jun — CRÍTICO)

- [ ] **Tarefa 11: Definir estudo de caso**
  - Apresentar checklist de decisões em aberto (ver ROADMAP S5)
  - Fechar: projeto específico, domínio, quem é o stakeholder, número de sessões
  - Fechar: SRS de referência disponível ou avaliação só por rubrica IREB?
  - Fechar: quem avalia o SRS gerado (orientador/banca/rubrica)?
  - Registrar decisões em `docs/planejamento/7-decisoes-estudo-de-caso.md`

---

### S5 — Estudo de caso (03–09/jun) · 7 dias

**Objetivo:** Executar pipeline completo com stakeholder real. Iniciar escrita do TCC em paralelo.

- [ ] **Tarefa 12: Confirmar catálogo seed do domínio**
  - Se domínio diferente dos 5 existentes (edu/mobile/ecommerce/saude/dashboard): criar `catalogos-seed/dominios/<novo>.md`
  - Formato: clonar estrutura de `saude.md` como base

- [ ] **Tarefa 13: Sessão de elicitação com stakeholder real**
  - Executar `/iniciar-projeto` completo (M1→M2→M3) no Gemini CLI
  - Registrar cada sessão em `sessoes/S01.md`, `sessoes/S02.md` (se múltiplas)
  - Coletar: SRS final, artefatos intermediários, tempo por marco

- [ ] **Tarefa 14: Registrar métricas do estudo de caso**
  - Quantos itens implícitos aceitos pelo stakeholder
  - Quantos conflitos detectados e resolvidos
  - Quantas rodadas de revisão por gate
  - Salvar em `estudo-de-caso/metricas.md`

- [ ] **Tarefa 15: Iniciar escrita TCC — Introdução + Fundamentação teórica**
  - Seções que NÃO dependem dos resultados: escrever agora
  - **Introdução** (~1.000 palavras): motivação, problema, objetivo, estrutura
  - **Fundamentação teórica** (~2.500 palavras): IREB §3.3.3, EARS, RFC 2119, MARE, Problem-Based-SRS
  - Salvar rascunhos em `tcc/01-introducao.md`, `tcc/02-fundamentacao.md`

---

### S6 — Escrita: Metodologia + Ferramenta (10–16/jun) · 7 dias

**Objetivo:** Descrever o que foi construído com rigor acadêmico.

- [ ] **Tarefa 16: Escrever Metodologia (~1.500 palavras)**
  - Tipo de pesquisa (aplicada/exploratória/descritiva)
  - Protocolo do estudo de caso: critérios de seleção do projeto, perfil do stakeholder
  - Método de avaliação: rubrica IREB §3.8, checklist Livro 1
  - Salvar em `tcc/03-metodologia.md`

- [ ] **Tarefa 17: Escrever Descrição da Ferramenta (~3.000 palavras)**
  - Arquitetura: orquestrador + 5 sub-agentes + ~22 skills (diagrama Mermaid)
  - Marcos e gates (tabela do CLAUDE.md como base)
  - Decisões de design chave: D1, D6, D12, D18, D19 com justificativas
  - Skills transversais e catálogos seed
  - Salvar em `tcc/04-ferramenta.md`

- [ ] **Tarefa 18: Aplicar rubrica IREB §3.8 ao SRS gerado**
  - 6 critérios por requisito + 6 critérios por SRS
  - Tabela de conformidade para cada critério (atende/parcialmente/não atende)
  - Salvar em `estudo-de-caso/rubrica-ireb.md`

---

### S7 — Escrita: Resultados + Discussão (17–23/jun) · 7 dias

**Objetivo:** Apresentar e interpretar os resultados do estudo de caso.

- [ ] **Tarefa 19: Escrever Resultados (~2.000 palavras)**
  - SRS gerado: estrutura, contagem de requisitos por categoria (RF/RNF/restrição)
  - Métricas: itens implícitos aceitos, conflitos, sessões, tempo
  - Conformidade com IREB §3.8: tabela de resultados da rubrica
  - Comparação com checklist Livro 1
  - Salvar em `tcc/05-resultados.md`

- [ ] **Tarefa 20: Escrever Discussão (~1.500 palavras)**
  - Contribuições vs. Problem-Based-SRS (tabela comparativa já existe em Decisões Tomadas)
  - Limitações: o que a ferramenta não faz, casos onde falhou
  - Ameaças à validade: stakeholder único, domínio único
  - Trabalhos futuros: skills stretch, Gate M4, porte multi-plataforma
  - Salvar em `tcc/06-discussao.md`

- [ ] **Tarefa 21: Escrever Conclusão (~700 palavras)**
  - Objetivo atingido? (direto)
  - Contribuição principal (3 pontos)
  - Próximos passos
  - Salvar em `tcc/07-conclusao.md`

---

### S8 — Finalização (24/jun–01/jul) · 8 dias

**Objetivo:** Consolidar, revisar, entregar.

- [ ] **Tarefa 22: Consolidar documento final**
  - Juntar `tcc/0{1-7}-*.md` em documento único
  - Padronizar formatação, numeração, referências cruzadas

- [ ] **Tarefa 23: Escrever Referências**
  - IREB handbook, Wiegers, Livro SON, material Dani, RFC 2119, arXiv MARE, Gorski RESI 2016
  - Formato ABNT (TCC brasileiro)

- [ ] **Tarefa 24: Revisão ortográfica + consistência terminológica**
  - Verificar blacklist D1: termos proibidos não devem aparecer nas seções para leigo
  - Confirmar que siglas são definidas na primeira ocorrência

- [ ] **Tarefa 25: Enviar rascunho ao orientador**
  - Prazo interno: 27/jun (4 dias antes da entrega)
  - Incorporar feedback

- [ ] **Tarefa 26: Entrega final — 2026-07-01** 🎯

---

## Distribuição de tempo

| Fase | Semanas | Esforço |
|---|---|---|
| Testes E2E | S3–S4 (18/mai–02/jun) | 2 semanas |
| Estudo de caso | S5 (03–09/jun) | 1 semana |
| Escrita TCC | S5–S8 (03/jun–01/jul) | 4 semanas |

> Escrita começa em S5 (em paralelo ao estudo de caso) porque **introdução, fundamentação e metodologia não dependem dos resultados**.

---

## Riscos prioritários

| Risco | Impacto | Mitigação |
|---|---|---|
| Orientador indisponível para fechar estudo de caso | Bloqueia S5 | Agendar reunião AGORA para 02/jun |
| Stakeholder indisponível para S5 | Bloqueia dados reais | Fallback: caso simulado com persona detalhada |
| Testes M2/M3 revelam bugs críticos em S4 | Atrasa escrita | Triar bugs: CRITICAL corrige, HIGH documenta como limitação |
| Escrita demorar mais que previsto | Entrega incompleta | Priorizar: Introdução > Fundamentação > Descrição Ferramenta > Resultados; Discussão pode ser comprimida |
