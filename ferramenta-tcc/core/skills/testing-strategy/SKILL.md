---
name: testing-strategy
marco: [M3]
description: >-
  Define como cada comportamento de qualidade (desempenho, segurança, usabilidade etc.) será testado — com ferramenta, métrica e critério de aprovação para cada um.
  Use no Marco 3, após gerar os cenários de teste, para produzir o plano de estratégia de testes de qualidade.
  Generate TESTING-STRATEGY.md with 1 entry per RNF; maps to Wiegers bucket, tool, metric, and accept criterion; no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de mensurabilidade** — "testar desempenho" não é estratégia. "Carga de 100 usuários simultâneos, p95 ≤ 2s via k6, PASS/FAIL binário" é estratégia. Critério sem número mensurável não é critério.
2. **1 entrada por RNF, sem exceção.** RNF com modal PODE ainda precisa de entrada — a estratégia é documentada mesmo para itens opcionais.
3. **Preservar a métrica original verbatim.** Não parafrasear a métrica de `03.2-qualidade.md`. O critério de aceite deriva da métrica, mas a métrica original fica intacta.

<HARD-GATE>
- NÃO executar sem Gate 2 aprovado (verificar `03.2-qualidade.md` com itens e campo Métrica preenchido)
- ⛔ STOP se contagem de entradas em `TESTING-STRATEGY.md` ≠ contagem de RNFs em `03.2-qualidade.md`
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `03.2-qualidade.md` existe com itens e campo Métrica preenchido
3. Contar RNFs para verificação de completude na Fase 2

## Fase 1 — Mapeamento bucket → ferramenta

Para cada RNF de `03.2-qualidade.md`, consultar tabela de mapeamento:

| Bucket | Ferramenta(s) sugerida(s) |
|---|---|
| Desempenho (Performance) | k6, Locust, Apache JMeter |
| Capacidade/Escalabilidade | k6, Gatling |
| Disponibilidade/Confiabilidade | Pingdom, UptimeRobot + testes de failover |
| Segurança | OWASP ZAP, Burp Suite Community, Snyk |
| Usabilidade | Teste de usuário manual (roteiro + métricas de tarefa) |
| Manutenibilidade | SonarQube (cobertura de testes), revisão de código |
| Portabilidade | BrowserStack, Sauce Labs |
| Privacidade/Conformidade (LGPD/GDPR) | Auditoria manual + relatório DPIA |
| Acessibilidade | axe-core, WAVE, Lighthouse |

## Fase 2 — Geração de Entradas

Para cada RNF: gerar entrada com template:

```markdown
## [RNF-ID] — [Bucket]

**Descrição:** [descrição do RNF conforme 03.2-qualidade.md]
**Métrica alvo:** [métrica original verbatim de 03.2-qualidade.md]
**Critério de aceite:** [métrica convertida em critério binário PASS/FAIL]
**Ferramenta sugerida:** [ferramenta da tabela de mapeamento]
**Framework de teste:** [Pytest-BDD / Cucumber-js / SpecFlow — o mais adequado]
**Tipo de teste:** [Unitário / Integração / Performance / Segurança / Acessibilidade / Manual]
```

**Exemplo:**
```markdown
## RNF-001 — Desempenho (Performance)

**Descrição:** O sistema deve responder a consultas de catálogo em tempo adequado para uso mobile.
**Métrica alvo:** Tempo de resposta ≤ 2s para 95% das requisições sob carga de 100 usuários simultâneos.
**Critério de aceite:** PASS se p95 ≤ 2000 ms no relatório k6; FAIL caso contrário.
**Ferramenta sugerida:** k6
**Framework de teste:** Pytest-BDD (script k6 invocado via subprocess)
**Tipo de teste:** Performance
```

## Fase 3 — Saída

Criar `TESTING-STRATEGY.md`:

```markdown
# Estratégia de Testes

[Entradas por RNF — 1 por RNF de 03.2-qualidade.md]
```

Verificar: contagem entradas == contagem RNFs. Se divergir: ⛔ STOP.

Sinalizar ao `documenter`: testing-strategy concluído → prosseguir para `readme-tests` (Passo 6).

<!-- internal -->
## Anti-Padrão: RNF com Modal PODE Omitido

**Como acontece:** A skill filtra apenas RNFs com modal `DEVE` por analogia com `gherkin-spec`. RNFs com `PODE` não recebem entrada. `TESTING-STRATEGY.md` tem menos linhas que `03.2-qualidade.md`.

**Como detectar:** Contagem de entradas ≠ contagem de RNFs totais (incluindo DEVERIA e PODE).

**O que fazer:** Todos os RNFs entram em `TESTING-STRATEGY.md`, independente do modal. O campo "Tipo de teste" pode ser "Manual (não prioritário)" para itens com modal PODE — mas a entrada existe e é rastreável.
<!-- /internal -->
