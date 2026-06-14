---
name: pautas-reelicitacao
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M2]
description: >-
  Lista o que ainda precisa ser detalhado antes de encerrar o Marco 2 — cada item em aberto indica uma pergunta que precisa de resposta para a próxima fase começar.
  Use no final da modelagem do Marco 2, para decidir se o loop de elicitação deve continuar ou se a fase pode ser fechada.
  Generate re-elicitation agenda from M2 artifacts; determines loop stop condition; assigns target skill per gap; no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Critério de parada do loop M2.** Arquivo vazio (ou sem `[ ]`) = Gate 2 pode abrir. Arquivo com ≥ 1 `[ ]` = loop retorna ao `collector`. Nada mais determina essa decisão.
2. **Pauta vaga = inútil.** "Revisar RNFs" não é pauta. "RNF-002 sem métrica de disponibilidade — qual % de uptime é aceitável?" é pauta. Cada item deve ter ID do artefato, descrição da lacuna, e `(skill-alvo: nome-da-skill)`.
3. **Sem interação com usuário.** A detecção é automática. As perguntas serão feitas pelo `collector` em modo focado na próxima iteração.

<HARD-GATE>
- NÃO executar antes de `conflitos-detect` concluída (Passo 4)
- NÃO executar se `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` ou `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` estão ausentes (sem artefatos para auditar)
- ⛔ STOP se `documentos-tecnicos/02-requisitos/02.5-glossario.md` está ausente — sem glossário, verificação de termos incertos é impossível; registrar em `_pendencias.md`
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar todos os artefatos de entrada: `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/02-requisitos/02.3-restricoes.md`, `documentos-tecnicos/02-requisitos/02.4-premissas.md` (se existir), `documentos-tecnicos/02-requisitos/02.5-glossario.md`, `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` (se existir)

## Fase 1 — Varredura por Tipo de Lacuna

Para cada tipo de lacuna, varrer os artefatos e registrar entradas:

| Tipo | Sinal | Skill-alvo |
|---|---|---|
| RF sem critério de aceitação | RF em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` sem condição verificável | `entrevista-estruturada` |
| RNF sem métrica | `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` com campo Métrica = `LACUNA` | `entrevista-estruturada` |
| Restrição sem detalhe | `documentos-tecnicos/02-requisitos/02.3-restricoes.md` com restrição legal sem referência normativa | `entrevista-estruturada` |
| Conflito não resolvido | `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md` com `status: aberto` afetando escopo ou modal | `entrevista-estruturada` ou `cenario-narrativa` |
| Termo com `[DEFINIÇÃO INCERTA]` | `documentos-tecnicos/02-requisitos/02.5-glossario.md` com flag | `entrevista-estruturada` |
| Premissa crítica sem validação | `documentos-tecnicos/02-requisitos/02.4-premissas.md` com impacto alto não confirmado | `entrevista-estruturada` |

**Filtragem por criticidade:**
- Lacuna que afeta RF `DEVE`, RNF `DEVE`, ou restrição legal → **sempre gera pauta**
- Lacuna que afeta RF `DEVERIA` → gera pauta se não há informação suficiente para inferência
- Lacuna que afeta RF `PODE` / `PODERIA_TER` → não gera pauta (cosmético; resolver em M3 se necessário)

## Fase 2 — Saída

Salvar como `documentos-tecnicos/02-requisitos/02.6-pautas-reelicitacao.md`.

**Com pautas:**
```markdown
# Pautas de Detalhamento

> Itens que precisam de informação adicional antes de finalizar esta fase.
> Quando todos os itens estiverem marcados `[x]`, a próxima fase pode começar.

- [ ] RF-005 não tem critério de aceitação: como saber se o sistema "enviou a notificação com sucesso"? (skill-alvo: entrevista-estruturada)
- [ ] RNF-002 sem métrica de disponibilidade: qual % de uptime é aceitável? (skill-alvo: entrevista-estruturada)
- [ ] REST-001 LGPD sem referência ao artigo específico: arts. 7–9 (consentimento) ou arts. 14–15 (menores)? (skill-alvo: entrevista-estruturada)
```

**Sem pautas:**
```markdown
# Pautas de Detalhamento

> Nenhuma pauta aberta. Gate 2 pode ser apresentado ao usuário.
```

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Verificar `pautas_abertas.count` e agir imediatamente:
- N = 0 → Orquestrador executa PRE-FLIGHT do Gate 2 e abre gate via `AskUserQuestion`
- N ≥ 1 → Orquestrador reinvoca `collector` com arquivo de pautas como instrução de próxima rodada

**PROIBIDO** qualquer TextBlock antes desta ação.

<!-- internal -->
## Anti-Padrão: Pauta Sem Skill-Alvo Identificado

**Como acontece:** "Revisar seção de segurança" é criada como pauta sem skill-alvo. O `collector` em modo focado não sabe qual skill invocar para resolver — a pauta se perpetua indefinidamente entre iterações.

**Como detectar:** Pauta sem o sufixo `(skill-alvo: nome-da-skill)` é inválida. Verificar todas as entradas antes de salvar o arquivo.

**O que fazer:** Toda pauta DEVE ter skill-alvo explícito. Se a lacuna é ambígua quanto à skill, usar `entrevista-estruturada` como default seguro — ela cobre todos os tipos via perguntas adaptadas. Nunca registrar pauta sem `(skill-alvo: ...)`.
<!-- /internal -->
