---
name: testing-strategy
description: Gera TESTING-STRATEGY.md com 1 entrada por RNF de 03.2-qualidade.md. Cada entrada define: categoria do bucket Wiegers (Performance/Security/Usability/Reliability/Maintainability/Portability/Privacy+Compliance/Accessibility), ferramenta sugerida, métrica alvo, critério de aceite e framework de teste alvo. Referência: D21.
when_to_use: Invocada pelo documenter como Passo 5 do Processo M3. Entrada: 03.2-qualidade.md. Saída: TESTING-STRATEGY.md com entrada por RNF.
---

# Skill: testing-strategy

Gera `TESTING-STRATEGY.md` mapeando cada RNF de qualidade a uma estratégia de teste concreta:
bucket Wiegers, ferramenta sugerida, métrica alvo, critério de aceite e framework de teste.

---

## Processo (3 passos)

1. Ler `03.2-qualidade.md` — obter todos os RNFs com bucket, métrica e modal
2. Para cada RNF: consultar a tabela de mapeamento abaixo e determinar a ferramenta sugerida
3. Para cada RNF: escrever entrada em `TESTING-STRATEGY.md` usando o template de saída

---

## Tabela de mapeamento: bucket → ferramenta sugerida

| Bucket | Ferramenta(s) sugerida(s) |
|---|---|
| Desempenho (Performance) | k6, Locust, Apache JMeter |
| Capacidade/Escalabilidade | k6, Gatling |
| Disponibilidade/Confiabilidade | Pingdom, UptimeRobot (monitoramento) + testes de failover |
| Segurança | OWASP ZAP, Burp Suite Community, Snyk |
| Usabilidade | Teste de usuário manual (roteiro + métricas de tarefa) |
| Manutenibilidade | SonarQube (cobertura de testes), revisão de código |
| Portabilidade | BrowserStack, Sauce Labs (multi-plataforma) |
| Privacidade/Conformidade (LGPD/GDPR) | Auditoria manual + relatório DPIA |
| Acessibilidade | axe-core, WAVE, Lighthouse accessibility |

---

## Template de saída — TESTING-STRATEGY.md

O arquivo gerado deve seguir exatamente esta estrutura:

```markdown
# Estratégia de Testes

## [RNF-ID] — [Bucket]

**Descrição:** [descrição do RNF conforme 03.2-qualidade.md]
**Métrica alvo:** [métrica original de 03.2-qualidade.md — manter verbatim]
**Critério de aceite:** [métrica convertida em critério binário pass/fail]
**Ferramenta sugerida:** [ferramenta da tabela de mapeamento]
**Framework de teste:** [Pytest-BDD / Cucumber-js / SpecFlow — escolher o mais adequado ao critério]
**Tipo de teste:** [Unitário / Integração / Performance / Segurança / Acessibilidade / Manual]
```

### Exemplo de entrada

```markdown
## RNF-001 — Desempenho (Performance)

**Descrição:** O sistema deve responder a consultas de catálogo em tempo adequado para uso mobile.
**Métrica alvo:** Tempo de resposta ≤ 2s para 95% das requisições sob carga de 100 usuários simultâneos.
**Critério de aceite:** PASS se p95 ≤ 2000 ms no relatório k6; FAIL caso contrário.
**Ferramenta sugerida:** k6
**Framework de teste:** Pytest-BDD (script k6 invocado via subprocess)
**Tipo de teste:** Performance
```

---

## Regras

- **1 entrada por RNF** — a contagem de entradas em `TESTING-STRATEGY.md` deve ser igual à contagem de RNFs em `03.2-qualidade.md`
- **Sem interação com o usuário** — skill opera inteiramente sobre artefatos do sistema de arquivos
- **Manter a métrica original verbatim** no campo "Métrica alvo" — não parafrasear
- **Usar português** nas descrições e campos de texto livre
- **Critério de aceite** deve ser binário (PASS/FAIL) com condição mensurável derivada da métrica alvo
