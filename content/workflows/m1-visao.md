# Workflow M1 — Definição da Necessidade

**Sub-agente responsável:** `stakeholder-identifier`
**Entrada:** Projeto novo (ou retomada de M1 incompleto)
**Saída:** `documentos-tecnicos/01-visao/01-visao-produto.md` (Documento de Visão ISO 29148) + `documentos-para-leigo/01-visao/01-visao-produto.md` (prosa de negócio)
**Gate de saída:** Gate 1 — usuário aprova versão leigo

---

## SEQUÊNCIA DE EXECUÇÃO

```
ENTRADA
  │
  ▼
[1] necessidade-visao
  │  → Gera: Seções "## 1. Visão", "## 2. Problema & Necessidade", "## 3. Objetivos e Metas"
  │  → Perguntas: problema (5-Whys, 1-3 turnos adaptativos) + nome/público (1 lote de 2) + meta (1)
  │  → Disciplina problema-space: PROIBIDO mencionar solução/features durante descoberta
  ▼
[2] stakeholder-mapping
  │  → Gera: Seção "## 4. Pessoas Envolvidas" (tabela Stakeholder Onion)
  │  → Perguntas: checklist de camadas pré-preenchido da Fase 0 (1 lote, ≤ 4 perguntas)
  │  → Persiste: pendência de decisor em pautas_abertas se não identificado
  ▼
[3] contexto-e-limite
  │  → Gera: Seção "## 5. Contexto e Limites"
  │  → Perguntas: fora-do-escopo + integrações (se não inferidas) + restrições (1 lote, ≤ 3)
  │  → Confirmação: dentro inferido apresentado em choice (1 turno)
  │  → Persiste: lacunas_m1 em estado-projeto.yaml
  ▼
[4] clarificacao-pos-visao  ← CONDICIONAL (D16)
  │  Ativar SE: estado-projeto.yaml → lacunas_m1.contagem ≥ 2
  │  Não ativar SE: lacunas_m1.contagem < 2
  │  → Máximo 1 chamada AskUserQuestion, ≤ 3 perguntas (choice/yesno)
  │  → Atualiza seções existentes inline (não cria arquivo novo)
  ▼
[5] traducao-gate
  │  → Lê template core/templates/01-documento-visao.md para Fase 1 (M1 — sem EARS)
  │  → Gera: documentos-tecnicos/01-visao/01-visao-produto.md (Documento de Visão ISO 29148)
  │  → Gera: documentos-para-leigo/01-visao/01-visao-produto.md (prosa narrativa de negócio)
  │  → Aplica traducao-leigo sobre versão leigo
  ▼
[GATE 1] — Orquestrador apresenta versão leigo ao usuário
  │  SIM → Avançar M2
  └─ NÃO → Retornar ao passo [1], [2], [3] ou [4] conforme feedback específico
             (clarificacao-pos-visao pode ser re-ativada sem guarda de idempotência)
```

---

## DETALHES DE CADA PASSO

### [1] necessidade-visao
- Invocar skill 'necessidade-visao'
- Input: texto inicial do usuário (se fornecido via `/iniciar-projeto`); usar para pré-extração
- Output: seções `## 1. Visão`, `## 2. Problema & Necessidade`, `## 3. Objetivos e Metas de Sucesso`
- Modo: **problema-primeiro** (5-Whys → JTBD → síntese Moore confirmada)
- Uma pergunta por turno na fase de descoberta (Fase 1 da skill)
- Lote compacto só nas Fases 2 e 3 (campos independentes)

### [2] stakeholder-mapping
- Invocar skill 'stakeholder-mapping'
- Input: seções `## 1. Visão` e `## 2. Problema & Necessidade` (pré-popular com pessoas mencionadas)
- Output: seção `## 4. Pessoas Envolvidas` (tabela Onion)
- Checklist de camadas, não perguntas abertas

### [3] contexto-e-limite
- Invocar skill 'contexto-e-limite'
- Input: todas as seções anteriores
- Output: seção `## 5. Contexto e Limites` + campo `lacunas_m1` em estado-projeto.yaml
- **Não re-perguntar "o que faz"** — inferir da Seção 2 e confirmar em choice

