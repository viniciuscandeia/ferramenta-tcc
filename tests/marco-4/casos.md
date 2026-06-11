# Casos de Teste — Marco 4 (Revisão Técnica)

> Marco 4 é opcional. Cada caso parte de um workspace M3 pré-populado (fixture).
> Persona: tech lead. Gate 4: aprovação técnica.

---

## Caso 1 — Aprovação Direta (happy path)

**Descritor:** `caso-1-aprovacao-direta`
**Domínio:** varejo / controle de estoque
**Complexidade:** baixa — SRS completo, sem ambiguidades críticas

### Entrada inicial do usuário

```
Olá! Podemos revisar tecnicamente o documento gerado?
```

### Comportamento esperado — sequência de skills

1. **`analyze-cross-artifact`**: varredura técnica completa (Visão ↔ Elicitação ↔ SRS) — sem issues.
2. **`validacao-checklist-ireb`**: 12 critérios IREB §3.8 sobre o SRS — conformidade plena.
3. **`rastreabilidade-matriz`**: rastreabilidade completa M1 → spec.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `documentos-tecnicos/04-revisao/04.1-revisao-tecnica.md` | Sim | Sim |
| `documentos-tecnicos/04-revisao/04.2-aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação

- Revisão técnica em `04.1-revisao-tecnica.md` sem CRITICAL
- Aprovação técnica (`04.2-aprovacao-tecnica.md`) assinada pelo tech lead persona

---

## Caso 2 — Revisão com Refatoração

**Descritor:** `caso-2-refatoracao`
**Domínio:** varejo / controle de estoque
**Complexidade:** média — SRS com 2 ambiguidades detectáveis

### Entrada inicial do usuário

```
Vamos revisar tecnicamente? Quero garantir que está tudo claro para implementar.
```

### Comportamento esperado — sequência de skills

1. **`analyze-cross-artifact`**: cross-check detecta 2 issues MEDIUM.
2. **`validacao-checklist-ireb`**: detecta ambiguidades (IREB §3.8).
3. **`rastreabilidade-matriz`**: rastreabilidade M1 → spec com lacunas anotadas.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `documentos-tecnicos/04-revisao/04.1-revisao-tecnica.md` | Sim | Sim |
| `documentos-tecnicos/04-revisao/04.2-aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação

- Revisão em `04.1-revisao-tecnica.md` lista os 2 issues detectados
- Gate 4 aprovado após resolução (tech lead diz Sim)

---

## Caso 3 — Rejeição Técnica (CORTÁVEL)

**Descritor:** `caso-3-rejeicao-tecnica`
**Domínio:** varejo / controle de estoque
**Complexidade:** alta — SRS com CRITICAL blocker

### Entrada inicial do usuário

```
Por favor, fazer revisão técnica do documento.
```

### Comportamento esperado — sequência de skills

1. **`analyze-cross-artifact`**: detecta CRITICAL blocker.
2. **`validacao-checklist-ireb`**: confirma violação de critério IREB §3.8.
3. **`rastreabilidade-matriz`**: rastreabilidade com lacuna ligada ao CRITICAL.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `documentos-tecnicos/04-revisao/04.1-revisao-tecnica.md` | Sim | Sim |
| `documentos-tecnicos/04-revisao/04.2-aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação (CORTÁVEL)

- Gate 4 nega na primeira tentativa
- Segunda passagem resolve o CRITICAL
- Aprovado na segunda tentativa
