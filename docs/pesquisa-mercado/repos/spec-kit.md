# github/spec-kit

**URL:** https://github.com/github/spec-kit
**Mantido por:** GitHub (organização `github`)
**Stars:** ~100.633 (verificado em 2026-05-16)
**Forks:** ~8.200+
**Licença:** MIT
**Linguagem dominante:** Python (CLI `specify-cli`) + Markdown/YAML (conteúdo operacional)
**Criado:** agosto 2025

---

## 1. O que é

O Spec Kit é a **referência canônica do paradigma Spec-Driven Development (SDD)**, criado e mantido pelo próprio GitHub. Descrição oficial: toolkit para transformar intenção de produto em software executável via especificações estruturadas que funcionam como prompts para agentes de IA. O **público-alvo declarado são equipes de desenvolvimento de software** — desenvolvedores, product managers e líderes técnicos confortáveis com agentes de IA. Não há adaptação de vocabulário para stakeholders não-técnicos.

A adoção massiva (~100k stars em menos de 12 meses) consolidou o Spec Kit como ponto de referência incontornável no ecossistema de ferramentas de agentes de IA em 2025-2026.

---

## 2. Arquitetura

### CLI e sistema de comandos

Instalação via Python CLI (`specify-cli`). Interação por **9 slash-commands** organizados em sequência lógica:

| Comando | Função |
|---|---|
| `/speckit.constitution` | Define princípios arquiteturais não-negociáveis do projeto. Gera `constitution.md`, carregado automaticamente por todos os comandos subsequentes como guardrail imutável. |
| `/speckit.specify` | Elicita requisitos funcionais e user stories a partir de descrição livre. Produz `spec.md`. |
| `/speckit.clarify` | Analisa `spec.md` em busca de áreas underspecified. Gera fila priorizada de 5 perguntas de alto impacto e as apresenta uma por vez com sugestão de resposta. |
| `/speckit.checklist` | Valida a spec contra uma checklist de critérios de qualidade antes de avançar para planejamento. |
| `/speckit.plan` | Traduz a spec em plano técnico de implementação. Produz `plan.md` com decisões de arquitetura e contratos de API. |
| `/speckit.analyze` | Validação cross-artifact com severidades CRITICAL / HIGH / MEDIUM / LOW. Verifica consistência entre constitution, spec, plan e tasks. |
| `/speckit.tasks` | Decompõe o plano em tarefas executáveis com dependências explícitas. Produz `tasks.md`. |
| `/speckit.taskstoissues` | Converte as tarefas de `tasks.md` em GitHub Issues com labels e milestones. |
| `/speckit.implement` | Delega execução das tarefas a agentes de IA com contexto completo da spec e do plano. |

### constitution.md como guardrail arquitetural

`constitution.md` é o artefato mais diferenciador do Spec Kit. Criado em `/speckit.constitution` como primeiro passo obrigatório, documenta princípios não-negociáveis (tech stack, constraints de segurança, padrões de qualidade, restrições de compliance). Todos os comandos subsequentes o carregam automaticamente — funciona como filtro que impede que agentes tomem decisões técnicas incompatíveis com as premissas definidas pelo time.

### Integração multi-agente

O Spec Kit suporta **30+ agentes de IA** via 4 mecanismos de integração:

| Tipo | Agentes suportados | Mecanismo |
|---|---|---|
| SkillsIntegration | Claude Code | Skills SKILL.md com auto-descoberta |
| Markdown | Qualquer agente que leia Markdown | Arquivos de instrução em `.spec-kit/` |
| TOML | Cursor, Continue, Cody | Arquivo de configuração `.spec-kit/config.toml` |
| YAML | GitHub Copilot, Codex CLI, Gemini CLI, opencode, Goose | Arquivo `spec-kit.yml` |

### Detecção de estado via Git

O Spec Kit detecta o estado atual do workflow via Git branch, sem arquivo de estado explícito. O comando `/speckit.analyze` infere quais artefatos já foram produzidos e quais são esperados com base na fase detectada.

---

## 3. Técnicas de elicitação / geração

O componente de maior valor analítico para elicitação é `/speckit.clarify`:

**Taxonomia de 9 categorias de ambiguidade:**

| Categoria | Descrição |
|---|---|
| Functional scope | O que o sistema deve e não deve fazer |
| Data model | Estruturas de dados, relações, constraints |
| Interaction flows | Fluxos de usuário e casos de borda |
| Non-functional requirements | Performance, segurança, escalabilidade |
| Integrations | APIs externas, sistemas legados |
| Edge cases | Comportamento em condições anômalas |
| Constraints | Limitações de negócio, legais, técnicas |
| Terminology | Glossário e definições de domínio |
| Completion signals | Critérios de aceite e definição de "done" |

