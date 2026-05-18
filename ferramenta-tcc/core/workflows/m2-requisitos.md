# Workflow M2 — Consenso de Escopo

**Sub-agentes responsáveis:** `collector` (Fase A) → `modeler` (Fase B, loop)
**Entrada:** `visao-produto-normativo.md` + `visao-produto-leigo.md` (aprovados pelo Gate 1)
**Saída:** `03.1-funcionais.md` + `03.2-qualidade.md` + `03.3-restricoes.md` + `glossario.md` + `pautas-reelicitacao.md` (+ versões leigo dos 3 primeiros)
**Gate de saída:** Gate 2 — usuário aprova versões leigo; `pautas-reelicitacao.md` sem pendências abertas

---

## SEQUÊNCIA DE EXECUÇÃO

```
ENTRADA (artefatos M1 aprovados)
  │
  ▼
╔══════════════════════════════════╗
║  FASE A — Elicitação Linear      ║  sub-agente: collector
╠══════════════════════════════════╣
║ [A1] entrevista-estruturada      ║  → 1 lote de 4 perguntas
║ [A2] cenario-narrativa           ║  → 1–2 cenários em prosa; extrai RFs candidatos
║ [A3] recomendacao-dominio        ║  → detecta domínio; 4 perguntas domínio
║ [A4] recomendacao-implicitos     ║  → algoritmo 3 camadas; 5–10 RFs/RNFs candidatos
║ [A5] questionario-feixe          ║  → CONDICIONAL: só se ≥ 3 áreas sem cobertura
╚═════════════════╤════════════════╝
                  │ elicitacao-raw.md
                  ▼
╔══════════════════════════════════╗
║  FASE B — Modelagem + Loop       ║  sub-agentes: collector ⇄ modeler
╠══════════════════════════════════╣
║ [B1] classificacao-rf-rnf        ║  → tabela RF/RNF/Restrição/Premissa
║ [B2] priorizacao                 ║  → MoSCoW sempre; Kano/IEEE condicionais
║ [B3] glossario                   ║  → termos do domínio sem definição clara
║ [B4] conflitos-detect            ║  → CONDICIONAL: registra se ≥ 1 conflito
║ [B5] pautas-reelicitacao         ║  → lacunas → checkbox com skill-alvo
╚═════════════════╤════════════════╝
                  │
          pautas_abertas?
         /              \
       SIM              NÃO
        │                │
   (volta ao          [B6] traducao-gate
    collector          → versões leigo
    focado)            → Gate 2 mock
   iteração N+1              │
   (teto: 3)          [GATE 2]
                    SIM → baseline git → M3
                    NÃO → volta ao collector com feedback
```

---

## DETALHES DE CADA PASSO

### FASE A — Sub-agente: collector

#### [A1] entrevista-estruturada

- Invocar skill `core/skills/entrevista-estruturada/SKILL.md`
- Input: `visao-produto-normativo.md` (contexto)
- Output: seção "Rotina e Necessidades" no `elicitacao-raw.md`
- **1 lote de 4 perguntas** sobre: atividades cotidianas / frustrações atuais / ideal esperado / restrições percebidas

#### [A2] cenario-narrativa

- Invocar skill `core/skills/cenario-narrativa/SKILL.md`
- Input: respostas da entrevista + perfis de stakeholders (M1)
- Output: 1–2 cenários "um dia normal de [perfil]" no `elicitacao-raw.md`
- Skill extrai RFs candidatos implícitos do texto do usuário

#### [A3] recomendacao-dominio

- Invocar skill `core/skills/recomendacao-dominio/SKILL.md`
- Input: `visao-produto-normativo.md` (para inferir domínio)
- Output: 4–8 RFs/RNFs do catálogo de domínio confirmados pelo usuário
- **1 yesno** para confirmar domínio detectado + **1 lote de 4 perguntas** sobre seções do catálogo

#### [A4] recomendacao-implicitos

- Invocar skill `core/skills/recomendacao-implicitos/SKILL.md`
- Input: `elicitacao-raw.md` acumulado até aqui + `catalogos-seed/rfs-tipicos.md` + `catalogos-seed/rnfs-tipicos.md`
- Output: 5–10 RFs/RNFs implícitos confirmados pelo usuário (algoritmo 3 camadas D-S4.3)
- **Pré-aviso ao usuário antes de iniciar:** "Vou sugerir algumas funcionalidades comuns que sistemas como o seu costumam ter — você me diz se fazem sentido para o seu projeto."

#### [A5] questionario-feixe (CONDICIONAL)

- Invocar skill `core/skills/questionario-feixe/SKILL.md`
- **Ativar apenas se:** ≥ 3 áreas do sistema sem detalhamento claro após [A1]–[A4]
- Input: `elicitacao-raw.md` + lista de áreas ainda vagas
- Output: 1–2 lotes de 4 perguntas agrupadas por tema

---

### FASE B — Sub-agentes: modeler (principal) + collector (modo focado no loop)

#### [B1] classificacao-rf-rnf

- Invocar skill `core/skills/classificacao-rf-rnf/SKILL.md`
- Input: `elicitacao-raw.md` (completo após Fase A)
- Output: tabela classificada em `03.1-funcionais.md` (rascunho) + `03.2-qualidade.md` (rascunho) + `03.3-restricoes.md` (rascunho) + `03.4-premissas.md` (se detectadas)
- Sem interação com usuário

