# presidio-oss/specif-ai

**URL:** https://github.com/presidio-oss/specif-ai
**Autor:** Presidio (presidio-oss)
**Linguagem dominante:** TypeScript (~84%)
**Stack principal:** Electron + Angular + LangGraph

---

## 1. O que é

Aplicação desktop (Electron + Angular) descrita como "AI-powered platform that transforms project requirements management", voltada a automatizar a geração de documentação de requisitos e tarefas a partir de uma descrição inicial de projeto. O **público-alvo declarado/implícito é equipes de desenvolvimento de software** — analistas, PMs, desenvolvedores. O vocabulário da interface (BRD, NFR, PRD, integração com Jira/ADO, campo "tech stack") e os formulários deixam claro que o usuário esperado é profissional técnico, não cliente leigo.

---

## 2. Arquitetura

Monorepo com três áreas principais: `ui/` (Angular + Tailwind), `electron/` (backend Electron com fluxos agênticos), `docs/` (Docusaurus).

A espinha dorsal agentic está em `electron/agentic/`, com **10 workflows LangGraph independentes**:

| Workflow | Responsabilidade |
|---|---|
| `create-solution-workflow` | Pipeline principal: BRD + UIR + NFR em paralelo → PRD |
| `requirement-gen-workflow` | Geração com loop de validação automático |
| `inline-edit-workflow` | Edição pontual via seleção de texto |
| `react-agent` | Agente ReAct para pesquisa com ferramentas |
| `suggestion-workflow` | Sugestões contextuais |
| `task-workflow` | Geração de tarefas a partir de requisitos |
| `test-case-workflow` | Geração de casos de teste |
| `usecase-workflow` | Geração de casos de uso |
| `user-story-workflow` | Geração de histórias de usuário |
| `common` | Utilitários compartilhados |

Cada workflow segue o padrão: `index.ts` (grafo LangGraph) + `nodes.ts` (nós do grafo) + `state.ts` (estado tipado TypeScript) + `types.ts` + `utils.ts`.

Prompts organizados em **5 famílias** em `electron/prompts/`:
- `context/` — definições reutilizáveis por tipo de artefato (brd.ts, prd.ts, nfr.ts, uir.ts...)
- `core/` — chat, suggestions, inline edit
- `feature/`, `requirement/`, `solution/` — instruções de geração
- `visualization/`

**Fluxo `create-solution-workflow` — determinístico, sem human-in-the-loop:**

```
START → research (ReAct com tools) → [generate_brd ∥ generate_uir ∥ generate_nfr] → generate_prd → END
```

Três geradores rodam em paralelo e convergem no PRD. Único gate humano = botão "Create".

**`requirement-gen-workflow` — loop de validação automatizado:**

```
buildLLMNode → parseAndValidateGeneratedRequirementsNode
               ↑ shouldContinueEdge / isTaskCompleteEdge (até 3-4 retries)
```

Feedback estruturado é passado ao modelo em cada retry; sem intervenção humana no ciclo.

---

## 3. Técnicas de elicitação / geração

Elicitação inicial **minimalista**: formulário com nome do projeto, descrição livre em prosa, stack técnico, toggle "Built Status" e "Requirement Threshold" (default: 15 requisitos por categoria). Um único input — toda a riqueza do output depende da qualidade da prosa fornecida.

Pós-geração, há três modos de interação:
- **Intelligent Chat** (`chat-with-ai.ts`): conversa com personas dinâmicas — BA (para BRD), PM (para PRD/NFR), BD Consultant (para SI).
- **Inline Editing**: seleção de texto → ícone sparkle → instrução em linguagem natural.
- **Suggestion Workflow**: sugestões contextuais.

Não há slot-filling estruturado, perguntas sequenciais guiadas, primitiva tipo `ask_user`, limite de perguntas por chamada, nem sub-módulos visíveis dedicados a detecção de conflitos ou requisitos implícitos. Existe `electron/guardrails/` (não inspecionado).

---

## 4. Saída

Artefatos em **JSON** (não Markdown), organizados em hierarquia de pastas no workspace local: BRD, PRD, NFR, UIR, TC, SI, BP, User Stories, Tasks.

Esquema dos requisitos:

```json
{ "brd": [{ "id": "BRD1", "title": "...", "requirement": "..." }] }
{ "prd": [{ "id": "PRD1", "title": "...", "requirement": "...#### Screens...#### Personas...", "linkedBRDIds": ["BRD1"] }] }
```

Cada requisito é parágrafo descritivo em prosa com sub-seções via headings Markdown. Ordenação por business impact. User stories no formato "As a / I want / So that".

**Padrões formais:** nenhuma referência verificada a IEEE 29148, IREB §3.3.3, EARS ou RFC 2119 nos arquivos consultados. Rastreabilidade apenas via `linkedBRDIds` (PRD → BRD).

---

## 5. Stack e dependências

| Categoria | Tecnologias |
|---|---|
| Frontend | Electron + Angular + Tailwind CSS |
| Orquestração agentic | LangGraph (TypeScript) |
| Agente de pesquisa | ReAct (via MCP tools) |
| LLM providers | Azure OpenAI, OpenAI, AWS Bedrock (Claude), Anthropic, Gemini, OpenRouter, Ollama (7 providers) |
| Integrações | Jira, Azure DevOps, MCP servers, Bedrock Knowledge Base |
| Observabilidade | PostHog + Langfuse + Sentry |
| Deploy | Dockerfile + nginx.conf disponíveis |

---

## 6. Pontos fortes

