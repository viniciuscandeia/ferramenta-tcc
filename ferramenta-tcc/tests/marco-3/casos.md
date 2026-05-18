# Casos de Teste — Marco 3: Detalhamento (SRS + Specs + Tests)

Três casos canônicos para verificação do workflow M3 (`documenter` ⇄ `checker`).
Cada caso pressupõe artefatos M1 + M2 já aprovados (simulados).

---

## Caso 1 — E-commerce Pequeno

**Descritor:** `caso-1-ecommerce`
**Domínio:** `ecommerce`
**Complexidade:** baixa (caminho linear — sem loop M3)

### Artefatos M2 simulados (input M3)

```
03.1-funcionais.md: 10 RFs — 6 com modal DEVE, 3 DEVERIA, 1 PODE
03.2-qualidade.md: 4 RNFs mensuráveis (performance, segurança, LGPD, mobile)
03.3-restricoes.md: 3 restrições (orçamento, LGPD, mobile-first)
glossario.md: 8 termos
```

### Comportamento esperado — documenter (Fase A)

1. `requisito-ears`: 10 RFs + 4 RNFs formatados com EARS + RFC 2119 (sujeito + modal + verbo + objeto + condição)
2. `srs-ireb-template`: SRS com 6 seções IREB §3.3.3 preenchidas; seção 5 (Interfaces) pode ser parcial se não elicitado
3. `gherkin-spec`: 6 `.feature` (1 por RF com `DEVE`) + `_skipped.md` com 4 RFs (3 DEVERIA + 1 PODE)
4. `step-defs-red`: 6 step def files — estado RED garantido (NotImplementedError/PENDING/PendingStepException) em 3 frameworks (Pytest-BDD, Cucumber-js, SpecFlow)
5. `testing-strategy`: 4 entradas (1 por RNF) com categoria, ferramenta, métrica, critério-aceite
6. `readme-tests`: 3 seções (Pytest-BDD, Cucumber-js, SpecFlow) com comandos install/run

### Comportamento esperado — checker (Fase B)

1. `validacao-checklist-ireb`: aplica 6+6 critérios IREB §3.8 — esperado: 0 issues CRITICAL
2. `analyze-cross-artifact`: cruza Visão↔Elicitação↔SRS — esperado: 0 CRITICAL (caminho limpo)
3. `rastreabilidade-matriz`: matriz preenchida (10 RFs rastreados até spec/test)

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `SRS-completo.md` | Sim | Sim (6 seções IREB §3.3.3) |
| `SRS-completo-leigo.md` | Sim | Sim (sem termos blacklist) |
| `analyze-report.md` | Sim | Sim (sem CRITICAL) |
| `rastreabilidade.md` | Condicional | Sim |
| `TESTING-STRATEGY.md` | Sim | Sim (4 entradas) |
| `README-TESTS.md` | Sim | Sim (3 frameworks) |
| `spec/*.feature` | Sim | 6 arquivos |
| `spec/_skipped.md` | Sim | Sim (4 RFs não-DEVE) |
| `tests/unit/` | Sim | Sim (RED) |
| `tests/acceptance/` | Sim | Sim (RED) |
| `revisao-tecnica.md` | Condicional (M4) | Não esperado |
| `aprovacao-tecnica.md` | Condicional (M4) | Não esperado |

---

## Caso 2 — App Educação Infantil

**Descritor:** `caso-2-educacao`
**Domínio:** `educacao`
**Complexidade:** média (RNFs ricos: LGPD menores + acessibilidade; múltiplos stakeholders)

### Artefatos M2 simulados (input M3)

```
03.1-funcionais.md: 14 RFs — 8 DEVE, 4 DEVERIA, 2 PODE
03.2-qualidade.md: 6 RNFs (acessibilidade WCAG, LGPD menores, desempenho tablet básico, modo offline, privacidade, controle parental)
03.3-restricoes.md: 4 restrições (interface só visual/áudio para crianças; LGPD arts. 14-15; acessibilidade obrigatória; iOS + Android)
glossario.md: 12 termos
conflitos-detectados.md: 1 conflito (criança quer mais jogos vs. pai limita tempo de tela)
```

Nota: `conflitos-detectados.md` herdado do M2 (conflito criança vs. pai detectado pelo `conflitos-detect`). O `documenter` DEVE referenciar este conflito na seção de Restrições/Premissas do SRS.

### Comportamento esperado — documenter

1. `requisito-ears`: 14 RFs + 6 RNFs em EARS — incluindo RNF de acessibilidade com slot "Enquanto [usuário com deficiência visual]"
2. `srs-ireb-template`: SRS com seção 4 (RNF) detalhada por categoria (acessibilidade, privacidade, performance)
3. `gherkin-spec`: 8 `.feature` para RFs DEVE + `_skipped.md` com 6 RFs
4. `step-defs-red`: 8 step def files RED (3 frameworks) (Pytest-BDD, Cucumber-js, SpecFlow)
5. `testing-strategy`: 6 entradas — acessibilidade (WAVE/axe), LGPD (auditoria manual), performance (Lighthouse ≥ 90), modo offline (Cypress), privacidade (auditoria código), controle parental (teste funcional)
6. `readme-tests`: 3 seções + nota sobre LGPD (testes não coletam dados reais de crianças)

### Comportamento esperado — checker

1. `validacao-checklist-ireb`: pode gerar MEDIUM/LOW (conflito não resolvido registrado como HIGH), sem CRITICAL
2. `analyze-cross-artifact`: cruzamento detecta que conflito de stakeholder em M1 está registrado em M2 mas não tem resolução no SRS — gera HIGH (não bloqueia)
3. `rastreabilidade-matriz`: 14 RFs rastreados; 8 com spec (DEVE), 6 apontando para `_skipped.md`

### Critério de aceitação do Gate 3 (Caso 2)

- `analyze-report.md` sem CRITICAL (HIGH por conflito não-resolvido não bloqueia)
- `SRS-completo-leigo.md` sem "LGPD" nu (deve aparecer como "proteção de dados de crianças")
- Step defs RED confirmados (nenhum test passa — só estrutura)

---

## Caso 3 — Loop M3 com CRITICAL (teste do loop documenter ⇄ checker) ⚠️ CORTÁVEL

**Descritor:** `caso-3-loop-m3`
**Complexidade:** alta (testa loop onde checker devolve CRITICAL para documenter corrigir)
**Status:** **Cortável** — adiar se Casos 1 e 2 cobrirem caminho linear satisfatoriamente.

### Cenário

Input M2 simulado: sistema de agendamento de consultas médicas.
Documenter gera SRS inicial com RF faltando spec (RF-007 "o sistema DEVE enviar confirmação por e-mail" sem `.feature` correspondente).

### Issues injetados (para testar loop)

```
CRITICAL: RF-007 (DEVE) sem spec correspondente em spec/ — analyze-cross-artifact detecta
```

### Comportamento esperado

1. `checker` retorna CRITICAL → Gate 3 **bloqueado**
2. Orquestrador retorna ao `documenter` com lista de correções: "gerar spec/rf-007-confirmacao-email.feature"
3. `documenter` executa apenas `gherkin-spec` focado no RF-007 + `step-defs-red` para o novo feature
4. `checker` revalida: CRITICAL resolvido → Gate 3 **abre**

### Critério de aceitação

- Loop encerrou em ≤ 2 iterações
- `analyze-report.md` final sem CRITICAL
- `spec/rf-007-confirmacao-email.feature` existe e é válido Gherkin
- Correspondente step def RED nos 3 frameworks