#### [B2] priorizacao

- Invocar skill `core/skills/priorizacao/SKILL.md`
- Input: rascunhos de `03.1-funcionais.md` + `03.2-qualidade.md`
- Output: modal RFC 2119 + campo MoSCoW atribuído a cada item
- Gatilhos automáticos (D-S4.2): Kano se RFs Should/Could ≥ 8 **e** stakeholders ≥ 2; IEEE se RFs+RNFs ≥ 25 **e** restrição de prazo fixo
- Sem interação com usuário

#### [B3] glossario

- Invocar skill `core/skills/glossario/SKILL.md`
- Input: `elicitacao-raw.md` + rascunhos M2
- Output: `glossario.md` com termos do domínio + definições
- Sem interação com usuário

#### [B4] conflitos-detect (CONDICIONAL)

- Invocar skill `core/skills/conflitos-detect/SKILL.md`
- **Ativar sempre** — mas só gerar `conflitos-detectados.md` se ≥ 1 conflito encontrado
- Input: artefatos rascunho M2 + stakeholders de M1
- Output: `conflitos-detectados.md` (condicional) com tipo IREB §4.4 + estratégia de resolução

#### [B5] pautas-reelicitacao

- Invocar skill `core/skills/pautas-reelicitacao/SKILL.md`
- Input: todos os rascunhos M2
- Output: `pautas-reelicitacao.md` com checkboxes
- **Se vazio:** avançar para [B6]
- **Se não-vazio:** retornar ao `collector` em modo Fase B focado (com lista de pautas)

#### [B6] traducao-gate

- Invocar skill `core/skills/traducao-gate/SKILL.md`
- Input: artefatos finalizados M2
- Output: versões leigo de `03.1-funcionais`, `03.2-qualidade`, `03.3-restricoes`
- Salvar todos os artefatos na pasta do projeto
- Atualizar `estado-projeto.yaml`

---

## REGRAS DO LOOP B

1. **Teto de 3 iterações:** após 3 voltas ao collector em modo focado, se `pautas-reelicitacao.md` ainda tiver itens `[ ]`, escalar ao usuário (yesno: "Algumas perguntas ainda estão abertas — quer responder agora ou prefere seguir assim?")
2. **Collector modo focado:** recebe `pautas-reelicitacao.md` e executa apenas a skill indicada por cada pauta (não refaz Fase A completa)
3. **Formato da pauta esperado:**
   ```markdown
   - [ ] [Descrição da lacuna] (skill-alvo: nome-da-skill)
   ```
4. **Contador de iterações:** registrar em `estado-projeto.yaml` campo `loop_m2_iteracoes: N`
5. **Cada iteração do loop:** modeler reexecuta apenas [B1] parcial (reclassifica itens novos) → [B5] (atualiza pautas)

---

## ARTEFATOS GERADOS

| Arquivo | Fase | Obrigatório | Tamanho esperado |
|---|---|---|---|
| `elicitacao-raw.md` | Fase A (interno) | Sim | 200–500 palavras |
| `03.1-funcionais.md` | Fase B | Sim | 8–20 RFs em tabela EARS |
| `03.1-funcionais-leigo.md` | Gate 2 | Sim | 200–400 palavras |
| `03.2-qualidade.md` | Fase B | Sim | 3–8 RNFs com métricas |
| `03.2-qualidade-leigo.md` | Gate 2 | Sim | 100–200 palavras |
| `03.3-restricoes.md` | Fase B | Sim | 3–8 restrições classificadas |
| `03.3-restricoes-leigo.md` | Gate 2 | Sim | 100–200 palavras |
| `03.4-premissas.md` | Fase B | Condicional | só se premissas detectadas |
| `glossario.md` | Fase B | Sim | ≥ 5 termos com definições |
| `pautas-reelicitacao.md` | Fase B | Sim | vazio = Gate pode abrir |
| `conflitos-detectados.md` | Fase B | Condicional | só se ≥ 1 conflito |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto apresentado ao usuário (D19)
- Batching ≤ 4 perguntas por `AskUserQuestion` (D14); rondas temáticas na Fase A
- Nunca mencionar "requisito", "elicitação", "stakeholder", "escopo", "prioridade", "MoSCoW", "Kano" ao usuário
- Se usuário abortar: salvar `.draft` dos artefatos em andamento + registrar em `_pendencias.md`

---

## TRANSIÇÕES DE ESTADO (estado-projeto.yaml)

| Momento | Campo atualizado |
|---|---|
| Início do workflow | `marco_corrente: M2`, `gate_status.gate_2: pendente`, `loop_m2_iteracoes: 0` |
| Início Fase A | `artefatos: [elicitacao-raw.md]` |
| Início Fase B iteração N | `loop_m2_iteracoes: N` |
| Após [B6] traducao-gate | `artefatos: [lista completa M2]` |
| Gate 2 aprovado | `gate_status.gate_2: aprovado`, `versao_leigo_aprovada: [03.1-funcionais-leigo.md, 03.2-qualidade-leigo.md, 03.3-restricoes-leigo.md]` |
| Gate 2 reprovado | `gate_status.gate_2: pendente` (permanece; feedback do usuário registrado) |
