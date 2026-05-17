# Revisão das Decisões Candidatas D12-D19

**Data:** 2026-05-17
**Fonte das candidatas:** [docs/pesquisa-mercado/SINTESE.md §3](../pesquisa-mercado/SINTESE.md)
**Decisões fundadoras (baseline):** [docs/planejamento/1 - Decisões Tomadas.md](1%20-%20Decisões%20Tomadas.md) (D1-D11)
**Método:** revisão estruturada em 3 grupos temáticos com deliberação por candidata

---

## Sumário executivo

- **8 candidatas aceitas:** D12, D13 (com modificação), D14, D15, D16 (com modificação), D17, D18, D19
- **0 rejeitadas**
- **0 adiadas**
- **Tensão T4 (D13 vs. D10) resolvida:** D13 aceita como complemento — `estado-projeto.yaml` SoT primário + detection-based fallback
- **Tensão persistente:** T3 (Party Mode requer paralelismo; `ask_user` é sequencial) — não abordada nesta revisão; adiada para eventual implementação de revisão paralela no gate M2

---

## Grupo A — Infraestrutura (do Spec-Flow)

### D12 — Engine canônico vs. adapter por IDE

**Proposta:** toda a lógica de prompt/agentes reside em diretório agnóstico de plataforma (ex: `core/`). Adapters por IDE (`.gemini/`, `.claude/`) mapeiam primitivas (`ask_user` → `AskUserQuestion`) sem redefinir comportamento.

**Inspiração:** `marcusgoll/Spec-Flow` (estrutura `.spec-flow/` + `.claude/` + `.codex/`). Ver [repos/spec-flow.md](../pesquisa-mercado/repos/spec-flow.md) §8.

**Tensões:** nenhuma identificada — alinha diretamente com D11 (porte Claude Code).

**Recomendação inicial:** ACEITAR — alto impacto, médio esforço; elimina reescrita de lógica no porte.

**DECISÃO: ACEITA como está**

**Justificativa:** refina D11 ao tornar o porte Claude Code uma adaptação de interface em vez de duplicação de conteúdo de prompts.

---

### D13 — `estado-projeto.yaml` como SoT explícito

**Proposta:** o Agente Gerência mantém `estado-projeto.yaml` com marco atual, sub-fase, artefatos produzidos e pautas abertas. Detection-based (D10) funciona como fallback quando o yaml não existe.

**Inspiração:** `marcusgoll/Spec-Flow` (`state.yaml` por epic). Ver [repos/spec-flow.md](../pesquisa-mercado/repos/spec-flow.md) §8.

**Tensões:** T4 — D13 conflitava com D10 se yaml e artefatos divergissem. **Resolução adotada:** yaml tem prioridade; detection-based ativado apenas na ausência do yaml (primeira sessão, yaml corrompido ou inexistente).

**Recomendação inicial:** ACEITAR como complemento.

**DECISÃO: ACEITA com modificação — yaml SoT primário + detection-based fallback**

**Justificativa:** torna recovery determinístico sem eliminar a resiliência do D10. Se o yaml for corrompido ou ausente, a ferramenta ainda funciona via inferência por artefatos.

**Escopo modificado:** política de conflito explícita — `estado-projeto.yaml` vence quando presente e legível; detection-based ativado apenas quando yaml ausente ou ilegível.

---

### D14 — Question batching formalizado

**Proposta:** formalizar regra de implementação — agentes e sub-agentes coletam todas as perguntas necessárias antes de invocar `ask_user`, agrupando em lotes de até 4.

**Inspiração:** `marcusgoll/Spec-Flow` (question batching pattern). Ver [repos/spec-flow.md](../pesquisa-mercado/repos/spec-flow.md) §8.

**Tensões:** T3 (Party Mode requer paralelismo; `ask_user` é sequencial) — D14 só formaliza o padrão da primitiva; Party Mode é item futuro não relacionado.

**Recomendação inicial:** ACEITAR — baixo esforço; torna explícita uma restrição já existente.

**DECISÃO: ACEITA como está**

**Justificativa:** transforma a restrição da primitiva `ask_user` em regra de design de agente; previne chamadas individuais por gap que fragmentariam a experiência do leigo em múltiplos micro-turnos.

---

## Grupo B — Workflow / Gates (do Spec Kit)