1. **Separação context vs. prompt** — `prompts/context/*.ts` define conceitos reutilizáveis (o que é um BRD, o que é um NFR) separados das instruções de geração em `prompts/solution/*.ts`. Garante consistência terminológica entre todos os workflows sem repetição.
2. **Multi-workflow isolado e modular** — cada caso de uso tem grafo LangGraph próprio com estado tipado e independente. Facilita manutenção e testes isolados por funcionalidade.
3. **Loop de validação automatizado com retry estruturado** — `parseAndValidateGeneratedRequirementsNode` detecta falhas e devolve feedback estruturado ao modelo (até 3-4 ciclos) antes de aceitar o output. Reduz requisitos malformados sem intervenção humana.
4. **Suporte multi-provider LLM extenso** — 7 providers incluindo Ollama (local/privado), reduzindo dependência de vendor e permitindo troca sem reescrita de lógica.
5. **Integrações nativas com ferramentas corporativas** — Jira e ADO transformam o output em itens de backlog; Bedrock KB permite injetar base de conhecimento proprietária no processo.

---

## 7. Limitações

1. **Nenhum gate humano após "Create"** — pipeline executa de ponta a ponta de forma autônoma. Revisão humana acontece post-hoc, não como checkpoint de aprovação entre etapas.
2. **Elicitação minimalista na entrada** — 3 campos de formulário; toda a riqueza do output depende da prosa fornecida. Não funciona bem com usuário que não sabe articular o problema.
3. **Ausência de padrões formais** — sem IEEE 29148, IREB, EARS, RFC 2119. Saída útil mas não auditável como SRS formal.
4. **Sem detecção explícita de conflitos/implícitos** — sem sub-módulo visível dedicado ao "óbvio não-dito" ou contradições entre requisitos.
5. **Artefatos em JSON** — menos portáveis para documentação humana e versionamento git legível.

---

## 8. Inspirações para nossa ferramenta

| Inspiração | Impacto | Esforço | Decisão afetada |
|---|---|---|---|
| Separação context vs. prompt como camada formal (`prompts/context/`) | Alto | Baixo | Complementa [D7](../../planejamento/1%20-%20Decisões%20Tomadas.md) — formalizar definições reutilizáveis (o que é uma situação-problema, o que é um stakeholder) separadas das instruções de cada skill |
| Loop de validação automatizado com retry estruturado e feedback ao modelo | Alto | Médio | Complementa [D10](../../planejamento/1%20-%20Decisões%20Tomadas.md) — Agente Validação pode rodar auto-checklist IREB §3.8 antes do gate humano, retentando N vezes antes de apresentar ao leigo |
| Multi-workflow LangGraph com `state.ts` tipado por workflow | Médio | Alto | Desafia [D6](../../planejamento/1%20-%20Decisões%20Tomadas.md) — sub-agentes transversais poderiam ter estado próprio por invocação (não entre invocações), viabilizando contexto mais rico |
| Personas dinâmicas por leitor previsto (BA/PM/BD) | Médio | Baixo | Complementa [D1](../../planejamento/1%20-%20Decisões%20Tomadas.md) — cada agente-etapa adota persona ajustada ao seu interlocutor ("consultor acessível" vs "analista técnico") |
| Adapter pattern multi-provider LLM | Médio | Alto | Complementa [D11](../../planejamento/1%20-%20Decisões%20Tomadas.md) — facilita porte Gemini CLI → Claude Code sem reescrita de prompts |

---

## 9. Diferenças de filosofia

1. **Público técnico vs. leigo:** Specif AI usa vocabulário de ER técnico (BRD, NFR, PRD, Jira, tech stack) como interface primária. Nossa proposta ([D1](../../planejamento/1%20-%20Decisões%20Tomadas.md)) não admite jargão nas perguntas ao usuário; toda elicitação usa linguagem de dono de negócio.
2. **Pipeline autônomo vs. marcos com aprovação humana:** Specif AI tem um gate ("Create") e revisão post-hoc livre. Nossa proposta ([D3](../../planejamento/1%20-%20Decisões%20Tomadas.md)) tem M1/M2/M3 com aprovação explícita do stakeholder entre marcos — "approve before next phase" vs "AI generates, human edits later". Filosofias opostas sobre quem conduz o processo.
3. **Narrative-driven vs. padrão formal:** Specif AI é deliberadamente prosa livre sem padrões. Nossa proposta ([D4](../../planejamento/1%20-%20Decisões%20Tomadas.md), [D8](../../planejamento/1%20-%20Decisões%20Tomadas.md)) é IREB §3.3.3 + EARS + slots + RFC 2119, otimizando para auditabilidade e rastreabilidade formal acadêmica.

---

## 10. URLs consultadas

- https://github.com/presidio-oss/specif-ai
- https://github.com/presidio-oss/specif-ai/blob/main/README.md
- https://github.com/presidio-oss/specif-ai/blob/main/CONTRIBUTING.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/getting-started.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/core-features.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/requirement-types.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/solution-creation-management.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/ai-interaction.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/ai-generated-content.md
- https://github.com/presidio-oss/specif-ai/blob/main/docs/docs/current/business-workflows.md
- https://github.com/presidio-oss/specif-ai/blob/main/electron/agentic/create-solution-workflow/index.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/agentic/create-solution-workflow/nodes.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/agentic/requirement-gen-workflow/nodes.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/prompts/solution/create-brd.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/prompts/context/brd.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/prompts/context/nfr.ts
- https://github.com/presidio-oss/specif-ai/blob/main/electron/prompts/core/chat-with-ai.ts
- https://api.github.com/repos/presidio-oss/specif-ai/contents
