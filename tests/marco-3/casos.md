# Casos de Teste — Marco 3: Detalhamento (SRS)

Três casos canônicos para verificação do workflow M3 (`documenter` ⇄ `checker`).
Cada caso pressupõe artefatos M1 + M2 já aprovados (simulados).

> **Nota v0.22.0:** o pipeline de specs/testes (gherkin-spec, step-defs-red, testing-strategy, readme-tests) foi removido da ferramenta. M3 entrega SRS + diagramas + validação + rastreabilidade.

---

## Caso 1 — E-commerce Pequeno

**Descritor:** `caso-1-ecommerce`
**Domínio:** `ecommerce`
**Complexidade:** baixa (caminho linear — sem loop M3)

### Artefatos M2 simulados (input M3)

```
02.1-requisitos-funcionais.md: 10 RFs — 6 com modal DEVE, 3 DEVERIA, 1 PODE
02.2-requisitos-qualidade.md: 4 RNFs mensuráveis (performance, segurança, LGPD, mobile)
02.3-restricoes.md: 3 restrições (orçamento, LGPD, mobile-first)
02.5-glossario.md: 8 termos
```

### Comportamento esperado — documenter (Fase A)

1. `requisito-ears`: 10 RFs + 4 RNFs formatados com EARS + RFC 2119 (sujeito + modal + verbo + objeto + condição)
2. `modelagem-visual`: `03.3-diagramas.md` com diagrama de contexto + caso de uso + ER (8 termos ≥ 3 entidades) + bloco leigo-safe
3. `srs-ireb-montagem`: SRS com 8 seções IREB §3.3.3 (6 obrigatórias + §7 condicional ausente sem conflitos + §8 glossário); diagramas embutidos em §2.1, §3 e §4
4. `traducao-gate`: `03-documento-do-projeto.md` (versão leigo) com seção visual

### Comportamento esperado — checker (Fase B)

1. `validacao-checklist-ireb`: aplica 6+6 critérios IREB §3.8 — esperado: 0 issues CRITICAL
2. `analyze-cross-artifact`: cruza Visão↔Elicitação e Elicitação↔SRS — esperado: 0 CRITICAL (caminho limpo)
3. `rastreabilidade-matriz`: matriz preenchida (10 RFs + 4 RNFs rastreados até seção do SRS e stakeholder)

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `documentos-tecnicos/03-documento/03-srs-completo.md` | Sim | Sim (8 seções IREB §3.3.3) |
| `documentos-para-leigo/03-documento/03-documento-do-projeto.md` | Sim | Sim (sem termos blacklist) |
| `documentos-tecnicos/03-documento/03.1-analyze-report.md` | Sim | Sim (sem CRITICAL) |
| `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` | Condicional | Sim |
| `documentos-tecnicos/03-documento/03.3-diagramas.md` | Condicional | Sim (3 diagramas + leigo-safe) |
| `documentos-tecnicos/04-revisao/04.1-revisao-tecnica.md` | Condicional (M4) | Não esperado |
| `documentos-tecnicos/04-revisao/04.2-aprovacao-tecnica.md` | Condicional (M4) | Não esperado |

---

## Caso 2 — App Educação Infantil

**Descritor:** `caso-2-educacao`
**Domínio:** `educacao`
**Complexidade:** média (RNFs ricos: LGPD menores + acessibilidade; múltiplos stakeholders)

### Artefatos M2 simulados (input M3)

```
02.1-requisitos-funcionais.md: 14 RFs — 8 DEVE, 4 DEVERIA, 2 PODE
02.2-requisitos-qualidade.md: 6 RNFs (acessibilidade WCAG, LGPD menores, desempenho tablet básico, modo offline, privacidade, controle parental)
02.3-restricoes.md: 4 restrições (interface só visual/áudio para crianças; LGPD arts. 14-15; acessibilidade obrigatória; iOS + Android)
02.5-glossario.md: 12 termos
02.7-conflitos-detectados.md: 1 conflito (criança quer mais jogos vs. pai limita tempo de tela)
```

Nota: `02.7-conflitos-detectados.md` herdado do M2 (conflito criança vs. pai detectado pelo `conflitos-detect`). O `documenter` DEVE incluir este conflito como §7 do SRS.

### Comportamento esperado — documenter

1. `requisito-ears`: 14 RFs + 6 RNFs em EARS — incluindo RNF de acessibilidade com slot "Enquanto [usuário com deficiência visual]"
2. `modelagem-visual`: diagramas com múltiplos atores (criança, pai, professor) no caso de uso
3. `srs-ireb-montagem`: SRS com seção 4 (RNF) detalhada por categoria (acessibilidade, privacidade, performance) + §7 com o conflito herdado
4. `traducao-gate`: versão leigo sem "LGPD" nu (deve aparecer como "proteção de dados de crianças")

### Comportamento esperado — checker

1. `validacao-checklist-ireb`: pode gerar MEDIUM/LOW (conflito não resolvido registrado como HIGH), sem CRITICAL
2. `analyze-cross-artifact`: cruzamento detecta que conflito de stakeholder em M1 está registrado em M2 mas não tem resolução no SRS — gera HIGH (não bloqueia)
3. `rastreabilidade-matriz`: 14 RFs + 6 RNFs rastreados até seção do SRS e stakeholder origem

### Critério de aceitação do Gate 3 (Caso 2)

- `03.1-analyze-report.md` sem CRITICAL (HIGH por conflito não-resolvido não bloqueia)
- `03-documento-do-projeto.md` sem "LGPD" nu (deve aparecer como "proteção de dados de crianças")
- §7 do SRS presente com o conflito e estratégia de resolução

---

## Caso 3 — Loop M3 com CRITICAL (teste do loop documenter ⇄ checker) ⚠️ CORTÁVEL

**Descritor:** `caso-3-loop-m3`
**Complexidade:** alta (testa loop onde checker devolve CRITICAL para documenter corrigir)
**Status:** **Cortável** — adiar se Casos 1 e 2 cobrirem caminho linear satisfatoriamente.

### Cenário

Input M2 simulado: sistema de agendamento de consultas médicas.
Documenter gera SRS inicial com RF ausente (RF-007 "o sistema DEVE enviar confirmação por e-mail" presente em `02.1-requisitos-funcionais.md` mas omitido da seção 3 do SRS).

### Issues injetados (para testar loop)

```
CRITICAL: RF-007 (DEVE) ausente na seção 3 do SRS — analyze-cross-artifact detecta (Cruzamento 2: Omissão)
```

### Comportamento esperado

1. `checker` retorna CRITICAL → Gate 3 **bloqueado**
2. Orquestrador retorna ao `documenter` com lista de correções: "incluir RF-007 na seção 3 do SRS"
3. `documenter` executa apenas `requisito-ears` (RF-007) + `srs-ireb-montagem` (remontagem da seção 3) + `traducao-gate`
4. `checker` revalida: CRITICAL resolvido → Gate 3 **abre**

### Critério de aceitação

- Loop encerrou em ≤ 2 iterações
- `03.1-analyze-report.md` final sem CRITICAL
- RF-007 presente na seção 3 do SRS em formato EARS + RFC 2119
- Matriz de rastreabilidade final sem "❌" para RF-007
