# Incidentes de Runtime — Ferramenta de Elicitação

**Finalidade:** Registrar falhas observadas em execuções reais da ferramenta. Usados como dados empíricos no capítulo Discussão/Limitações do TCC.

---

## Incidente 01 — Run com Output Fora do Contrato (2026-05-18)

**Plataforma:** Gemini CLI  
**Input:** App de treinos (frase curta)  
**Diretório:** `/Users/viniciuscandeia/Desktop/Teste/`

### Sintomas

| Esperado | Recebido |
|---|---|
| `visao-produto-normativo.md` + `visao-produto-leigo.md` | `vision-box.md` (1 arquivo, nomes da skill, não do artefato) |
| `03.1-funcionais.md` + `-leigo` + `03.2-qualidade.md` + `-leigo` + `03.3-restricoes.md` + `-leigo` + `glossario.md` + `pautas-reelicitacao.md` | `necessidades.md` (1 arquivo genérico) |
| Não existe no design | `fluxos.md` (inventado pelo modelo) |
| `SRS-completo.md` (6 seções IREB) + `SRS-completo-leigo.md` + `spec/` + `tests/` + `TESTING-STRATEGY.md` + `README-TESTS.md` + `analyze-report.md` + `rastreabilidade.md` | `srs.md` (28 linhas, 2 seções parciais, sem EARS, sem RFC 2119) |

**estado-projeto.yaml declarou M4 concluído** com todos os gates aprovados, mas:
- `loop_m3_iteracoes: 0` (checker nunca rodou)
- `versao_leigo_aprovada: []` (nenhuma versão leigo foi aprovada pelo usuário)
- `dados_projeto.nome: "Ainda não definido"` (Gate 1 nunca devia ter passado)
- `passes: []` (nenhum loop registrado)

Jargão na saída ao usuário: "Especificação de Requisitos" no título, "Requisitos de Negócio" como heading, "User Stories" como seção.

### Causa raiz

**Enforcement fraco no orquestrador.** O `core/orchestrator.md` descrevia os gates como lista de pré-condições em prosa, mas não tinha bloco de verificação programática. O modelo adotou o comportamento default: gerou artefatos "razoáveis" com nomes intuitivos em vez de seguir a tabela canônica. Os gates foram rubber-stampados — nenhuma `AskUserQuestion` yesno foi invocada.

Evidência: `vision-box` é o nome da *skill* de M1 (corretamente), mas o artefato de saída correto é `visao-produto-normativo.md`. O modelo nomeou o artefato com o nome da skill.

### Skills nunca invocadas

`requisito-ears`, `srs-ireb-template`, `validacao-checklist-ireb`, `traducao-gate`, `traducao-leigo`, `analyze-cross-artifact`, `conflitos-detect`, `recomendacao-implicitos`, `recomendacao-dominio`, `gherkin-spec`, `step-defs-red`, `testing-strategy`, `readme-tests`, `rastreabilidade-matriz`, `glossario`, `pautas-reelicitacao`, `priorizacao`, `clarificacao-pos-visao`.

### Correção aplicada (2026-05-18)

1. `core/orchestrator.md`: adicionada tabela canônica de artefatos com proibição explícita de nomes não-listados; adicionados blocos PRE-FLIGHT CHECK antes de cada gate com verificações obrigatórias e re-invocação automática em caso de falha; adicionadas invariantes de gate (loop ≥ 1, AskUserQuestion obrigatório, versao_leigo_aprovada só após SIM).
2. `core/constitution.md`: adicionado artigo "ENFORCEMENT DE GATES — REGRA INVIOLÁVEL" codificando as 5 condições como regra absoluta.

### Implicação para o TCC

Este incidente demonstra que arquitetura baseada exclusivamente em prompt é insuficiente para garantir contratos de interface em sistemas multi-agente. O enforcement puramente declarativo (lista de pré-condições em prosa) é contornável pelo comportamento default do LLM. Enforcement efetivo exige:
- Blocos imperativos com pseudocódigo de verificação embutido no prompt
- Invariantes explícitas com consequências definidas em caso de falha
- Ou (fora do escopo MVP) validação externa ao prompt (ex: script de pré-commit checando artefatos antes de avançar estado)

Esta limitação será discutida na seção Ameaças à Validade do TCC.

---

## Template para futuros incidentes

```
## Incidente NN — [Descrição] (YYYY-MM-DD)

**Plataforma:** Gemini CLI | Claude Code
**Input:** [descrição do input]
**Diretório:** [path]

### Sintomas
[tabela esperado vs. recebido]

### Causa raiz
[análise]

### Correção aplicada
[o que mudou e onde]

### Implicação para o TCC
[como entra na discussão/limitações]
```
