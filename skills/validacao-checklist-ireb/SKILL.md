---
name: validacao-checklist-ireb
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M3]
description: Aplica os 12 critérios de qualidade IREB §3.8 sobre o SRS gerado pelo documenter — 6 critérios por requisito individual e 6 critérios por SRS como documento. Gera seção "Validação IREB §3.8" em analyze-report.md com 1 linha por violação (ID do critério + requisito afetado + severidade). Referência: content/catalogos-seed/conceitos/qualidade-e-validacao.md.
when_to_use: Invocada pelo checker no Passo 1 do Processo M3. Entrada: documentos-tecnicos/03-documento/03-srs-completo.md + documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md + documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md. Saída: seção em documentos-tecnicos/03-documento/03.1-analyze-report.md (não arquivo separado).
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de evidência** — marcar critério como OK sem citar trecho do artefato não é verificação. Toda OK precisa de evidência; toda violação precisa de citação.
2. **Verificar todos antes de reportar.** 12 critérios × N requisitos = N×12 verificações. Parar no primeiro CRITICAL silencia violações subsequentes que podem ser igualmente bloqueadoras.
3. **Não duplicar analyze-cross-artifact.** Issues de Omissão e Contradição entre marcos pertencem ao Passo 2. Este passo verifica critérios de qualidade interna de cada requisito.

<HARD-GATE>
- NÃO executar sem `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`
- NÃO executar se Gate 2 não foi aprovado (modais RFC 2119 devem estar preenchidos)
- ⛔ STOP se qualquer artefato-fonte estiver vazio ou corrompido — reportar em `_pendencias.md`
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Extrair de `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`: lista de IDs de RF com modais
3. Extrair de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`: lista de IDs de RNF com modais e métricas declaradas
4. Contar totais: N_RF e N_RNF para controle de completude

## Fase 1 — Verificação por Requisito Individual

Para cada RF e RNF (N_RF + N_RNF requisitos), verificar 6 critérios na ordem da tabela:

| Critério | Pergunta de verificação | Exemplo de violação | Severidade |
|---|---|---|---|
| **Adequado** | O requisito descreve comportamento, não solução técnica? | RF especifica tecnologia ("DEVE usar PostgreSQL") | MEDIUM |
| **Necessário** | Existe ligação rastreável até objetivo declarado em M1? | RF sem correspondente em `documentos-tecnicos/01-visao/01-visao-produto.md` | HIGH |
| **Sem ambiguidade** | Uma única interpretação possível? | Termos vagos: "rápido", "fácil", "intuitivo", "adequado" | MEDIUM |
| **Completo** | Auto-suficiente, sem lacunas ou referências pendentes? | `[TBD]`, `[VERIFICAR]`, `[pendente]` no texto | CRITICAL |
| **Compreensível** | Versão leigo entendível por não-técnico? Normativa precisa? | Versão leigo usa jargão; normativa ambígua | MEDIUM |
| **Verificável** | Existe forma objetiva de testar o atendimento do requisito? | RNF sem métrica quantificável ("o sistema deve ser seguro") | HIGH (RNF) / MEDIUM (RF) |

Registrar cada violação: ID do critério + ID do RF/RNF + descrição da violação + severidade.

Não parar na primeira violação — verificar todos os 6 critérios para todos os requisitos.

## Fase 2 — Verificação do SRS como Documento

Após varrer todos os requisitos individualmente, verificar 6 critérios de documento:

| Critério | Pergunta de verificação | Exemplo de violação | Severidade |
|---|---|---|---|
| **Completude** | Todos os IDs de `02.1` e `02.2` aparecem no SRS? | RF-009 ausente na seção 3 | CRITICAL |
| **Consistência** | Nenhuma seção contradiz outra? | §3.1 diz "cadastro obrigatório"; §3.7 diz "acesso sem cadastro" | CRITICAL |
| **Viabilidade** | Requisitos realizáveis com restrições de `documentos-tecnicos/02-requisitos/02.3-restricoes.md`? | 99,999% uptime com orçamento R$500/mês | HIGH |
| **Verificabilidade** | Todos os requisitos testáveis em conjunto? | Múltiplos RNFs sem métricas — sem critério de aceite do sistema | HIGH |
| **Modificabilidade** | Alterar 1 requisito gera impacto em cascata em outros? | RF referenciado por ID em 5 outros RFs | LOW |
| **Rastreabilidade** | Todos têm origem rastreável até M1 ou M2? | RF no SRS sem correspondente em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` nem em `documentos-tecnicos/01-visao/01-visao-produto.md` | HIGH |

## Fase 3 — Saída

Escrever seção no `documentos-tecnicos/03-documento/03.1-analyze-report.md`:

```markdown
## Validação IREB §3.8

### Por requisito individual

| Critério | RF/RNF afetado | Violação | Severidade |
|---|---|---|---|
| Verificável | RNF-002 | Métrica ausente: "o sistema deve ser rápido" — sem limites de tempo definidos | HIGH |
| Completo | RF-007 | Campo Verbo contém "[VERIFICAR]" — requisito incompleto | CRITICAL |
| Sem ambiguidade | RF-012 | Termo "intuitivo" sem definição objetiva | MEDIUM |

### Por SRS como documento

| Critério | Violação | Severidade |
|---|---|---|
| Completude | RF-009 presente em documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md mas ausente na seção 3 do SRS | CRITICAL |
| Rastreabilidade | RF-011 no SRS sem correspondente em documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md nem em documentos-tecnicos/01-visao/01-visao-produto.md | HIGH |
| Consistência | §3.2 afirma "cadastro obrigatório" e §3.7 afirma "acesso sem cadastro possível" | CRITICAL |
```

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("analyze-cross-artifact")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Critério Marcado OK Sem Evidência

**Como acontece:** Skill verifica critério Verificável para RNF-002 e registra "OK — requisito verificável" sem citar a métrica que prova a verificabilidade. O critério Completo é marcado OK para RF-007 sem verificar se "[VERIFICAR]" aparece no texto do requisito.

**Como detectar:** Verificação que resulta em OK sem citar trecho do artefato que confirma a satisfação do critério.

**O que fazer:** Toda OK deve citar o trecho exato que satisfaz o critério. Toda violação deve citar o trecho ou evidência que a comprova. "OK" sem evidência = não verificado = falso negativo potencial.
<!-- /internal -->