**Fluxo do /speckit.clarify:**
1. Analisa `spec.md` buscando lacunas em cada uma das 9 categorias.
2. Seleciona as 5 perguntas de maior impacto e as ordena por prioridade.
3. Apresenta **uma pergunta por vez** com sugestão de resposta baseada no contexto.
4. Incorpora cada resposta à spec antes de apresentar a próxima pergunta.

Não há primitiva equivalente ao `ask_user` com limite de perguntas por chamada. O `/speckit.clarify` apresenta perguntas sequencialmente sem batching estruturado.

**`/speckit.analyze` — validação cross-artifact:**
- Avalia consistência entre `constitution.md`, `spec.md`, `plan.md` e `tasks.md`.
- Classifica problemas em 4 severidades: CRITICAL (bloqueia avanço), HIGH (requer resolução), MEDIUM (aconselhável), LOW (informativo).
- Produz relatório estruturado com problemas, localização exata no artefato e sugestão de correção.

Input via `/speckit.specify` é conversacional livre — sem formulário estruturado, sem slot-filling explícito, sem perguntas pré-definidas na entrada.

---

## 4. Saída

| Artefato | Comando gerador | Conteúdo |
|---|---|---|
| `constitution.md` | `/speckit.constitution` | Princípios não-negociáveis, tech stack, guardrails |
| `spec.md` | `/speckit.specify` + `/speckit.clarify` | Requisitos funcionais, user stories, critérios de aceite |
| `checklist-report.md` | `/speckit.checklist` | Validação da spec contra critérios de qualidade |
| `plan.md` | `/speckit.plan` | Plano técnico, decisões de arquitetura, contratos de API |
| `analysis-report.md` | `/speckit.analyze` | Inconsistências cross-artifact com severidade |
| `tasks.md` | `/speckit.tasks` | Tarefas com dependências e critérios de conclusão |
| GitHub Issues | `/speckit.taskstoissues` | Issues criadas na plataforma GitHub |

**Padrões verificados:** RFC 2119 implícito no vocabulário de requisitos (MUST/SHALL/SHOULD). Gherkin em cenários de aceite. **Não cita IEEE 29148, IREB §3.3.3 ou EARS** explicitamente nos arquivos consultados — o paradigma usa linguagem orientada a produto/agente, não a normas formais de ER.

---

## 5. Stack e dependências

| Categoria | Detalhe |
|---|---|
| CLI | Python (`specify-cli`) |
| Agentes suportados | 30+ (Claude Code, GitHub Copilot, Cursor, Gemini CLI, Codex CLI, Goose, opencode, Continue, Cody...) |
| Mecanismos de integração | SkillsIntegration (Claude Code), Markdown, TOML, YAML |
| Detecção de estado | Git branch (sem arquivo de estado explícito) |
| Artefatos | Markdown versionável em git |
| Integrações de saída | GitHub Issues (via `/speckit.taskstoissues`) |

---

## 6. Pontos fortes

1. **`constitution.md` como guardrail arquitetural carregado por todos os comandos** — o conceito de "constituição" resolve o problema de consistência entre agentes independentes sem coordenação em tempo real. Cada comando recebe os mesmos princípios fundacionais e não pode produzir artefatos que os contradigam.
2. **`/speckit.clarify` com taxonomia estruturada de 9 categorias** — converte elicitação vaga em análise sistemática de gaps por dimensão. A apresentação de perguntas uma por vez com sugestão de resposta reduz sobrecarga cognitiva sem sacrificar completude.
3. **`/speckit.analyze` com severidades CRITICAL/HIGH/MEDIUM/LOW e localização exata** — validação cross-artifact com gradação de severidade e feedback preciso. Permite ao time priorizar o que bloqueia vs. o que é recomendável.
4. **30+ integrações via 4 mecanismos padronizados** — a separação do mecanismo de integração (SkillsIntegration/Markdown/TOML/YAML) permite portar o Spec Kit para qualquer agente sem reescrever a lógica dos comandos.
5. **`/speckit.taskstoissues` — bridge direto para gestão de projeto** — converte tasks em GitHub Issues com contexto preservado; o artefato de saída do Spec Kit vira item de trabalho rastreável sem fricção manual.

---

## 7. Limitações

1. **Público exclusivamente técnico** — vocabulário dos comandos e dos artefatos (constitution, spec, plan, tasks, issues) pressupõe familiaridade com desenvolvimento de software. Sem mecanismo de simplificação de linguagem para stakeholder leigo.
2. **Detecção de estado por inferência Git** — ao contrário do `state.yaml` explícito do Spec-Flow, o Spec Kit infere o estado atual do projeto via branch. Menos determinístico e mais frágil em workflows com múltiplos branches ativos.
3. **Ausência de gates de aprovação humana estruturados** — o fluxo é sequencial e técnico. Não há marco equivalente aos gates M1/M2/M3 onde um stakeholder não-técnico aprova um artefato em linguagem acessível.
4. **`/speckit.specify` sem estrutura de entrada** — input conversacional livre funciona bem para usuário técnico mas falha quando o usuário não sabe articular a necessidade. O `/speckit.clarify` pressupõe que já existe uma spec inicial minimamente coerente para ser analisada.
5. **Padrões formais de ER ausentes** — sem IEEE 29148, IREB §3.3.3, EARS. A spec produzida é auditável por engenheiros mas não satisfaz requisitos acadêmicos ou normativos de um SRS formal.

