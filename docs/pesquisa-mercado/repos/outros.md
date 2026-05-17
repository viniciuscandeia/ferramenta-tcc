# Outros repos correlatos

Fichas curtas de repos complementares — relevância média a alta, não pesquisados com a profundidade dos 4 repos principais.

---

## 1. OpenSpec (Fission-AI)

**URL:** https://github.com/Fission-AI/OpenSpec
**Relevância:** Média

SDD lightweight orientado a projetos existentes (*brownfield-first*). Fluxo enxuto de 3 etapas:

```
/opsx:propose   → proposta de mudança (spec da mudança)
/opsx:apply     → aplicação à base de código existente
/opsx:archive   → arquivamento e rastreabilidade
```

Mantém uma pasta por mudança com `proposal/`, `specs/`, `design/`, `tasks/`. Menos prescritivo que Spec Kit; bom para iterações incrementais em vez de projetos novos.

**Diferencial:** o foco em brownfield é raro; a maioria das ferramentas SDD é greenfield. Para nós, é irrelevante porque elicitação ocorre antes de existir código.

**Inspiração para nossa ferramenta:** o fluxo enxuto propose/apply/archive poderia inspirar o padrão de mudanças pós-M3, quando o stakeholder pede revisão de um requisito já aprovado — um mini-fluxo de change control dentro do Agente Gerência ([D10](../../planejamento/1%20-%20Decisões%20Tomadas.md)).

---

## 2. ba-skills (GiangGiangTran)

**URL:** https://github.com/GiangGiangTran/ba-skills
**Relevância:** Alta

Skills profissionais de Business Analyst empacotadas no formato Claude Code (`~/.claude/skills/<nome>/SKILL.md`). Cobertura de:
- Elicitação de requisitos estruturada
- Stakeholder mapping e análise de interesse
- Document review e validação de qualidade
- Técnicas de priorização e modelagem de processos

**Diferencial:** formato quase idêntico ao nosso MVP para Claude Code (porte D11). Pode ser revisado antes de criar as skills de elicitação no porte CC — verificar overlap e possível reaproveitamento de prompts.

**Inspiração para nossa ferramenta (alta):** antes de escrever as ~30 skills para o porte Claude Code, verificar se há técnicas de elicitação em `ba-skills` que cobrem gaps das nossas. Pode economizar semanas de desenvolvimento.

---

## 3. awesome-claude-code-subagents (VoltAgent)

**URL:** https://github.com/VoltAgent/awesome-claude-code-subagents
**Relevância:** Média

Coleção curada de subagentes Claude Code organizados por categoria. Inclui na categoria `08-business-product`:
- `business-analyst.md` — elicitação estruturada, stakeholder mapping, document review
- Outros subagentes de produto e processos de negócio

**Diferencial:** catalogação por categoria facilita descoberta de padrões de prompt para subagentes BA.

**Inspiração para nossa ferramenta:** revisar `business-analyst.md` antes de implementar o sub-agente Implícitos no porte Claude Code. A descrição e o padrão de invocação podem servir de referência para o frontmatter `name` + `description` que habilita auto-detecção.

---

## 4. spec-compare (cameronsjo)

**URL:** https://github.com/cameronsjo/spec-compare
**Relevância:** Média

Repositório de pesquisa que compara 6 ferramentas SDD lado a lado: Spec-Kit, Spec Kitty, BMad, OpenSpec, Kiro, Tessl. Usa git worktree e frameworks de decisão para análise comparativa.

**Diferencial:** material comparativo pronto — benchmark independente que não é de um dos fabricantes. Útil como referência secundária para contextualizar a análise do TCC.

**Inspiração para nossa ferramenta:** sem impacto direto na implementação; útil para a seção "trabalho correlato" e "análise comparativa" da dissertação.

---

## 5. MARE (Multi-Agent Requirements Engineering)

**URL:** arXiv — https://arxiv.org/abs/2405.03256
**Relevância:** Alta (para a dissertação; sem repo público confirmado)

Paper acadêmico descrevendo uma arquitetura de 5 agentes para Engenharia de Requisitos:

| Agente | Papel |
|---|---|
| Stakeholders | Simula perspectivas de diferentes partes interessadas |
| Collector | Elicita e organiza requisitos |
| Modeler | Formaliza em modelos estruturados |
| Checker | Valida qualidade, consistência e completude |
| Documenter | Gera o documento final de requisitos |

9 ações definidas. Supera baselines em 15,4% segundo os autores. Metodologia peer-reviewed.

**Diferencial:** única referência verificada com base acadêmica *peer-reviewed* que usa múltiplos agentes especificamente para ER (similar ao nosso). O MARE é para equipes técnicas, não stakeholder leigo, mas a decomposição por papel é diretamente comparável.

**Inspiração para nossa ferramenta (alta para dissertação):** comparar nossa decomposição 6 agentes-etapa + 5 sub-agentes transversais com a decomposição MARE (5 agentes lineares). Justificar na dissertação por que M1/M2/M3 com gates humanos e sub-agentes apátridas é mais adequado para o leigo do que o pipeline linear do MARE.

---

## 6. Problem-Based-SRS (RafaelGorski) — Revisita

**URL:** https://github.com/RafaelGorski/Problem-Based-SRS
**Relevância:** Alta (já mapeado nas decisões D1-D11)

Já documentado em `docs/planejamento/1 - Decisões Tomadas.md` (seção "Análise comparativa com trabalho correlato"). Esta revisita acrescenta a perspectiva do paradigma SDD:

**O que muda na leitura à luz do SDD:** o Problem-Based-SRS de Gorski é, na terminologia do SDD, uma ferramenta **spec-anchored** — a spec (o SRS) ancora o código que o agente gera. O algoritmo Zigzag (ZAG: CP→CN→FR; ZIG: FR→CN→CP) é uma forma de análise cross-artifact automatizada, equivalente ao `/speckit.analyze` do Spec Kit. A sintaxe de slots estruturados (`[Subject] [must/expects/hopes] [Object] [Penalty]`) é compatível com o princípio SDD de "estrutura semi-estruturada para reduzir alucinação".

**Diferença que persiste:** mesmo à luz do SDD, o Problem-Based-SRS pressupõe usuário técnico; nossa proposta (D1) pressupõe leigo. As decisões D1, D3, D6 e D7 são reforçadas, não contestadas, pela comparação.

---

## Mapa de relevância para priorização de leitura

| Repo | Relevância | Quando revisar |
|---|---|---|
| ba-skills (GiangGiangTran) | Alta | Antes de implementar skills do porte Claude Code (Semana 5+) |
| MARE (arXiv) | Alta (dissertação) | Na redação da seção "trabalho correlato" |
| Problem-Based-SRS (Gorski) | Alta (já mapeado) | Comparação já em decisões; revisar na dissertação |
| OpenSpec (Fission-AI) | Média | Ao projetar fluxo de change control no Agente Gerência |
| awesome-cc-subagents (VoltAgent) | Média | Antes de criar subagentes no porte Claude Code |
| spec-compare (cameronsjo) | Média | Na dissertação, seção comparativa |