### D15 — `constitution.md` como guardrail versionado

**Proposta:** criar `constitution.md` no início de cada projeto que codifica D1-D11 (leigo-first, gates M1/M2/M3, IREB §3.3.3, sub-agentes apátridas, etc.) como guardrails permanentes carregados por todos os agentes em runtime.

**Inspiração:** `github/spec-kit` (`/speckit.constitution`). Ver [repos/spec-kit.md](../pesquisa-mercado/repos/spec-kit.md) §8.

**Relação com `4 - Evolucao-SDD-TDD.md`:** esse doc propõe novos tipos de saída (spec SDD + testes TDD como extensão futura). `constitution.md` governa princípios de processo, não tipos de artefato — são ortogonais e compatíveis.

**Tensões:** nenhuma — D1-D11 já existem em `CLAUDE.md`; `constitution.md` os operacionaliza como filtro de prompt em runtime.

**Recomendação inicial:** ACEITAR — baixo esforço; alto valor à medida que o número de agentes aumenta.

**DECISÃO: ACEITA como está**

**Justificativa:** sem `constitution.md`, novas versões de agentes podem produzir artefatos incompatíveis com os guardrails do projeto sem que isso seja detectável até execução.

---

### D16 — Sub-fase de clarificação entre Visão e Elicitação

**Proposta:** após o Agente Visão produzir `visao-produto.md`, uma micro-fase detecta lacunas em categorias críticas (escopo funcional, restrições de negócio, terminologia do domínio) e as resolve via `ask_user choice` antes de iniciar a elicitação profunda.

**Inspiração:** `github/spec-kit` (`/speckit.clarify` com taxonomia de 9 categorias). Ver [repos/spec-kit.md](../pesquisa-mercado/repos/spec-kit.md) §8.

**Tensões:** risco de sobrecarregar o leigo com perguntas antes de começar a elicitação.

**Recomendação inicial:** ACEITAR com modificação — limitar a 3 perguntas; ativar só se lacunas críticas detectadas.

**DECISÃO: ACEITA com modificação**

**Escopo modificado:**
- Máximo 3 perguntas de clarificação (1 lote de `ask_user`).
- Ativada apenas se o Agente Visão detectar lacunas em ≥ 2 das 3 categorias críticas (escopo funcional, terminologia do domínio, restrições de negócio).
- Se nenhuma lacuna crítica detectada: sub-fase silenciosa — nenhuma pergunta ao leigo.

**Implementação:** skill ou micro-rotina do Agente Visão, executada após geração de `visao-produto.md` e antes do handoff para o Agente Elicitação.

---

### D17 — Fase `/analyze` cross-artifact pré-gate M3

**Proposta:** o Agente Validação roda checagem de consistência (Visão ↔ Elicitação ↔ SRS) antes de apresentar o artefato ao leigo no gate M3. Issues CRITICAL bloqueiam o gate; HIGH/MEDIUM aparecem com destaque; LOW é nota informativa.

**Inspiração:** `github/spec-kit` (`/speckit.analyze` com severidades CRITICAL/HIGH/MEDIUM/LOW). Ver [repos/spec-kit.md](../pesquisa-mercado/repos/spec-kit.md) §8.

**Relação com `4 - Evolucao-SDD-TDD.md`:** sobreposição conceitual com "Ambiguidade Zero" (se não é possível gerar teste = requisito mal definido). D17 trata consistência ER cross-artifact; o doc SDD-TDD trata geração de testes. Camadas complementares, não conflitantes.

**Tensões:** nenhuma — o Agente Validação já existe; D17 adiciona fase de verificação interna.

**Recomendação inicial:** ACEITAR — melhora diretamente a qualidade do gate M3 sem requerer novo agente.

**DECISÃO: ACEITA como está**

**Justificativa:** contradições entre Visão e SRS detectadas pelo leigo no gate M3 causam retrabalho de toda a elicitação; D17 detecta essas contradições antes da apresentação.

---

## Grupo C — Tradução leigo ↔ técnico

### D18 — Tradução dupla nos artefatos-gate

**Proposta:** cada artefato-gate tem duas versões — (a) normativa em IREB §3.3.3 + EARS + RFC 2119 para a equipe técnica; (b) em linguagem de dono de negócio para aprovação no gate. O leigo aprova (b); a equipe técnica recebe (a).