---

## 8. Inspirações para nossa ferramenta

| Inspiração | Impacto | Esforço | Decisão afetada |
|---|---|---|---|
| **`constitution.md` como guardrail arquitetural** — artefato imutável carregado por todos os agentes, definindo princípios não-negociáveis | Alto | Baixo | Candidato [D15](../../planejamento/1%20-%20Decisões%20Tomadas.md) — criar `constitution.md` que versiona D1-D11 (leigo-first, gates M1/M2/M3, IREB §3.3.3) como guardrails lidos por todos os 6 agentes-etapa e 5 sub-agentes transversais |
| **`/speckit.clarify` — fase dedicada de resolução de underspecified areas** | Alto | Médio | Candidato [D16](../../planejamento/1%20-%20Decisões%20Tomadas.md) — inserir sub-fase de clarificação entre Agente Visão e Agente Elicitação, onde o agente lista lacunas detectadas e usa `ask_user choice` para resolvê-las antes da elicitação profunda; conserva D1 |
| **`/speckit.analyze` — validação cross-artifact com severidades** | Alto | Médio | Candidato [D17](../../planejamento/1%20-%20Decisões%20Tomadas.md) — Agente Validação roda checagem de consistência Visão↔Elicitação↔SRS↔casos de uso antes do gate M3, com saída estruturada CRITICAL/HIGH/MEDIUM/LOW; bloqueia M3 em CRITICAL não resolvido |
| **Taxonomia das 9 categorias de ambiguidade do `/speckit.clarify`** | Médio | Baixo | Complementa [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) — sub-agente Implícitos pode usar taxonomia adaptada (functional scope, data model, edge cases, terminology, completion signals) para categorizar lacunas detectadas por NLP antes de perguntar ao leigo |
| **`/speckit.taskstoissues` — artefato de saída como item rastreável** | Baixo | Baixo | Complementa [D4](../../planejamento/1%20-%20Decisões%20Tomadas.md) e [D8](../../planejamento/1%20-%20Decisões%20Tomadas.md) — a SRS gerada pode incluir seção de "tarefas sugeridas para a equipe técnica", não como /implement automático, mas como bridge rastreável para a equipe que vai desenvolver |

---

## 9. Diferenças de filosofia

1. **Sentido da tradução:** o Spec Kit traduz intenção de produto (já formulada tecnicamente) em artefatos executáveis para agentes de IA. Nossa proposta ([D1](../../planejamento/1%20-%20Decisões%20Tomadas.md)) faz a tradução anterior — da linguagem de negócio de um leigo para a spec técnica que ferramentas como o Spec Kit consumiriam. O Spec Kit começa onde nossa ferramenta termina.
2. **`/speckit.specify` vs. primitiva `ask_user`:** o Spec Kit recebe prosa livre e refina com `/clarify`. Nossa proposta não pode assumir que o leigo sabe formular prosa coerente — a primitiva `ask_user choice/yesno` estrutura a entrada antes de qualquer refinamento. As perguntas do `/clarify` são para analistas; nossas perguntas são para donos de negócio.
3. **SDD fluido vs. gates M1/M2/M3:** o Spec Kit favorece iteração — você pode rodar `/specify → /clarify → /specify → /clarify` em loop antes de avançar. Nossa proposta ([D3](../../planejamento/1%20-%20Decisões%20Tomadas.md)) é waterfall-leve com gates de aprovação humana explícita. A rigidez é coerente com D1: o leigo precisa de pontos de validação claros, não de um loop técnico que ele não consegue acompanhar.
4. **Formalidade de saída:** o Spec Kit produz spec SDD otimizada para consumo por agente de IA. Nossa proposta ([D4](../../planejamento/1%20-%20Decisões%20Tomadas.md)) produz SRS formal IREB §3.3.3 + EARS + RFC 2119, legível por humanos e auditável por banca acadêmica. Spec Kit + nossa SRS seriam complementares: nossa SRS → input do Spec Kit para times técnicos.

---

## 10. URLs consultadas

- https://github.com/github/spec-kit
- https://api.github.com/repos/github/spec-kit
- https://api.github.com/repos/github/spec-kit/contents
- https://raw.githubusercontent.com/github/spec-kit/main/README.md
- https://raw.githubusercontent.com/github/spec-kit/main/AGENTS.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/constitution.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/commands/clarify.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/commands/analyze.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/commands/specify.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/commands/plan.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/commands/tasks.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/integrations/claude-code.md
- https://raw.githubusercontent.com/github/spec-kit/main/docs/integrations/gemini-cli.md
