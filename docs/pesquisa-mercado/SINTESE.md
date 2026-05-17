# Síntese — Pesquisa de Mercado (SDD + Ferramentas Correlatas)

**Data:** 2026-05-16
**Escopo:** presidio-oss/specif-ai, marcusgoll/Spec-Flow, bmad-code-org/BMAD-METHOD, github/spec-kit + repos correlatos + paradigma Spec-Driven Development.

---

## 1. Tabela comparativa

| Dimensão | specif-ai | Spec-Flow | BMAD-METHOD | Spec Kit | Nossa proposta |
|---|---|---|---|---|---|
| **Público-alvo** | Equipes técnicas (analistas, PMs, devs) | Times de desenvolvimento | Desenvolvedores e líderes técnicos | Desenvolvedores e PMs | Stakeholder leigo (dono de negócio) |
| **Primitiva de entrada** | Formulário 3 campos + prosa livre | Questionário inline + flags | Conversa livre + triggers curtos | Prosa livre para `/specify` | `ask_user choice/yesno` (até 4 perguntas por chamada) |
| **Arquitetura de agentes** | 10 workflows LangGraph isolados | Pipeline 11 fases + 3 orquestradores | 6 personas nomeadas + Party Mode | 9 comandos CLI em sequência | 6 agentes-etapa + 5 sub-agentes transversais apátridas |
| **Padrão de saída** | JSON sem padrão formal | Spec produto (RFC 2119, Gherkin, WCAG 2.2 AA) | PRD/Épicos/Stories (sem padrão formal) | Spec SDD (sem IREB/IEEE 29148) | SRS IREB §3.3.3 + EARS + slots + RFC 2119 |
| **Gates humanos** | Um (botão "Create") — revisão post-hoc | Um manual (`/validate-staging`) — foco em código | Gate entre Fase 3 e 4 (PASS/CONCERNS/FAIL) — decisão humana | Nenhum gate estruturado | M1/M2/M3 com aprovação explícita do leigo |
| **Estado do workflow** | Sem estado explícito | `state.yaml` por epic (source of truth) | Artefato-driven; handoffs entre fases | Inferido via Git branch | Detection-based (D10): Agente Gerência infere marco por artefatos no disco |
| **Distribuição** | App Electron desktop | Toolkit instalável via `npx` | Toolkit instalável via `npx bmad-method install` | CLI Python (`specify-cli`) | Skills SKILL.md em Gemini CLI / Claude Code |
| **Rastreabilidade** | `linkedBRDIds` (PRD → BRD) | Traceability matrix no spec-template | Handoff artefato-driven entre fases | Análise cross-artifact via `/speckit.analyze` | Prevista em D4 e D8 (IREB §3.3.3) |
| **Multi-agente real** | Workflows paralelos LangGraph | Domain Memory (workers atômicos apátridas) | Party Mode (subagentes reais em paralelo via Agent Tool) | 30+ agentes via 4 mecanismos de integração | Sub-agentes transversais apátridas (D6); Party Mode como inspiração para M2 |
| **Elicitação estruturada** | Nenhuma | Question batching + /clarify fase dedicada | `bmad-advanced-elicitation` com 50 métodos em 12 categorias | `/speckit.clarify` com taxonomia 9 categorias | `ask_user` + sub-agente Implícitos + sub-agente NLP |
| **Padrões formais** | Nenhum verificado | RFC 2119, Gherkin, WCAG 2.2 AA | Nenhum verificado | RFC 2119 implícito | IEEE 29148, IREB §3.3.3, EARS, RFC 2119 |

---

## 2. Mapa de inspirações consolidadas

Agrupadas por decisão afetada, ordenadas por impacto descendente.

### D1 — Primitiva `ask_user` e público leigo

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| Personas dinâmicas por leitor previsto (BA/PM/BD) | specif-ai | Médio | Baixo |
| Menu interativo numerado `[1-4][r][x]` do `bmad-advanced-elicitation` | BMAD-METHOD | Médio | Baixo |

### D4 + D8 — SRS formal + rastreabilidade

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| Traceability matrix como seção obrigatória do spec-template | Spec-Flow | Médio | Baixo |
| `/speckit.taskstoissues` — artefato de saída como item rastreável | Spec Kit | Baixo | Baixo |

