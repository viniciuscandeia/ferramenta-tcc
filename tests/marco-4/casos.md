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

1. **`validacao-checklist-ireb`**: verifica conformidade IREB §3.3.3.
2. **`analyze-cross-artifact`**: verifica consistência entre artefatos.
3. **`traducao-gate`**: gera versão de aprovação técnica.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `03-documento/revisao-tecnica.md` | Sim | Sim |
| `03-documento/aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação

- Revisão técnica sem CRITICAL no analyze-report
- Aprovação técnica assinada pelo tech lead persona

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

1. **`validacao-checklist-ireb`**: detecta ambiguidades.
2. **`analyze-cross-artifact`**: cross-check falha (2 MEDIUM issues).
3. **`traducao-gate`**: gera versão com issues listados.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `03-documento/revisao-tecnica.md` | Sim | Sim |
| `03-documento/aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação

- Revisão lista os 2 issues detectados
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

1. **`validacao-checklist-ireb`**: detecta CRITICAL.
2. **`analyze-cross-artifact`**: confirma blocker.
3. **`traducao-gate`**: apresenta para aprovação com CRITICAL destacado.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `03-documento/revisao-tecnica.md` | Sim | Sim |
| `03-documento/aprovacao-tecnica.md` | Sim | Sim |
| `estado-projeto.yaml` | Sim | Sim |

### Critério de aceitação (CORTÁVEL)

- Gate 4 nega na primeira tentativa
- Segunda passagem resolve o CRITICAL
- Aprovado na segunda tentativa
