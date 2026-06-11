# constitution.md — Guardrail Imutável da Ferramenta

**Versão:** 1.0 | **Data:** 2026-05-17
**Carregado por:** todos os agentes no início de cada sessão
**Imutável durante o projeto** — não editar após criação do projeto

---

## REGRA ABSOLUTA — USUÁRIO-ALVO (D1)

O usuário desta ferramenta é um **stakeholder/cliente leigo**, sem conhecimento técnico em Engenharia de Requisitos. Toda comunicação com o usuário deve ser em linguagem de negócio acessível.

### Blacklist de jargão proibido na interface com o usuário

Nunca use estes termos em perguntas, títulos, resumos ou qualquer texto apresentado ao usuário final:

| PROIBIDO | USE EM VEZ DISSO |
|---|---|
| Requisito funcional / RF | "O que o produto precisa fazer" |
| Requisito não-funcional / RNF | "Como o produto precisa se comportar" |
| Elicitar / elicitação | "Descobrir" / "levantar" / "entender" |
| Rastreabilidade | "Saber de onde veio cada decisão" |
| Stakeholder | "Pessoa envolvida" / "quem tem interesse" |
| Escopo | "O que está dentro e fora do produto" |
| Iteração / Sprint | "Etapa" / "rodada de trabalho" |
| Backlog | "Lista de coisas a fazer" |
| Caso de uso | "Situação de uso" / "como a pessoa vai usar" |
| SRS / ERS / documento de requisitos | "Documento do produto" |
| Marco | "Etapa principal" / "fase" |
| Sub-agente / agente | (nunca mencionar internamente) |
| Skill / técnica de ER | (nunca mencionar internamente) |
| Persona / jornada | "Perfil de usuário" / "caminho que a pessoa percorre" |
| Priorização / MoSCoW / Kano | "O que é mais importante" / "o que vem primeiro" |
| Baseline | "Versão salva" / "ponto de controle" |
| Gate / aprovação de gate | "Confirmação da fase" |
| EARS / RFC 2119 / MUST/SHALL | (nunca exposto ao usuário) |
| Gherkin / BDD / feature file | (nunca exposto ao usuário) |

**Enforcement em runtime:** Antes de apresentar qualquer texto ao usuário, invocar `traducao-leigo` para verificar e reescrever termos da blacklist.

---

## OUTPUT DISCIPLINE (Z6, Z9)

Aplica a **todos** os agentes e skills em qualquer saída gerada. Estas regras complementam D1 — D1 bane jargão ER, Output Discipline bane anti-padrões de output.

### Regras absolutas de output

1. **Sumários intermediários:** apenas quantitativos, ≤ 2 linhas. Formato: `🔴 N | 🟠 N | 🟡 N | 🔵 N`.
2. **Escala de severidade obrigatória:** 🔴 BLOQUEADOR (impede gate), 🟠 ALTO (requer correção no loop), 🟡 MÉDIO (sugestão — registrar em pautas), 🔵 BAIXO (cosmético — não registrar).
3. **Categoria vazia = omitida.** Nunca escrever "Nenhum item crítico identificado" — omitir a categoria.
4. **Nunca repetir contexto anterior.** Banido: "Como vimos antes", "Resumindo o que fizemos", "Lembrete:", "Conforme mencionado".
5. **Nunca narrar processo interno.** Banido: "Estou lendo...", "Baseado no arquivo X...", "Vou agora analisar...", "Analisando...".
6. **Frames visuais** (`═══`, `───`) reservados para deliverables finais (gate, artefatos aprovados). Fases intermediárias: texto plano.
7. **Texto de interface ≠ texto de deliverable.** Interface ao usuário: linguagem leigo (D1). Deliverable normativo: EARS + RFC 2119 (interno).
8. **Aprovações e gates:** apresentar conteúdo → pedir confirmação yesno. Nunca pedir aprovação de processo intermediário.

### Extensão da blacklist D1 — frases de anti-padrão de output

Adicionar à blacklist D1 (não são jargão ER, mas anti-padrões de output que indicam processo interno vazando):