### [4] clarificacao-pos-visao (condicional — D16)
- Verificar: `estado-projeto.yaml → lacunas_m1.contagem`
- SE ≥ 2: invocar skill 'clarificacao-pos-visao'
- SE < 2: pular; ir direto para [5]
- Perguntas: máximo 1 chamada com ≤ 3 perguntas choice/yesno

### [5] traducao-gate
- Invocar skill 'traducao-gate'
- Input: `documentos-tecnicos/01-visao/01-visao-produto.md` completo (6 seções do template)
- Output: versão normativa finalizada + `documentos-para-leigo/01-visao/01-visao-produto.md`
- Salvar ambos nas pastas correspondentes do projeto
- Atualizar `estado-projeto.yaml` (artefatos)

---

## ARTEFATOS GERADOS

| Arquivo | Versão | Tamanho esperado |
|---|---|---|
| `documentos-tecnicos/01-visao/01-visao-produto.md` | Documento de Visão (ISO 29148) — template `core/templates/01-documento-visao.md` | 350–700 palavras |
| `documentos-para-leigo/01-visao/01-visao-produto.md` | Prosa narrativa de negócio | 200–400 palavras |

---

## ORÇAMENTO DE PERGUNTAS

| Passo | Modo | Perguntas típicas |
|---|---|---|
| [1] necessidade-visao — descoberta | 1 por turno (adaptativo) | 2–3 |
| [1] necessidade-visao — identificação + meta | lote de 2 + 1 | 3 |
| [1] necessidade-visao — confirmação síntese | choice | 1 |
| [2] stakeholder-mapping | lote checklist | 1–4 |
| [3] contexto-e-limite — lote | lote de 3 | 3 |
| [3] contexto-e-limite — confirmação dentro | choice | 1 |
| [4] clarificacao-pos-visao (cond.) | 1 lote | 0–3 |
| [GATE 1] | yesno | 1 |
| **Total típico** | | **~8–10** |
| **Pior caso (com clarificação)** | | **~13** |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto ao usuário (D19)
- Batching: D14 é **teto** (4/turno), não meta — na descoberta, 1 pergunta por turno
- Nunca mencionar "requisito", "elicitação", "stakeholder", "escopo", "gate", "IREB" ao usuário
- Se usuário abortar ou desconectar: salvar `.draft` do artefato em andamento

---

## TRANSIÇÕES DE ESTADO

| Momento | Estado em estado-projeto.yaml |
|---|---|
| Início do workflow | `marco_corrente: M1`, `gate_status.gate_1: pendente` |
| Após passo [3] | `lacunas_m1: {categorias: [...], contagem: N}` |
| Após passo [5] | `artefatos: [documentos-tecnicos/01-visao/01-visao-produto.md, documentos-para-leigo/01-visao/01-visao-produto.md]` |
| Gate 1 aprovado | `gate_status.gate_1: aprovado`, `gate_1_aprovado_em: <timestamp>`, `marco_corrente: M2`, `versao_leigo_aprovada: [documentos-para-leigo/01-visao/01-visao-produto.md]` |
| Gate 1 reprovado | `gate_status.gate_1: pendente` (permanece; usuário forneceu feedback) |

---

## SKILLS REMOVIDAS (v0.7.0)

| Skill | Motivo da remoção | Substituída por |
|---|---|---|
| `vision-box` | Overlap ~90% com `necessidade-visao` (quem/o quê perguntado 3×); fallback "processo manual" sem elicitação; duplo slot `**Que:**` colidindo; idempotência bloqueava re-elicitação no Gate-1 "Não" | `necessidade-visao` (problema-primeiro + síntese Moore confirmada) |
| `situacao-problema` | Q4 (solução) + Q6 (funcionalidades) puxavam usuário para espaço-da-solução durante fase de necessidade (premature solutioning); Q5 duplicava público-alvo da `vision-box` | Problema → `necessidade-visao` Fase 1 (5-Whys); usuários → `stakeholder-mapping` |
