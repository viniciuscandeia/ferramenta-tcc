# Checklist de Verificação — Marco 1: Definição da Necessidade (v0.7.0)

**Critério de "passou":** todos os itens `[x]` abaixo.
Preencher após execução de cada caso em `tests/marco-1/execucoes/execucao-NN-<descritor>/`.

---

## Bloco A — Documento de Visão (ISO 29148)

- [ ] **A1.** `documentos-tecnicos/01-visao/01-visao-produto.md` existe e não está vazio
- [ ] **A2.** Seção `## 1. Visão` presente com frase-síntese estilo Moore (Para [quem]... o [produto] é... que... Diferente de... ele...)
- [ ] **A3.** Seção `## 2. Problema & Necessidade` presente com: dor real, quem sofre, impacto concreto (sem lista de solução/features)
- [ ] **A4.** Seção `## 3. Objetivos e Metas de Sucesso` presente (pode ter campos `[a definir]` se usuário não soube responder)
- [ ] **A5.** Seção `## 4. Pessoas Envolvidas` presente com tabela Stakeholder Onion (colunas: Papel | Camada | Interesse | Influência | Decisor)
- [ ] **A6.** Seção `## 5. Contexto e Limites` presente com: dentro / fora (≥1 exclusão) / integrações / restrições
- [ ] **A7.** Seção `## 6. Premissas e Itens em Aberto` presente

---

## Bloco B — Qualidade do Conteúdo

- [ ] **B1.** Seção 2 NÃO contém lista de funcionalidades ou proposta de solução (disciplina problema-space)
- [ ] **B2.** Seção 2 descreve a DOR RAIZ, não apenas o sintoma (indica que 5-Whys foi aplicado)
- [ ] **B3.** Decisor identificado na tabela (Camada "Decide-paga", coluna "Decisor: Sim") — ou justificativa em Seção 6
- [ ] **B4.** Pelo menos 1 exclusão explícita em "O que o produto NÃO faz" (Seção 5)
- [ ] **B5.** Restrições da Seção 5 têm tipo especificado (Legal / Técnica / Prazo / Orçamento / Organizacional)
- [ ] **B6.** Se domínio regulado detectado (saúde / finanças / educação / alimentos): Camada "Regula" presente na tabela (Seção 4) E ao menos 1 restrição Legal na Seção 5

---

## Bloco C — Disciplina de Elicitação

- [ ] **C1.** Total de perguntas feitas ao usuário ≤ 13 (base ~7-10; +≤3 com clarificação condicional)
- [ ] **C2.** Fase de descoberta usou 1 pergunta por turno (não lotes de 4 na fase de 5-Whys)
- [ ] **C3.** Nenhuma pergunta de solução/feature durante a Fase de descoberta do problema (apenas após síntese)
- [ ] **C4.** `stakeholder-mapping` pré-preencheu a tabela com pessoas mencionadas antes de perguntar (sem re-perguntar quem já foi nomeado)
- [ ] **C5.** `contexto-e-limite` não re-perguntou "o que o produto faz" — inferiu e confirmou via choice

---

## Bloco D — Comportamento de `clarificacao-pos-visao` (D16)

- [ ] **D1.** Se `estado-projeto.yaml → lacunas_m1.contagem ≥ 2`: `clarificacao-pos-visao` foi **ativada** (≤3 perguntas)
- [ ] **D2.** Se `lacunas_m1.contagem < 2`: `clarificacao-pos-visao` **não ativada** (sem perguntas extras)
- [ ] **D3.** `clarificacao-pos-visao`, quando ativada, usou ≤1 chamada com ≤3 perguntas (choice/yesno, sem `text` para escopo/restrições)
- [ ] **D4.** Perguntas de clarificação usaram dados REAIS do projeto (sem placeholders `[X]` literais)

---

## Bloco E — Guardrail Leigo (D1 + D19)

- [ ] **E1.** `documentos-para-leigo/01-visao/01-visao-produto.md` existe e não está vazio
- [ ] **E2.** Versão leigo sem termos da blacklist: `grep -iE "requisito funcional|RF|RNF|elicitação|stakeholder|\bescopo\b|\bgate [0-9]\b|iteração|sprint|backlog|caso de uso|SRS|ERS|\bmarco [0-9]\b|sub-agente|skill|MoSCoW|Kano|baseline|EARS|RFC|Gherkin|BDD"` retorna 0 resultados
- [ ] **E3.** Perguntas feitas ao usuário durante M1 não contêm termos da blacklist
- [ ] **E4.** Versão leigo é PROSA NARRATIVA (não cópia parafraseada das seções técnicas da versão normativa — estrutura diferente)
- [ ] **E5.** As duas versões são arquivos distintos com estrutura diferente

---

## Bloco F — Estado (`estado-projeto.yaml`)

- [ ] **F1.** Após `contexto-e-limite` executar: `lacunas_m1` presente no yaml (com `categorias` e `contagem`)
- [ ] **F2.** `pautas_abertas` corretamente preenchida (papéis `[a identificar]` registrados)
- [ ] **F3.** Gate 1 SIM → `gate_status.gate_1: aprovado`, `gate_1_aprovado_em` e `marco_corrente: M2` no yaml
- [ ] **F4.** Gate 1 NÃO → `gate_status.gate_1: pendente` (marco NÃO avança para M2)
- [ ] **F5.** Após Gate 1 aprovado: `versao_leigo_aprovada` contém `documentos-para-leigo/01-visao/01-visao-produto.md`

---

## Bloco G — Enforcement (`gate_guard.sh`)

- [ ] **G1.** Tentativa de escrever `gate_status.gate_1: aprovado` sem artefatos existentes → bloqueado pelo hook (`exit 2`)
- [ ] **G2.** Tentativa de escrever artefato M2 enquanto `marco_corrente: M1` → bloqueado pelo hook
- [ ] **G3.** Nome de arquivo inválido (ex: `srs.md`, `necessidades.md`) → bloqueado pelo hook

---

## Bloco H — Gate 1 e Ciclo de Revisão

- [ ] **H1.** Gate 1 apresenta `documentos-para-leigo/01-visao/01-visao-produto.md` ao usuário (nunca a normativa)
- [ ] **H2.** Input "Não" no Gate 1 **não avança** para M2
- [ ] **H3.** Feedback do usuário após "Não" é incorporado nas versões revisadas
- [ ] **H4.** Segunda apresentação do Gate 1 com versão revisada funciona (ciclo completo)

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
| Perguntas totais feitas | (contar) |
| Observações | |
