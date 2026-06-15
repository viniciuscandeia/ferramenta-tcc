---
name: requisito-ears
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M3]
description: >-
  Formata todos os itens funcionais e de comportamento com estrutura padronizada usando modais de obrigatoriedade (DEVE/DEVERIA/PODE) e padrões de condição (evento, estado, exceção, ubíquo, opcional).
  Use no início do Marco 3, com os itens classificados e priorizados do Marco 2.
  Format RF/RNF items with EARS syntax and RFC 2119 modals; no user interaction; produces structured table for SRS.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de forma** — RF sem sujeito + verbo + objeto não é requisito, é intenção. Decomposição EARS é obrigatória. Item que não se decompõe recebe flag `[VERIFICAR]` — nunca é omitido silenciosamente.
2. **Preservar a prioridade original, não reinterpretar.** A prioridade (Essencial/Importante/Desejável) vem de `priorizacao` (M2) e determina o modal embutido na frase (Essencial→DEVE, Importante→DEVERIA, Desejável→PODE). Esta skill formata, não reprioriza.
3. **Ubíquo é padrão residual.** Usar apenas quando nenhum dos outros 4 padrões EARS se aplica. Classificação prematura como Ubíquo mascara condições que deveriam ser Evento ou Estado.

<HARD-GATE>
- NÃO executar antes de Gate 2 aprovado (verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` e `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` com campo de prioridade preenchido)
- NÃO executar se `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` não tem nenhum item com prioridade `Essencial` (sem itens Essencial = nenhum requisito obrigatório — indica erro de priorização em M2; retornar ao orquestrador)
- ⛔ STOP se contagem de itens na saída ≠ contagem de entrada — omissão silenciosa proibida
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` e `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` existem com campo de prioridade preenchido
3. Contar itens de entrada para verificação de completude na Fase 2

## Fase 1 — Formatação EARS

**5 padrões EARS (ordem de detecção — mais específico primeiro):**

| # | Padrão | Gatilho linguístico | Estrutura |
|---|---|---|---|
| 1 | **Indesejado** | "se [erro/falha/timeout/indisponível]" | "Se [falha], o sistema [Modal] [verbo] [objeto]" |
| 2 | **Evento** | "quando [evento ocorrer]" | "Quando [evento], o sistema [Modal] [verbo] [objeto]" |
| 3 | **Estado** | "enquanto [estado ativo]" | "Enquanto [estado], o sistema [Modal] [verbo] [objeto]" |
| 4 | **Opcional** | "onde [recurso disponível]" | "Onde [recurso], o sistema [Modal] [verbo] [objeto]" |
| 5 | **Ubíquo** | nenhum dos anteriores | "O sistema [Modal] [verbo] [objeto]" |

**Modais RFC 2119 (referência interna — o modal vai DENTRO da frase, nunca em coluna própria):**

| Modal | Força | EN | Prioridade MoSCoW de origem |
|---|---|---|---|
| `DEVE` | Obrigatório | MUST | Essencial |
| `DEVERIA` | Recomendado | SHOULD | Importante |
| `PODE` | Opcional | MAY | Desejável |

**Por RF:** detectar padrão → montar a **frase EARS completa** (com o modal embutido) → registrar a frase + a prioridade vinda de `priorizacao`. Não criar coluna "Modal" separada.
Item com padrão ambíguo ou descrição vaga → marcar `[VERIFICAR]`.

**Por RNF:** não aplicar padrão EARS estrutural. Formatar como linha de qualidade com o modal embutido na frase do comportamento: ID | Categoria | Comportamento (com DEVE/DEVERIA/PODE embutido na frase) | Prioridade | Métrica.

Sujeito é sempre "O sistema" (EARS canônico), embutido na frase. Sem interação com usuário.

## Fase 2 — Saída

```markdown
# Requisitos Formatados

## Funcionais

| ID | Classificação | Requisito | Prioridade | Verificar? |
|---|---|---|---|---|
| RF-001 | Ubíquo | O sistema DEVE permitir o cadastro de produto | Essencial | — |
| RF-002 | Evento | Quando um pedido for concluído, o sistema DEVE enviar confirmação por e-mail | Essencial | — |
| RF-003 | Indesejado | Se o pagamento falhar, o sistema DEVE exibir mensagem de erro detalhada | Essencial | — |
| RF-004 | Estado | Enquanto o limite de sessões for atingido, o sistema DEVERIA bloquear novas requisições | Importante | — |
| RF-005 | Opcional | Onde o módulo de relatórios estiver habilitado, o sistema PODE exportar relatório em PDF | Desejável | — |
| RF-006 | Ubíquo | O sistema DEVE [descrição vaga] | Essencial | [VERIFICAR] |

## Qualidade

| ID | Categoria | Comportamento | Prioridade | Métrica |
|---|---|---|---|---|
| RNF-001 | Desempenho | O sistema DEVE responder a requisições | Essencial | < 2s para 95% das chamadas |
| RNF-002 | Disponibilidade | O sistema DEVE estar disponível | Essencial | 99,5% em 30 dias |

> **Legenda de prioridade (MoSCoW):** Essencial (Must) · Importante (Should) · Desejável (Could) · Fora desta versão (Won't). O verbo de obrigatoriedade (DEVE/DEVERIA/PODE) está embutido na própria frase do requisito — não há coluna "Modal".
```

Verificar: contagem saída == contagem entrada (RF + RNF). Se divergir: ⛔ STOP — localizar item omitido antes de prosseguir.

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("modelagem-visual")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Ubíquo por Preguiça de Classificar

**Como acontece:** RF "O sistema DEVE notificar o usuário quando o estoque baixar" é classificado como Ubíquo porque a descrição foi lida sem identificar "quando". A condição EARS correta é Evento — a notificação só ocorre em um evento específico.

**Como detectar:** Verificar cada Ubíquo final: a descrição contém "quando", "enquanto", "se" ou "onde"? Se sim: reclassificar. Ubíquo é comportamento permanente e incondicional — sem gatilho de nenhum tipo.

**O que fazer:** Reclassificar antes de salvar. Se padrão ainda ambíguo após releitura: marcar `[VERIFICAR]` na coluna Condição e criar pauta para o checker revisar via `analyze-cross-artifact`.
<!-- /internal -->
