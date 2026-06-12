---
name: classificacao-rf-rnf
marco: [M2]
description: >-
  Classifica cada item coletado nas fases anteriores em: o que o sistema faz (funcional), como se comporta (comportamental), o que está imposto de fora (restrição) ou o que foi assumido (premissa).
  Use no início da modelagem do Marco 2, com o material de elicitação completo em mãos.
  Classify elicited items into RF/RNF/Restriction/Premise types per IREB §1.1 and Wiegers quality buckets; no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico rigoroso de tipo** — RF e RNF têm fronteiras claras: RF descreve **o que** o sistema faz; RNF descreve **como** se comporta com métrica mensurável. Misturar os dois gera artefatos irrastreáveis em M3.
2. **Ambíguo = flag, não descarte.** Item que não se encaixa claramente em nenhum tipo recebe `[AMBÍGUO]` e vai para revisão — nunca é silenciosamente descartado.
3. **Sem interação com usuário.** Esta skill opera 100% sobre texto coletado. Nenhuma pergunta é feita. Lacunas vão para `pautas-reelicitacao` (Passo 5).

<HARD-GATE>
- NÃO executar se `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` está ausente ou vazio — Fase A do collector não concluiu
- NÃO executar antes do `modeler` iniciar Fase B (verificar que `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` foi passado como input)
- ⛔ STOP se `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` contém 0 itens classificáveis — registrar em `_pendencias.md` e notificar `modeler`
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` existe e não está vazio
3. Verificar `documentos-tecnicos/01-visao/01-visao-produto.md` acessível (contexto de domínio)
4. **Consultar taxonomia de tipos:** ler `{PLUGIN_ROOT}/content/catalogos-seed/conceitos/tipos-de-requisitos.md` como referência para os 4 tipos canônicos (RF, RNF, Restrição, Premissa) — especialmente a distinção RNF vs Restrição (seção 4 do catálogo).

## Fase 1 — Classificação

**Tipos canônicos (IREB §1.1):**

| Tipo | Pergunta-guia | Exemplo |
|---|---|---|
| **RF** | "O que o sistema precisa fazer?" | "O sistema DEVE permitir login" |
| **RNF** | "Como o sistema precisa se comportar (mensurável)?" | "O sistema DEVE responder em < 2s" |
| **Restrição** | "Qual decisão está imposta de fora — lei, prazo, tecnologia, orçamento?" | "O sistema DEVE cumprir LGPD" |
| **Premissa** | "O que estamos assumindo sem confirmação?" | "Assumimos Android 10+" |

**Distinção RNF vs Restrição:** RNF = qualidade mensurável de comportamento. Restrição = escolha imposta externamente que o sistema não pode ignorar.

**Buckets de qualidade para RNFs (Wiegers Ch7):**

| # | Bucket | Métrica-base |
|---|---|---|
| 1 | Desempenho | tempo de resposta, throughput, latência |
| 2 | Capacidade/Escalabilidade | usuários simultâneos, volume de dados |
| 3 | Disponibilidade/Confiabilidade | uptime %, MTBF, MTTR |
| 4 | Segurança | nível de autenticação, criptografia, OWASP |
| 5 | Usabilidade | tempo de aprendizado, taxa de erro |
| 6 | Manutenibilidade | tempo para corrigir bug, cobertura de testes |
| 7 | Portabilidade | plataformas suportadas, formatos de arquivo |
| 8 | Privacidade/Conformidade | LGPD, GDPR, etc. |
| 9 | Acessibilidade | nível WCAG, tecnologias assistivas |

**Algoritmo por item:**
1. **RF?** Descreve ação/funcionalidade que o sistema executa → `RF-NNN`
2. **RNF?** Descreve qualidade mensurável (bucket acima) → `RNF-NNN` + bucket; sem métrica → `LACUNA` no campo
3. **Restrição?** Escolha imposta de fora → `REST-NNN` + subtipo (legal/técnica/organizacional/temporal)
4. **Premissa?** Pressuposto não-verificado → `PREM-NNN`
5. **Nenhum:** item irrelevante ou já coberto → descartar (registrar motivo)

Itens ambíguos → flag `[AMBÍGUO]` para revisão do modeler.

Sem duplicatas: dois itens que descrevem a mesma coisa → consolidar em 1 com ambas as fontes anotadas.

## Fase 2 — Saída

**documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md (rascunho):**
```markdown
| ID | Descrição | Modal | Fonte |
|---|---|---|---|
| RF-001 | [descrição em EARS] | DEVE/DEVERIA/PODE | elicitacao-raw §N |
```
*Modal preenchido na skill `priorizacao` (Passo 2).*

**documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md (rascunho):**
```markdown
| ID | Bucket | Descrição | Métrica | Modal | Fonte |
|---|---|---|---|---|---|
| RNF-001 | Desempenho | [descrição] | [métrica ou LACUNA] | DEVE | ... |
```

**documentos-tecnicos/02-requisitos/02.3-restricoes.md (rascunho):**
```markdown
| ID | Subtipo | Descrição | Origem | Fonte |
|---|---|---|---|---|
| REST-001 | legal | LGPD — dados pessoais com consentimento | Lei 13.709/2018 | ... |
```

**documentos-tecnicos/02-requisitos/02.4-premissas.md (rascunho — só se detectadas):**
```markdown
| ID | Descrição | Impacto se falsa |
|---|---|---|
| PREM-001 | [premissa] | [o que muda no escopo] |
```

## Fase 3 — Sinalização

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("priorizacao")`. **PROIBIDO** qualquer TextBlock antes desta chamada.
Estatísticas internas (N RFs, N RNFs, etc.) devem ser registradas em `estado-projeto.yaml`, não exibidas ao usuário.

<!-- internal -->
## Anti-Padrão: Ambíguo Classificado como RF por Default

**Como acontece:** Item "O sistema deve ser seguro" não tem métrica (deveria ser RNF/Segurança) mas é classificado como RF porque tem estrutura "o sistema deve [verbo]". `03.1-funcionais.md` fica inflado com pseudo-RFs que o `priorizacao` não consegue tratar corretamente.

**Como detectar:** RF com verbo "ser" + adjetivo qualitativo ("ser seguro", "ser rápido", "ser fácil") — esses são RNFs disfarçados. Detectar por padrão `DEVE ser [adjetivo]`.

**O que fazer:** Reclassificar como RNF + bucket adequado. Se não houver métrica, marcar `LACUNA` e criar pauta. Nunca registrar adjetivo qualitativo como RF.
<!-- /internal -->