**Inspiração:** tensão T3 do paradigma SDD — mecanismo de mitigação para garantir que gates M1/M2/M3 sejam funcionalmente reais para o leigo. Ver [spec-driven-development.md §7](../pesquisa-mercado/spec-driven-development.md).

**Tensões:** nenhuma — é requisito direto de D1 (leigo) + D3 (gates com aprovação real).

**Recomendação inicial:** ACEITAR — sem isso, os gates podem ser formais sem ser reais.

**DECISÃO: ACEITA como está**

**Justificativa:** gate com artefato IREB não aprovável por leigo é gate cosmético. D18 é o mecanismo que torna D3 defensável em um estudo de caso com stakeholder real.

**Implementação:** skill `traducao-gate` que, dado artefato normativo, gera versão leigo para apresentação no gate.

---

### D19 — Skill `tradução-leigo` transversal

**Proposta:** skill transversal que verifica se um trecho de texto contém jargão da blacklist (D1) e gera alternativa em linguagem de negócio. Invocável por qualquer agente antes de apresentar texto ao usuário. Generaliza a skill `retraducao-leiga` já prevista no Agente Validação.

**Inspiração:** enforcement operacional de D1 — a blacklist em `CLAUDE.md` é uma regra, não um mecanismo de verificação em runtime.

**Tensões:** nenhuma.

**Recomendação inicial:** ACEITAR — formaliza e reutiliza o que já estava previsto como skill específica.

**DECISÃO: ACEITA como está**

**Justificativa:** evita que a skill de verificação de jargão seja reimplementada em cada agente que precisa apresentar texto ao leigo.

---

## Tabela de veredito

| # | Decisão | Status | Modifica | Data | Notas |
|---|---|---|---|---|---|
| D12 | Engine canônico vs. adapter por IDE | ACEITA | D11 | 2026-05-17 | — |
| D13 | `estado-projeto.yaml` como SoT explícito | ACEITA com mod. | D10 | 2026-05-17 | Yaml SoT primário; detection-based fallback quando yaml ausente |
| D14 | Question batching formalizado | ACEITA | D6 | 2026-05-17 | — |
| D15 | `constitution.md` como guardrail versionado | ACEITA | D1-D11 | 2026-05-17 | — |
| D16 | Sub-fase de clarificação Visão→Elicitação | ACEITA com mod. | Nova | 2026-05-17 | Máx. 3 perguntas; só se ≥ 2 lacunas críticas detectadas |
| D17 | Fase `/analyze` cross-artifact pré-gate M3 | ACEITA | D3, D6 | 2026-05-17 | — |
| D18 | Tradução dupla nos artefatos-gate | ACEITA | Nova | 2026-05-17 | — |
| D19 | Skill `tradução-leigo` transversal | ACEITA | D1 | 2026-05-17 | Generaliza `retraducao-leiga` do Ag. Validação |

---

## Tensões não resolvidas após a revisão

- **T3 — Party Mode vs. `ask_user` sequencial:** Party Mode (multi-agentes em paralelo, inspiração BMAD-METHOD) requer paralelismo que a primitiva `ask_user` não suporta nativamente. Não abordado nesta revisão — adiado para eventual implementação de revisão paralela no gate M2, se o prazo permitir.
- **`4 - Evolucao-SDD-TDD.md` como proposta não formalizada:** o documento propõe integração SDD+TDD como extensão futura (skill `sdd-spec-generator` + `test-case-generator`). Compatível com D12-D19, mas não foi submetido a processo de deliberação formal. Permanece como candidato a ciclo futuro de revisão.

---

## Próximos passos

1. Revisar `docs/planejamento/3 - Arquitetura da Ferramenta.md` à luz das D12-D19 aceitas (engine canônico D12; `constitution.md` D15; sub-fase clarificação D16; `/analyze` pré-gate D17).
2. Revisar `docs/planejamento/ROADMAP.md` — inserir criação de `constitution.md` (D15) e `estado-projeto.yaml` (D13) nos primeiros sprints.
3. Revisar `ba-skills` (GiangGiangTran) e `awesome-claude-code-subagents` (VoltAgent) antes de implementar skills do porte Claude Code (D12).
4. Estudar MARE (arXiv 2405.03256) para a seção "trabalho correlato" da dissertação.