### D6 — Sub-agentes transversais apátridas

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| Party Mode com subagentes reais em paralelo + protocolo de discordância autêntica | BMAD-METHOD | Alto | Médio |
| Biblioteca de 50 métodos em `methods.csv` separada da lógica de seleção | BMAD-METHOD | Alto | Baixo |
| Question batching — agentes retornam queries em lote antes de re-spawn | Spec-Flow | Alto | Baixo |
| Taxonomia de 9 categorias de ambiguidade do `/speckit.clarify` | Spec Kit | Médio | Baixo |
| Token budget por fase + auto-compact acima de 80% | Spec-Flow | Médio | Médio |
| Multi-workflow LangGraph com `state.ts` tipado por workflow | specif-ai | Médio | Alto |

### D7 — Separação de responsabilidades entre agentes

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| Separação context vs. prompt como camada formal (`prompts/context/`) | specif-ai | Alto | Baixo |

### D10 — Agente Gerência e recuperação de sessão

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| `project-context.md` como constituição compartilhada carregada por 7 workflows | BMAD-METHOD | Alto | Baixo |
| `state.yaml` por projeto como source of truth — recovery determinístico | Spec-Flow | Alto | Baixo |
| Loop de validação automatizado com retry estruturado e feedback ao modelo | specif-ai | Alto | Médio |
| `bmad-help` com scan de artefatos para orientação contextual | BMAD-METHOD | Médio | Baixo |

### D11 — Porte Claude Code

| Inspiração | Origem | Impacto | Esforço |
|---|---|---|---|
| Engine canônico vs. adapter por IDE (`.spec-flow/` + `.claude/`) | Spec-Flow | Alto | Médio |
| Adapter multi-provider LLM | specif-ai | Médio | Alto |

---

## 3. Decisões candidatas D12–D19

**Status:** provisórias — pendentes de aprovação. Não alteram `docs/planejamento/1 - Decisões Tomadas.md` até revisão explícita.

### D12 — Separação engine canônico vs. adapter por IDE

**Inspiração:** Spec-Flow (`.spec-flow/` + `.claude/` + `.codex/`).
**Proposta:** Toda a lógica de prompt, estrutura de agentes e artefatos reside em um diretório-engine agnóstico de plataforma. O adapter por IDE (Gemini CLI, Claude Code) é um wrapper fino que mapeia primitivas (`ask_user` → `AskUserQuestion`, `Task()` → `Agent()`) sem redefinir comportamento.
**Por que:** reduz o esforço do porte Claude Code (D11) de reescrita a adaptação de interface. Viabiliza futuro porte Gemini CLI sem duplicação.
**Refina:** [D11](../planejamento/1%20-%20Decisões%20Tomadas.md)

---

### D13 — `estado-projeto.yaml` como source of truth explícito

**Inspiração:** Spec-Flow (`state.yaml` por epic).
**Proposta:** Em vez de inferência por artefatos no disco (D10), o Agente Gerência mantém um `estado-projeto.yaml` com marco atual, sub-fase, artefatos produzidos e pautas abertas. Recovery é leitura determinística do arquivo, não heurística de detecção.
**Por que:** torna o recovery mais robusto e auditável. A inferência por artefatos (D10 atual) funciona em casos simples mas é frágil após remoções ou renomeações de arquivo.
**Tensão:** mantém file-system como meio de estado (compatível com D10), mas adiciona um artefato de controle explícito.
**Refina:** [D10](../planejamento/1%20-%20Decisões%20Tomadas.md)

---

### D14 — Question batching formalizado

**Inspiração:** Spec-Flow (agentes retornam queries em batch; main context coleta antes de re-spawn).
**Proposta:** formalizar o padrão de que cada agente ou sub-agente colete todas as perguntas necessárias antes de invocar `ask_user`, agrupa em no máximo 4 (limite da primitiva) e processa as respostas antes de spawnar novamente. Elimina invocações individuais de `ask_user` para cada gap detectado.
**Por que:** reduz o número de context-switches e respeita o limite de 4 perguntas por chamada da primitiva `ask_user` de forma sistemática, não ad hoc.
**Refina:** [D6](../planejamento/1%20-%20Decisões%20Tomadas.md)

---

### D15 — `constitution.md` como artefato versionado de guardrails

**Inspiração:** GitHub Spec Kit (`/speckit.constitution`).
**Proposta:** criar um `constitution.md` no início do projeto que versiona as decisões D1-D11 (leigo-first, gates M1/M2/M3, público não-técnico, IREB §3.3.3, sub-agentes apátridas, etc.) como guardrails permanentes. Todos os 6 agentes-etapa e 5 sub-agentes transversais o carregam automaticamente no início de cada invocação.
**Por que:** garante que futuros agentes (e futuras versões da ferramenta) não produzam saídas incompatíveis com as premissas do projeto. Atualmente os guardrails estão em `docs/planejamento/`, fora do contexto operacional dos agentes.
**Refina:** formaliza [D1](../planejamento/1%20-%20Decisões%20Tomadas.md) através [D11](../planejamento/1%20-%20Decisões%20Tomadas.md) como artefato vivo.

