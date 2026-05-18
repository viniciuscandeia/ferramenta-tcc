# Workflow M1 — Definição da Necessidade

**Sub-agente responsável:** `stakeholder-identifier`
**Entrada:** Projeto novo (ou retomada de M1 incompleto)
**Saída:** `visao-produto-normativo.md` + `visao-produto-leigo.md`
**Gate de saída:** Gate 1 — usuário aprova versão leigo

---

## SEQUÊNCIA DE EXECUÇÃO

```
ENTRADA
  │
  ▼
[1] vision-box
  │  → Gera: Seção "Visão do Produto"
  │  → Perguntas: nome, público-alvo, benefício, diferencial (1 lote de 4)
  ▼
[2] situacao-problema
  │  → Gera: Seção "Situação-Problema"
  │  → Perguntas: problema, afetados, impacto, solução (lote 1 de 4)
  │             + usuários principais, funcionalidades-chave (lote 2 de 2)
  ▼
[3] stakeholder-mapping
  │  → Gera: Seção "Pessoas Envolvidas"
  │  → Perguntas: usuários adicionais, decisores, afetados indiretos, restritos (1 lote de 4)
  ▼
[4] contexto-e-limite
  │  → Gera: Seção "Contexto e Limites"
  │  → Perguntas: o que faz, o que não faz, integrações, restrições (1 lote de 4)
  │  → Retorna: relatório de lacunas críticas por categoria
  ▼
[5] clarificacao-pos-visao  ← CONDICIONAL (D16)
  │  Ativar SE: lacunas críticas em ≥ 2 categorias
  │  Não ativar SE: lacunas em 0 ou 1 categoria
  │  → Máximo 1 chamada AskUserQuestion, 3 perguntas, choice/yesno
  │  → Atualiza visao-produto.md inline
  ▼
[5.5] vision-box Fase 2.5  ← CONDICIONAL (slots pendentes)
  │  Ativar SE: `_pendencias.md` tem `vision-box: benefício pendente` OU `vision-box: diferencial pendente`
  │  → Inferir slot do contexto M1 coletado; confirmar via ask_user (3 opções)
  │  → Remover pendência se confirmado; manter `[a definir]` se não confirmado
  ▼
[6] traducao-gate
  │  → Gera: visao-produto-normativo.md (IREB §3.3.3)
  │  → Gera: visao-produto-leigo.md (linguagem de negócio)
  │  → Aplica traducao-leigo sobre versão leigo
  ▼
[GATE 1] — Orquestrador apresenta versão leigo ao usuário
  │  SIM → Baseline git, avançar M2
  └─ NÃO → Retornar ao passo [1] ou [N] com feedback específico
```

---

## DETALHES DE CADA PASSO

### [1] vision-box
- Invocar skill `core/skills/vision-box/SKILL.md`
- Input: nenhum (primeira interação com o usuário)
- Output: seção "Visão do Produto"
- Perguntas ao usuário: **2 sub-lotes** (cada um = 1 tool call `ask_user`/`AskUserQuestion`):
  - Sub-lote A: nome + público-alvo
  - Sub-lote B: benefício + diferencial — cada um com opção choice "Ainda não pensei nisso"
- Se usuário pular benefício ou diferencial: registrar `vision-box: [slot] pendente` em `_pendencias.md`; slot preenchido com `[a definir]`

### [2] situacao-problema
- Invocar skill `core/skills/situacao-problema/SKILL.md`
- Input: seção "Visão do Produto" (contexto)
- Output: seção "Situação-Problema"
- Perguntas ao usuário: 2 lotes (4 + 2)

### [3] stakeholder-mapping
- Invocar skill `core/skills/stakeholder-mapping/SKILL.md`
- Input: "Visão do Produto" + "Situação-Problema" (pré-popular com nomes já mencionados)
- Output: seção "Pessoas Envolvidas"
- Perguntas ao usuário: 1 lote de 4

### [4] contexto-e-limite
- Invocar skill `core/skills/contexto-e-limite/SKILL.md`
- Input: todos os artefatos anteriores
- Output: seção "Contexto e Limites" + relatório de lacunas
- Perguntas ao usuário: 1 lote de 4

### [5] clarificacao-pos-visao (condicional — D16)
- Verificar: quantas categorias do relatório de lacunas têm lacuna crítica?
- SE ≥ 2: invocar skill `core/skills/clarificacao-pos-visao/SKILL.md`
- SE < 2: pular; ir direto para [6]
- Perguntas ao usuário: máximo 1 chamada com 3 perguntas choice/yesno

### [6] traducao-gate
- Invocar skill `core/skills/traducao-gate/SKILL.md`
- Input: todos os artefatos M1 compilados
- Output: `visao-produto-normativo.md` + `visao-produto-leigo.md`
- Salvar ambos na pasta do projeto
- Atualizar `estado-projeto.yaml`

---

## ARTEFATOS GERADOS

| Arquivo | Versão | Tamanho esperado |
|---|---|---|
| `visao-produto-normativo.md` | IREB §3.3.3 | 300–600 palavras |
| `visao-produto-leigo.md` | Linguagem de negócio | 200–400 palavras |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto ao usuário (D19)
- Batching ≤ 4 perguntas por `AskUserQuestion` (D14)
- Nunca mencionar "requisito", "elicitação", "stakeholder", "escopo" ao usuário
- Se usuário abortar ou desconectar: salvar `.draft` do artefato em andamento

---

## TRANSIÇÕES DE ESTADO

| Momento | Estado em estado-projeto.yaml |
|---|---|
| Início do workflow | `marco_corrente: M1`, `gate_status.gate_1: pendente` |
| Após passo [6] | `artefatos: [visao-produto-normativo.md, visao-produto-leigo.md]` |
| Gate 1 aprovado | `gate_status.gate_1: aprovado`, `versao_leigo_aprovada: [visao-produto-leigo.md]` |
| Gate 1 reprovado | `gate_status.gate_1: pendente` (permanece; usuário forneceu feedback) |