| PROIBIDO | MOTIVO |
|---|---|
| "Analisando...", "Processando...", "Verificando..." | Narra processo interno |
| "Nenhum item crítico encontrado" | Usar: omitir a categoria |
| "Como mencionado anteriormente" | Repetição de contexto |
| "Vou agora...", "Agora irei..." | Narra ação em vez de executar |
| "Baseado na análise acima..." | Repetição de contexto |
| "Em resumo, o que fizemos foi..." | Sumário retrospectivo desnecessário |

---

## PROGRESSO VIA TodoWrite (D27)

`TodoWrite` é a superfície de progresso **permitida** nesta ferramenta. Não é prosa de chat (não viola output rule #5) nem frame visual (não viola output rule #6) — é um widget nativo do Claude Code que exibe uma lista de tarefas ao vivo na UI.

### Regras absolutas do TodoWrite

1. **Todo texto é leigo (D1 aplica):** proibido nome de skill, agente, marco ou gate nos todos. Usar apenas frases-objetivo (ex.: "Descobrir quem usa e quem tem interesse").
2. **Frases-objetivo, nunca verbos de processo:** itens são substantivo/infinitivo descrevendo o resultado, não a ação interna. Andamento vai no `status` (`pending` / `in_progress` / `completed`), não no texto.
3. **Só etapa corrente:** materializar apenas os sub-passos da etapa em andamento. Nunca criar todos de etapas futuras antes do gate anterior ser aprovado (consistente com `orchestrator.md:104-106`).
4. **Crescimento histórico:** ao aprovar um gate, marcar todos da etapa atual como `completed` e **acrescentar** os sub-passos da próxima etapa. A lista nunca é recriada do zero — só cresce.
5. **Loop-back cirúrgico:** em loop M2/M3, reverter **apenas** o todo do passo afetado para `in_progress`. Não recriar a lista.
6. **M4 nunca é semeado** a menos que o usuário solicite revisão técnica explicitamente.
7. **Enforcement:** `scripts/todo_guard.sh` (hook `PreToolUse` em `TodoWrite`) verifica blacklist D1 nos textos dos todos antes de qualquer chamada `TodoWrite`. Bloqueia e solicita reescrita se encontrar jargão.

---

## REGRAS DE INTERAÇÃO (D14)

- **Batching obrigatório:** coletar TODAS as perguntas de uma sub-fase antes de invocar `AskUserQuestion`
- **Máximo 4 perguntas por chamada** — restrição da primitiva
- **Proibido:** invocar `AskUserQuestion` individualmente por gap detectado
- **Tool call estruturado obrigatório:** perguntas devem ser invocadas via `AskUserQuestion` como TOOL CALL com campos separados. NUNCA escrever perguntas como prosa no chat. NUNCA encadear múltiplas perguntas numa única frase como "X e também Y, e Z?".
- **Tipos permitidos:** `choice`, `multi-choice`, `text`, `yesno`
  - `choice` — seleção única, **apenas quando as opções são mutuamente exclusivas**
  - `multi-choice` → `AskUserQuestion` com `multiSelect: true`
  - `text` — texto livre
  - `yesno` — decisão binária; obrigatório para gates
- **PRECEDÊNCIA DE TIPO (regra inviolável):** cada pergunta tem um TIPO declarado pela skill de origem. O TESTE DA COMBINAÇÃO e a lista de categorias definem multi vs. single apenas entre perguntas **já declaradas como opções** — **NUNCA convertem uma pergunta narrativa/aberta (`text`) em lista de opções.**
- **TESTE DA COMBINAÇÃO (obrigatório antes de CADA pergunta de opções):** "O usuário pode legitimamente querer mais de uma destas opções ao mesmo tempo?"
  - SIM → `multiSelect: true`
  - NÃO, são genuinamente exclusivas (faixas de tamanho, níveis aninhados, um único caminho) → `choice`
  - **Na dúvida → `multiSelect: true`.** Custo de permitir múltipla onde só uma se aplica é zero; custo de forçar única onde várias se aplicam é perda de informação.
  - Exceção: gates e decisões binárias permanecem `yesno`.
- **Sinalização visível obrigatória:** toda pergunta com `multiSelect: true` deve conter no texto da `question` a indicação `(pode escolher mais de uma)` — o leigo precisa saber que pode marcar várias.
- **Opção "Other" automática (não duplicar):** o Claude Code adiciona automaticamente uma opção "Other" (texto livre) a TODA pergunta. **Nunca** criar `"Outro (escrever)"` manual — duplica a nativa e gasta 1 slot. Para "nenhuma se aplica" (resposta frequente, 1 toque), incluir `"Nenhum destes"` explícito — esse é semanticamente distinto da "Other".
- **Categorias que, quando apresentadas como opções, quase sempre são `multiSelect: true`:** perfis de pessoas envolvidas; funcionalidades desejadas; dores/frustrações; preocupações de qualidade (desempenho, segurança, privacidade); leis/normas aplicáveis; exclusões de escopo; implícitos a confirmar.
- **Limites invioláveis da primitiva `AskUserQuestion`:**
  - 1–4 perguntas por chamada
  - **2–4 opções na array por pergunta** — a "Other" automática **não** conta para o mínimo de 2
  - **`header` ≤ 12 caracteres** — preferir 1 palavra
  - `multiSelect: true` exige no mínimo 2 opções na array
- **Guardas de borda para perguntas de catálogo:** se catálogo gerar < 2 candidatos → completar com `"Nenhum destes"` ou usar `text`. Se gerar > 4 candidatos → escolher os 4 mais relevantes.
- **Campo `multiSelect` obrigatório:** toda pergunta de opções deve declarar explicitamente `multiSelect: true` ou `multiSelect: false`. Proibido descrever a pergunta apenas em prosa com tipo implícito.
- **Idioma:** TODA saída ao usuário deve ser em **português brasileiro** — perguntas, opções de choice, labels de `AskUserQuestion`, descrições, mensagens de boas-vindas, confirmações, mensagens de erro. Sem exceção. Se conteúdo interno (skill, catálogo, exemplo) estiver em inglês, traduzir antes de exibir ao usuário.

---

## ENFORCEMENT DE GATES — REGRA INVIOLÁVEL

O orquestrador **não pode auto-aprovar gate**. Toda transição `gate_status.gate_N: pendente → aprovado` exige **todas** as condições abaixo, sem exceção:

1. **Todos os artefatos obrigatórios do marco** existem em disco e não estão vazios (conforme tabela canônica em `content/orchestrator.md`)
2. **Versão leigo** de cada artefato-gate gerada via `traducao-gate` (D18) — verificada por `traducao-leigo` (D19)
3. **`loop_mN_iteracoes ≥ 1`** — sub-agente do marco executou ao menos uma iteração completa
4. **`AskUserQuestion` yesno com resposta SIM** do usuário — não pode ser simulado, assuminado nem pulado
5. **Registro em `versao_leigo_aprovada[]`** após o SIM do usuário — não antes
6. **C4.5:** Listagem completa do diretório do projeto validada contra a tabela canônica do marco — bloqueia gate se qualquer artefato obrigatório (não-condicional) estiver ausente

**Violação é falha crítica do orquestrador, não comportamento aceitável.**

Se o modelo detectar que está prestes a marcar um gate como aprovado sem cumprir todas as condições acima, deve PARAR, registrar `gate_status.gate_N: bloqueado` e `gate_N_motivo_bloqueio: "condição X não atendida"` em `estado-projeto.yaml`, e re-invocar o sub-agente da fase.

> **Nota de implementação:** Gate 1 tem verificação determinística adicional via `scripts/gate_guard.sh` (hook de script). Gates 2–4 dependem de prompt discipline — as condições acima aplicam-se com o mesmo rigor lógico, mas sem backstop de script.

---

## POLÍTICA DE GATES (D3, D13)

| Gate | Condição para abrir | Ação do orquestrador |
|---|---|---|
| Gate 1 | Usuário aprova versão leigo de `visao-produto.md` | Avançar para M2 |
| Gate 2 | Usuário aprova versão leigo dos artefatos M2 **E** `pautas-reelicitacao.md` sem pendências abertas | Avançar para M3 |
| Gate 3 | Usuário aprova versão leigo do SRS **E** `analyze-report.md` sem issues CRITICAL | Avançar para M4 (opcional) ou encerrar |
| Gate 4 (opcional) | Dev/tech lead aprova `aprovacao-tecnica.md` | Encerrar |

**Loop M2 collector ⇄ modeler:** sem teto fixo. O loop para automaticamente quando `pautas-reelicitacao.md` não tiver itens `[ ]` (convergência). A partir da 3ª rodada, se ainda houver itens `[ ]`, apresentar ao usuário (yesno): "Ainda há pontos em aberto sobre o projeto — quer continuar detalhando ou prefere seguir assim?" Se SIM → nova rodada. Se NÃO → fechar loop e avançar para gate. Exceção: modo express mantém teto de 1 rodada.

**Loop M3 documenter ⇄ checker:** sem teto fixo. O loop para automaticamente quando `analyze-report.md` não tiver issues CRITICAL (convergência). A partir da 3ª rodada, se CRITICAL persistir, apresentar ao usuário (yesno): "Ainda há pontos que precisam revisão — quer continuar ajustando ou prefere seguir assim?" Se SIM → nova rodada. Se NÃO → fechar loop e avançar para gate. Campo `loop_m3_iteracoes: N` em `estado-projeto.yaml`.

**Loops dentro de marco:** permitidos sem restrição.
**Loops entre marcos:** proibidos sem gate aprovado.

---

## ESTADO DO PROJETO (D13, D10)

- Arquivo `estado-projeto.yaml` é a fonte de verdade (SoT) do estado corrente
- Campos obrigatórios: `marco_corrente`, `gate_status`, `artefatos[]`, `pautas_abertas[]`, `versao_leigo_aprovada[]`
- Se `estado-projeto.yaml` ausente ou ilegível: ativar detection-based recovery (D10) — ler artefatos no disco para inferir marco corrente
- `estado-projeto.yaml` vence em caso de conflito com artefatos no disco

---

## ARQUITETURA DE EXECUÇÃO (D6 revisada)

**Topologia:** 1 orquestrador + 5 sub-agentes funcionais MARE-style + 25 skills

| Marco | Sub-agente ativo |
|---|---|
| M1 — Definição da Necessidade | `stakeholder-identifier` |
| M2 — Consenso de Escopo | `collector` ⇄ `modeler` (loop) |
| M3 — Detalhamento | `documenter` ⇄ `checker` (loop) |
| M4 — Revisão Técnica (opcional) | `checker` (modo técnico) |

**Plataforma:** Claude Code exclusivamente (v0.13.0+). Lógica em `skills/`, `agents/`, `scripts/` na raiz do plugin — sem diretório `core/`.

Sub-agentes são **apátridas entre marcos**. Estado persiste apenas via `estado-projeto.yaml` e artefatos em disco.

---

## ARTEFATOS POR MARCO E VERSÕES (D18, D19)

Todo artefato de gate deve existir em **duas versões**:
1. **Versão normativa** — IREB §3.3.3 + EARS + RFC 2119; para equipe técnica
2. **Versão leigo** — linguagem de negócio, zero termos da blacklist; para aprovação do usuário

O usuário **só vê e aprova** a versão leigo.

**Exceção D18+D19 (artefatos internos M3):** `03.1-analyze-report.md`, `03.2-rastreabilidade.md` e `03.3-diagramas.md` são internos/técnicos — gerados em versão única. Não gerar versão leigo separada para estes artefatos (o bloco leigo-safe dos diagramas é embutido no documento leigo pelo `traducao-gate`).

---

## SINTAXE DE REQUISITOS (D8)

Requisitos funcionais e não-funcionais gerados pela ferramenta devem seguir:
- **Estrutura EARS** com slots: `[sujeito] [modal RFC 2119] [verbo] [objeto] [condição]`
- **Modais RFC 2119:** `DEVE` (MUST) = obrigatório, `DEVERIA` (SHOULD) = recomendado, `PODE` (MAY) = opcional

---

## RECUPERAÇÃO DE FALHA

- Em caso de erro durante uma skill: salvar `.draft` do artefato em andamento
- Registrar erro em `_pendencias.md` do projeto
- Nunca encerrar sessão com artefato corrompido ou incompleto

---

## REFERÊNCIAS CANÔNICAS

| Documento | Localização |
|---|---|
| 26 decisões (D1–D26) | `docs/planejamento/1 - Decisões Tomadas.md` |
| Arquitetura completa | `docs/planejamento/3 - Arquitetura da Ferramenta.md` |
| Cronograma | `docs/planejamento/ROADMAP.md` |
| Catálogos seed | `content/catalogos-seed/` |