---

### D16 — Sub-fase de clarificação explícita entre Visão e Elicitação

**Inspiração:** GitHub Spec Kit (`/speckit.clarify` com taxonomia de 9 categorias).
**Proposta:** após o Agente Visão produzir `visao-produto.md`, uma sub-fase de clarificação analisa o documento em busca de lacunas nas categorias adaptadas (escopo funcional, restrições de negócio, casos de borda, terminologia do domínio, sinais de conclusão). Seleciona as 5 lacunas de maior impacto e usa `ask_user choice` para resolvê-las antes de iniciar a elicitação profunda.
**Por que:** o Agente Elicitação hoje recebe `visao-produto.md` diretamente e pode iniciar elicitação com ambiguidades não resolvidas que poderiam ter sido capturadas antes com perguntas simples. Conserva D1 (todas as interações via `ask_user choice/yesno`).
**Decisão afetada:** possível novo micro-agente ou skill do Agente Visão. Candidato a novo passo no fluxo M1.

---

### D17 — Fase `/analyze` cross-artifact pré-gate M3

**Inspiração:** GitHub Spec Kit (`/speckit.analyze` com CRITICAL/HIGH/MEDIUM/LOW).
**Proposta:** o Agente Validação, antes de apresentar o artefato de aprovação ao leigo no gate M3, roda uma checagem de consistência cross-artifact: Visão ↔ Elicitação ↔ SRS ↔ casos de uso. Classifica inconsistências em CRITICAL (bloqueia a apresentação), HIGH (apresenta com destaque), MEDIUM/LOW (nota informativa). Apenas artefatos sem issues CRITICAL chegam ao leigo.
**Por que:** hoje o Agente Validação verifica qualidade da SRS mas não verifica consistência entre artefatos de fases anteriores. Uma contradição entre `visao-produto.md` e a SRS que só é detectada pelo leigo no gate M3 causa retrabalho de toda a elicitação.
**Refina:** papel do Agente Validação em [D6](../planejamento/1%20-%20Decisões%20Tomadas.md) e [D3](../planejamento/1%20-%20Decisões%20Tomadas.md).

---

### D18 — Tradução dupla: versão leigo + versão normativa

**Motivação:** tensão T3 do paradigma SDD (ver `spec-driven-development.md` §7) — "spec-as-source" pode otimizar para LLM a custo da legibilidade humana; nossa SRS precisa ser legível por leigo no gate de aprovação.
**Proposta:** cada artefato-gate tem duas versões: (a) versão normativa em IREB §3.3.3 + EARS + RFC 2119, para entrega à equipe técnica; (b) versão leigo em linguagem de dono de negócio, apresentada no gate de aprovação. O leigo aprova a versão (b); a equipe técnica recebe a versão (a).
**Por que:** os gates M1/M2/M3 (D3) só funcionam se o leigo realmente compreende o que está aprovando. Apresentar IREB §3.3.3 diretamente a um leigo invalida o propósito do gate.
**Novo:** não refina uma decisão existente — é mecanismo novo de mediação leigo/técnico.

---

### D19 — Skill "tradutor reverso"

**Motivação:** mesmo com a tradução dupla (D18), textos técnicos gerados por agentes anteriores podem vazar para a interface do leigo. É preciso um mecanismo de verificação.
**Proposta:** skill transversal `tradução-leigo` que, dado qualquer trecho de texto, verifica se contém jargão ER (da blacklist em `visao-produto.md`) e gera alternativa em linguagem de negócio. Invocável por qualquer agente-etapa antes de apresentar texto ao usuário.
**Por que:** a blacklist de jargão (D1) é uma regra, não um mecanismo de enforcement. A skill implementa o enforcement de forma reutilizável.
**Refina:** enforcement de [D1](../planejamento/1%20-%20Decisões%20Tomadas.md).

---

## 4. Tensões não resolvidas

### T1 — SDD assume autor técnico; D1 assume leigo

