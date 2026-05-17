# Pesquisa de Mercado — Ferramentas SDD e Ferramentas Correlatas

**Data:** 2026-05-16
**Contexto:** Levantamento conduzido antes da revisão das decisões D1-D11 (`docs/planejamento/1 - Decisões Tomadas.md`) e do catálogo de skills/agentes (`docs/planejamento/3 - Arquitetura da Ferramenta.md`).

---

## Sumário executivo

**Spec-Driven Development em 2025-2026.** O paradigma SDD consolida a ideia de que especificações de requisitos bem elaboradas são prompts executáveis — o código é subproduto verificável da spec, não o inverso. O GitHub Spec Kit (~100k stars em menos de 12 meses) é a referência canônica; AWS Kiro, Google Antigravity, BMAD-METHOD (~47k stars) e Spec-Flow convergem na mesma direção. O paradigma organiza-se em três níveis de rigor: spec-first (spec completa antes do código), spec-anchored (spec guia pontos críticos), spec-as-source (spec substitui o código como artefato primário). Os princípios de qualidade que o SDD exige — não-ambiguidade, completude, consistência, verificabilidade, rastreabilidade — são exatamente os previstos por IREB §3.3.3 / IEEE 29148. Os dois paradigmas são aditivos, não excludentes.

**Nossa posição no ecossistema.** Todas as ferramentas estudadas assumem que o usuário que formula a spec tem literacia técnica — desenvolvedor, PM ou analista. Nossa proposta inverte esse eixo: o usuário é o dono do negócio (leigo), e a ferramenta substitui o analista de requisitos, produzindo o artefato de entrada que ferramentas como o Spec Kit consumiriam. Essa inversão é uma divergência arquitetural consciente do mainstream SDD, motivada pelo público-alvo, e deve ser justificada como tal na dissertação. Os gates M1/M2/M3 com aprovação explícita do leigo — rejeitados por quase todos os frameworks estudados — são inegociáveis nesse contexto.

---

## Se você só lê 3 coisas, leia estas

1. **[SINTESE.md](SINTESE.md)** — tabela comparativa dos 4 repos principais × 11 dimensões, mapa consolidado de inspirações por decisão afetada, e 8 decisões candidatas D12-D19 com justificativa.
2. **[spec-driven-development.md](spec-driven-development.md)** — definição operacional do paradigma SDD, sua relação com ER tradicional (IREB/IEEE 29148) e as 4 tensões com nossa arquitetura.
3. **[repos/bmad-method.md](repos/bmad-method.md)** — maior convergência arquitetural com nossa proposta (~47k stars); Party Mode com subagentes reais em paralelo + 50 métodos de elicitação em catálogo CSV são os dois achados de maior impacto.

---

## Índice

### Paradigma

| Arquivo | Conteúdo |
|---|---|
| [spec-driven-development.md](spec-driven-development.md) | Definição, origem, 3 níveis de rigor, fluxo canônico do Spec Kit, SDD vs. ER tradicional, ecossistema de ferramentas, tensões com nossa arquitetura, princípios SDD adotáveis mantendo D1+D4 |

### Síntese

| Arquivo | Conteúdo |
|---|---|
| [SINTESE.md](SINTESE.md) | Tabela comparativa (11 dimensões × 5 ferramentas), mapa de inspirações consolidadas por decisão afetada, decisões candidatas D12-D19, tensões não resolvidas, repos a revisitar, próximos passos |

### Fichas de repositórios principais

| Arquivo | Repo | Stars | Relevância |
|---|---|---|---|
| [repos/spec-kit.md](repos/spec-kit.md) | github/spec-kit | ~100.633 | Referência canônica do SDD; `constitution.md` + `/clarify` com taxonomia 9 categorias + `/analyze` cross-artifact são os achados de maior impacto para nossas D15, D16, D17 |
| [repos/bmad-method.md](repos/bmad-method.md) | bmad-code-org/BMAD-METHOD | ~47.310 | Maior convergência arquitetural com nossa proposta; Party Mode (subagentes reais em paralelo + discordância autêntica) e catálogo de 50 métodos de elicitação em `methods.csv` |
| [repos/spec-flow.md](repos/spec-flow.md) | marcusgoll/Spec-Flow | ~85 | Engine canônico vs. adapter por IDE; `state.yaml` como SoT; question batching; token budget por fase — achados de maior impacto para D12, D13, D14 |
| [repos/specif-ai.md](repos/specif-ai.md) | presidio-oss/specif-ai | N/D | Separação context vs. prompt; loop de validação com retry estruturado; 7 providers LLM — achados para D7, D10, D11 |

### Fichas de repositórios correlatos

| Arquivo | Conteúdo |
|---|---|
| [repos/outros.md](repos/outros.md) | OpenSpec (brownfield-first), ba-skills (skills BA em formato Claude Code — alta relevância), awesome-claude-code-subagents, spec-compare (benchmark de 6 ferramentas SDD), MARE (arXiv — único paper peer-reviewed com multi-agentes para ER), Problem-Based-SRS (revisita à luz do SDD) |

---

## Como navegar

- **Para tomar decisões de arquitetura:** ir direto a [SINTESE.md §3](SINTESE.md) (decisões D12-D19) e [SINTESE.md §4](SINTESE.md) (tensões não resolvidas).
- **Para contextualizar na dissertação:** ler [spec-driven-development.md §5](spec-driven-development.md) (SDD vs. ER tradicional) + [repos/outros.md §5](repos/outros.md) (MARE — referência acadêmica) + [SINTESE.md §1](SINTESE.md) (tabela comparativa).
- **Antes de implementar o porte Claude Code (D11):** ler [repos/spec-flow.md §2](repos/spec-flow.md) (engine vs. adapter) + [repos/outros.md §2](repos/outros.md) (ba-skills — revisar antes de criar skills) + [repos/outros.md §3](repos/outros.md) (awesome-claude-code-subagents).
- **Para projetar os sub-agentes do gate M2:** ler [repos/bmad-method.md §3](repos/bmad-method.md) (Party Mode + discordância autêntica) + [repos/spec-kit.md §3](repos/spec-kit.md) (`/speckit.clarify` com 9 categorias).
