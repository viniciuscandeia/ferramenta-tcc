---
name: classificacao-rf-rnf
description: Classifica itens de elicitacao-raw.md nos tipos RF (o que faz), RNF (como se comporta), Restrição (escolha imposta) e Premissa (pressuposto aceito). Gera rascunhos de 03.1-funcionais.md, 03.2-qualidade.md, 03.3-restricoes.md e 03.4-premissas.md (condicional). Segue IREB §1.1 e 9 buckets Wiegers Ch7.
when_to_use: Invocada pelo modeler no Passo 1 da Fase B do workflow M2. Entrada obrigatória: elicitacao-raw.md completo.
---

# Skill: classificacao-rf-rnf

**Referências:** IREB §1.1 · Wiegers Software Requirements Ch7 (9 quality attribute buckets)
**Marco:** M2 — Consenso de Escopo (Fase B, Passo 1)
**Invocada por:** `modeler`

---

## TIPOS DE ITEM (definições canônicas)

| Tipo | Pergunta-guia | Exemplo leigo |
|---|---|---|
| **RF — Requisito Funcional** | "O que o sistema precisa fazer?" | "O sistema DEVE permitir que o usuário faça login" |
| **RNF — Requisito Não-Funcional** | "Como o sistema precisa se comportar?" | "O sistema DEVE responder em < 2s para 95% das requisições" |
| **Restrição** | "Qual decisão está imposta de fora — tecnologia, lei, prazo, orçamento?" | "O sistema DEVE cumprir a LGPD (Lei 13.709/2018)" |
| **Premissa** | "O que estamos assumindo sem ter confirmação?" | "Assumimos que todos os usuários têm smartphone com Android 10+" |

**Distinção RNF vs Restrição:** RNF descreve qualidade mensurável de comportamento (performance, disponibilidade, usabilidade). Restrição é uma escolha imposta externamente que o sistema não pode ignorar (lei, tecnologia mandatória, prazo fixo, orçamento).

---

## BUCKETS DE QUALIDADE (Wiegers Ch7 — para RNFs)

Ao classificar RNFs, identificar qual bucket se aplica:

| # | Bucket | Métrica-base |
|---|---|---|
| 1 | Desempenho | tempo de resposta, throughput, latência |
| 2 | Capacidade/Escalabilidade | usuários simultâneos, volume de dados |
| 3 | Disponibilidade/Confiabilidade | uptime %, MTBF, MTTR |
| 4 | Segurança | nível de autenticação, criptografia, OWASP |
| 5 | Usabilidade | tempo de aprendizado, taxa de erro do usuário |
| 6 | Manutenibilidade | tempo para corrigir bug, cobertura de testes |
| 7 | Portabilidade | plataformas suportadas, formatos de arquivo |
| 8 | Privacidade/Conformidade | leis aplicáveis (LGPD, GDPR, etc.) |
| 9 | Acessibilidade | nível WCAG, suporte a tecnologias assistivas |

---

## PROCESSO

### Entrada

- `elicitacao-raw.md` (completo — produzido pelo collector)
- `visao-produto-normativo.md` (contexto do domínio e stakeholders)

### Algoritmo de classificação

Para cada item em `elicitacao-raw.md`:

1. **RF:** O item descreve uma ação ou funcionalidade que o sistema executa?
   - SIM → classificar como RF; atribuir ID `RF-NNN`
   - NÃO → continuar

2. **RNF:** O item descreve uma qualidade de comportamento mensurável (um dos 9 buckets)?
   - SIM → classificar como RNF; atribuir ID `RNF-NNN`; identificar bucket
   - Se não tem métrica explícita → marcar como lacuna para `pautas-reelicitacao`
   - NÃO → continuar

3. **Restrição:** O item descreve uma escolha imposta de fora (lei, tecnologia, prazo, orçamento)?
   - SIM → classificar como Restrição; atribuir ID `REST-NNN`; classificar subtipo: legal / técnica / organizacional / temporal
   - NÃO → continuar

4. **Premissa:** O item é um pressuposto não-verificado que afeta o escopo?
   - SIM → classificar como Premissa; atribuir ID `PREM-NNN`
   - NÃO → descartar (item irrelevante ou já coberto por outro)

### Sem interação com usuário nesta skill

Classificação é feita pelo modelo sem perguntas ao usuário. Itens ambíguos são marcados com flag `[AMBÍGUO]` para revisão pelo modeler.

---

## SAÍDA

### 03.1-funcionais.md (rascunho)

```markdown
# Funcionalidades do Sistema (rascunho)

| ID | Descrição | Modal | MoSCoW | Fonte |
|---|---|---|---|---|
| RF-001 | [descrição em EARS] | DEVE/DEVERIA/PODE | — | elicitacao-raw §N |
| RF-002 | ... | ... | — | ... |
```

*Campo Modal preenchido na skill `priorizacao` (Passo 2).*
*Campo MoSCoW preenchido na skill `priorizacao` (Passo 2).*

### 03.2-qualidade.md (rascunho)

```markdown
# Qualidade e Comportamento do Sistema (rascunho)

| ID | Bucket | Descrição | Métrica | Modal | Fonte |
|---|---|---|---|---|---|
| RNF-001 | Desempenho | [descrição] | [métrica ou LACUNA] | DEVE | ... |
```

### 03.3-restricoes.md (rascunho)

```markdown
# Restrições do Projeto (rascunho)

| ID | Subtipo | Descrição | Origem | Fonte |
|---|---|---|---|---|
| REST-001 | legal | LGPD — dados pessoais devem ter consentimento explícito | Lei 13.709/2018 | ... |
```

### 03.4-premissas.md (rascunho — só se detectadas)

```markdown
# Premissas Aceitas (rascunho)

| ID | Descrição | Impacto se falsa |
|---|---|---|
| PREM-001 | [premissa] | [o que muda no escopo] |
```

---

## REGRAS DE QUALIDADE

- Todo RF deve ter exatamente um sujeito, um verbo de ação, e um objeto (estrutura EARS mínima)
- Todo RNF sem métrica explícita → criar pauta em `pautas-reelicitacao.md` (lacuna a resolver)
- Não duplicar: se dois itens de `elicitacao-raw.md` descrevem a mesma coisa, consolidar em 1 item com ambas as fontes anotadas
- IDs sequenciais e estáveis: RF-001, RF-002... (não renumerar entre iterações)
