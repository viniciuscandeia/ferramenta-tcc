---
name: requisito-ears
marco: [M3]
description: >-
  Formata todos os itens funcionais e de comportamento com estrutura padronizada usando modais de obrigatoriedade (DEVE/DEVERIA/PODE) e padrões de condição (evento, estado, exceção, ubíquo, opcional).
  Use no início do Marco 3, com os itens classificados e priorizados do Marco 2.
  Format RF/RNF items with EARS syntax and RFC 2119 modals; no user interaction; produces structured table for SRS and Gherkin.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de forma** — RF sem sujeito + verbo + objeto não é requisito, é intenção. Decomposição EARS é obrigatória. Item que não se decompõe recebe flag `[VERIFICAR]` — nunca é omitido silenciosamente.
2. **Preservar modal original, não reinterpretar.** O modal vem de `priorizacao` (M2). Esta skill formata, não reprioriza.
3. **Ubíquo é padrão residual.** Usar apenas quando nenhum dos outros 4 padrões EARS se aplica. Classificação prematura como Ubíquo mascara condições que deveriam ser Evento ou Estado.

<HARD-GATE>
- NÃO executar antes de Gate 2 aprovado (verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` e `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` com campo modal preenchido)
- NÃO executar se `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` não tem nenhum item com modal `DEVE` (sem items DEVE = nenhuma spec Gherkin possível em Passo 3)
- ⛔ STOP se contagem de itens na saída ≠ contagem de entrada — omissão silenciosa proibida
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` e `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` existem com campo modal preenchido
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

**Modais RFC 2119:**

| Modal | Força | EN |
|---|---|---|
| `DEVE` | Obrigatório | MUST |
| `DEVERIA` | Recomendado | SHOULD |
| `PODE` | Opcional | MAY |

**Por RF:** detectar padrão → decompor em Sujeito/Verbo/Objeto/Condição → registrar linha.
Item com padrão ambíguo ou descrição vaga → coluna Condição recebe `[VERIFICAR]`.

**Por RNF:** não aplicar padrão EARS estrutural. Formatar como linha de qualidade: ID | Bucket | Sujeito | Modal | Comportamento | Métrica.

Sujeito é sempre "O sistema" (EARS canônico). Sem interação com usuário.

## Fase 2 — Saída

```markdown
# Requisitos Formatados (EARS + RFC 2119)

## Funcionais

| ID | Tipo-EARS | Sujeito | Modal | Verbo | Objeto | Condição |
|---|---|---|---|---|---|---|
| RF-001 | Ubíquo | O sistema | DEVE | permitir | cadastro de produto | — |
| RF-002 | Evento | O sistema | DEVE | enviar | confirmação por e-mail | Quando um pedido for concluído |
| RF-003 | Indesejado | O sistema | DEVE | exibir | mensagem de erro detalhada | Se o pagamento falhar |
| RF-004 | Estado | O sistema | DEVERIA | bloquear | novas requisições | Enquanto o limite de sessões for atingido |
| RF-005 | Opcional | O sistema | PODE | exportar | relatório em PDF | Onde o módulo de relatórios estiver habilitado |
| RF-006 | Ubíquo | O sistema | DEVE | [descrição vaga] | [VERIFICAR] | — |

## Qualidade

| ID | Bucket | Sujeito | Modal | Comportamento | Métrica |
|---|---|---|---|---|---|
| RNF-001 | Desempenho | O sistema | DEVE | responder a requisições | < 2s para 95% das chamadas |
| RNF-002 | Disponibilidade | O sistema | DEVE | estar disponível | 99,5% em 30 dias |
```

Verificar: contagem saída == contagem entrada (RF + RNF). Se divergir: ⛔ STOP — localizar item omitido antes de prosseguir.

Sinalizar ao `documenter`: requisito-ears concluído → prosseguir para `srs-ireb-template` (Passo 2).

<!-- internal -->
## Anti-Padrão: Ubíquo por Preguiça de Classificar

**Como acontece:** RF "O sistema DEVE notificar o usuário quando o estoque baixar" é classificado como Ubíquo porque a descrição foi lida sem identificar "quando". A condição EARS correta é Evento — a notificação só ocorre em um evento específico.

**Como detectar:** Verificar cada Ubíquo final: a descrição contém "quando", "enquanto", "se" ou "onde"? Se sim: reclassificar. Ubíquo é comportamento permanente e incondicional — sem gatilho de nenhum tipo.

**O que fazer:** Reclassificar antes de salvar. Se padrão ainda ambíguo após releitura: marcar `[VERIFICAR]` na coluna Condição e criar pauta para o checker revisar via `analyze-cross-artifact`.
<!-- /internal -->