Todas as ferramentas estudadas — Spec Kit, BMAD, Spec-Flow, Specif-AI — assumem que quem formula a spec tem literacia técnica. Adotar fluxos como `/speckit.specify` ou a entrada de formulário do Specif-AI literalmente colide com D1. A resolução proposta (D18 + D19 + primitiva `ask_user`) é uma divergência arquitetural consciente do mainstream SDD que deve ser justificada na dissertação como "escolha motivada pelo público-alvo".

### T2 — "spec-as-source" vs. SRS como contrato humano-legível

No nível spec-as-source (o mais radical do SDD), a spec é otimizada para consumo por LLM, não para leitura humana. Nossa proposta opera no nível **spec-first** ou **spec-anchored** — nunca spec-as-source. A SRS é artefato terminal humano-legível; artefatos intermediários dos agentes podem ser otimizados para o agente, mas o artefato entregue ao leigo e à equipe técnica precisa ser legível por humanos.

### T3 — Party Mode (BMAD) requer múltiplas instâncias paralelas vs. primitiva `ask_user` sequencial

O Party Mode do BMAD spawna 2-4 subagentes em paralelo, cada um com perspectiva independente. Nossa primitiva `ask_user` é sequencial e sínciona — um agente faz perguntas, o leigo responde, o agente processa. Aplicar Party Mode no gate M2 (onde conflitos e implícitos precisam ser revisados) exige que a síntese das perspectivas paralelas seja serializada antes de ser apresentada ao leigo. Isso é viável mas adiciona uma camada de orquestração não prevista em D6.

### T4 — `estado-projeto.yaml` (D13) vs. detection-based recovery (D10)

D10 atual usa inferência por artefatos no disco para detectar o marco atual. D13 propõe um arquivo de estado explícito. As duas abordagens não são excludentes, mas criam redundância: se o `estado-projeto.yaml` diverge dos artefatos no disco (por edição manual ou corrupção), qual prevalece? A política de resolução de conflito precisa ser definida antes de implementar D13.

---

## 5. Repos a revisitar na próxima iteração

| Repo | Quando | Por quê |
|---|---|---|
| ba-skills (GiangGiangTran) | Antes de implementar skills do porte Claude Code (Semana 5+) | Formato quase idêntico ao nosso MVP CC; verificar overlap para não duplicar trabalho |
| MARE (arXiv 2405.03256) | Na redação da seção "trabalho correlato" | Única referência peer-reviewed com múltiplos agentes para ER; comparar nossa decomposição 6+5 com os 5 agentes lineares do MARE |
| specif-ai — `electron/agentic/` | Antes de implementar Agente Validação | Loop de validação com retry estruturado (`parseAndValidateGeneratedRequirementsNode`) é a implementação mais madura de auto-checklist que encontramos |
| BMAD Party Mode — `bmad-party-mode/SKILL.md` | Ao projetar sub-fase M2 (revisão paralela) | Protocolo de discordância autêntica + síntese de perspectivas divergentes para gate M2 |
| spec-compare (cameronsjo) | Na dissertação, seção comparativa | Benchmark independente de 6 ferramentas SDD pronto para uso como referência secundária |

---

## 6. Próximos passos sugeridos

Estes passos dependem de aprovação parcial das D12+ por parte do orientador/banca antes de execução:

1. **Aprovar subset de D12-D19** — identificar quais candidatas são incorporadas imediatamente vs. registradas como trabalho futuro. Proposta inicial: D13, D14 e D15 têm alto impacto e baixo esforço; candidatas para incorporação imediata.

2. **Atualizar `docs/planejamento/1 - Decisões Tomadas.md`** — para cada D aprovada, adicionar entrada formal com justificativa, inspiração, impacto e esforço. Manter D1-D11 intactas; D12+ são adições, não substituições.

3. **Revisar `docs/planejamento/3 - Arquitetura da Ferramenta.md`** — incorporar D15 (`constitution.md`) e D17 (fase `/analyze` pré-M3) na arquitetura dos agentes; verificar se a sub-fase D16 requer novo agente-etapa ou pode ser skill do Agente Visão.

4. **Revisar `docs/planejamento/ROADMAP.md`** — inserir tarefa de criação do `constitution.md` (D15) no Sprint 1; inserir task de `estado-projeto.yaml` (D13) antes das primeiras skills de estado.

5. **Revisar ba-skills e awesome-claude-code-subagents** antes de implementar o catálogo de skills do porte Claude Code (D11) — evitar duplicação de prompts de elicitação já validados.

6. **Estudar MARE (arXiv 2405.03256)** antes da redação da seção "trabalho correlato" da dissertação — necessário para justificar a decomposição 6+5 em relação ao baseline acadêmico mais próximo.
