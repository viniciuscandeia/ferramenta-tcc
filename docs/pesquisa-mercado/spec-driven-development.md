# Spec-Driven Development (SDD)

**Status:** paradigma emergente consolidado em 2025-2026
**Referências canônicas:** GitHub Spec Kit, Thoughtworks, InfoQ, Augment Code

---

## 1. Definição e origem

Spec-Driven Development (SDD) é definido pela **Thoughtworks** como "um paradigma de desenvolvimento que usa especificações de requisitos de software bem elaboradas como prompts, auxiliado por agentes de IA, para gerar código executável". O paradigma "inverte o roteiro" tradicional: em vez de tratar specs como andaime descartável, as specs tornam-se **executáveis e autoritativas**, com o código sendo subproduto verificável.

A referência canônica é o **GitHub Spec Kit** (https://github.com/github/spec-kit), criado e mantido pelo GitHub em 2025. Por convergência acelerada no ecossistema de agentes de IA em 2025-2026, múltiplos atores publicaram variantes próprias:

| Ator | Produto |
|---|---|
| GitHub | Spec Kit (open-source, referência canônica) |
| AWS | Kiro (IDE proprietária, modelos Claude) |
| Google | Antigravity |
| Anthropic | Skills SDD em Claude Code (não verificado em fonte primária) |
| OpenAI | Skills em Codex CLI |
| Thoughtworks | Publicações e metodologia |

Influência adicional atribuída ao trabalho de John Lam (reconhecida na documentação do Spec Kit).

---

## 2. Definição operacional

Uma **spec** no paradigma SDD não é um documento Word de requisitos: é um artefato estruturado que combina linguagem natural com formatos semi-estruturados, projetado para ser consumido por um agente de IA como prompt de geração de código.

**Cinco atributos de qualidade (Thoughtworks):**
1. Linguagem orientada a domínio, alinhada com intenção de negócio.
2. Estrutura clara (frequentemente Given/When/Then).
3. Balanço entre completude e concisão (token-efficient).
4. Clareza e determinismo para reduzir alucinação.
5. Combinação de linguagem natural com formatos semi-estruturados (listas, tabelas, esquemas).

---

## 3. Três níveis de rigor (Augment Code)

| Nível | Descrição | Quando usar |
|---|---|---|
| **spec-first** | Spec completa antes de qualquer código | Novos projetos; mudanças significativas |
| **spec-anchored** | Spec parcial guia pontos críticos; resto é ad-hoc | Features médias com contexto estabelecido |
| **spec-as-source** | Spec é a fonte de verdade; código é regenerado dela | Projetos com alta taxa de mudança de requisitos |

"Spec-as-source" é o nível mais radical: a spec substitui o código como artefato primário, e regeneração é mais barata que edição manual.

---

## 4. Fluxo canônico — GitHub Spec Kit (7 slash-commands)

```
/speckit.constitution   → princípios não negociáveis do projeto
/speckit.specify        → requisitos e user stories
/speckit.clarify        → endereça lacunas e ambiguidades da spec
/speckit.plan           → plano técnico de implementação
/speckit.tasks          → decomposição em tarefas com dependências
/speckit.analyze        → validação cross-artifact (consistência spec↔plan↔tasks)
/speckit.implement      → execução (geração de código)
```

**Artefatos produzidos:** documento de constituição (princípios), spec funcional, plano de implementação, contratos/APIs, breakdown de tarefas com dependências, modelos de dados, documentação de arquitetura.

**Fluxo alternativo — OpenSpec (3 etapas):**

```
/opsx:propose   → proposta de mudança
/opsx:apply     → aplicação à base de código
/opsx:archive   → arquivamento e rastreabilidade
```

OpenSpec é orientado a *brownfield* (projetos existentes), mais enxuto e menos prescritivo.

---

## 5. SDD vs. Engenharia de Requisitos tradicional (IREB / IEEE 29148)

### Convergências

- Ambos buscam especificação **inequívoca, rastreável e verificável**.
- SDD reutiliza estruturas da ER tradicional: user stories, cenários Given/When/Then, requisitos funcionais com "MUST/SHALL" (RFC 2119).
- A demanda por linguagem domínio-orientada e completude parallela diretamente as características de boa SRS na IEEE/ISO/IEC 29148:2018.
- Os princípios de qualidade IREB §3.3.3 (não-ambiguidade, completude, consistência, verificabilidade, rastreabilidade) são **exatamente** as propriedades que uma spec SDD precisa para gerar código confiável.

### Divergências

| Dimensão | ER tradicional (IREB / IEEE 29148) | SDD |
|---|---|---|
| Consumidor primário da SRS | Humanos (stakeholders, desenvolvedores) | Agente de IA |
| Status do documento | Artefato contratual, normativo | Artefato executável, regenerável |
| Ciclo de vida | Waterfall-leve (ou iterativo formal) | Iterativo rápido (spec evolui com o código) |
| Linguagem | Natural + formal (EARS, RFC 2119) | Natural + semi-estruturada (Given/When/Then, listas) |
| Audiência | Equipe técnica e cliente | Principalmente o agente de IA |
| Rastreabilidade | Formal (matrizes, IDs hierárquicos) | Implícita (via estrutura da spec) |

### Complementaridade

SDD pode ser interpretado como "**ER tradicional executável**": quando a spec adere a padrões formais (IREB §3.3.3, IEEE 29148, EARS, RFC 2119), ela tem as propriedades necessárias para funcionar tanto como SRS contratual humano-legível quanto como prompt de geração de código. Os dois paradigmas são **aditivos, não excludentes**.

**SDD vs. BDD/TDD:** SDD compartilha o formato Given/When/Then com BDD; a diferença é o destino — BDD automatiza testes de aceitação, SDD automatiza implementação. TDD escreve testes antes do código; SDD escreve a spec antes do código (e o teste emerge dela).

---

## 6. Ferramentas e ecossistema (2025-2026)

| Ferramenta | Tipo | Observação |
|---|---|---|
| **GitHub Spec Kit** | Open-source, multi-agente | Referência canônica; suporta 30+ agentes (Claude Code, Copilot, Cursor, Gemini CLI, Codex, Goose, opencode...) |
| **AWS Kiro** | IDE proprietária | Modelos Claude; fluxo spec → tasks → implement integrado na IDE |
| **Tessl** | Language-agnostic | Instalação via `.tessl/`; baseada em MCP; não verificado em detalhes |
| **OpenSpec (Fission-AI)** | Open-source | Brownfield-first; enxuto |
| **BMAD-METHOD** | Open-source | Multi-persona; muito popular (~37k stars) |
| **Spec-Flow** | Open-source toolkit | Multi-IDE; Claude Code primário |
| **Google Antigravity** | Não detalhado | Mencionado em fontes secundárias; não verificado |

---

## 7. Tensões com nossa arquitetura

### T1 — SDD assume autor técnico da spec

Spec Kit, Kiro e BMAD assumem que quem escreve/guia a spec é um desenvolvedor ou analista técnico. Adotar o fluxo `/specify` literalmente colide com nossa primitiva `ask_user` choice/yesno ([D1](../planejamento/1%20-%20Decisões%20Tomadas.md)) — a spec tem que ser **construída para o leigo**, não **pelo leigo**.

**Resolução:** manter a primitiva `ask_user` como interface; a spec SRS é gerada internamente pela ferramenta a partir das respostas estruturadas. O leigo nunca vê nem escreve a spec diretamente.

### T2 — Phase-gate rígido vs. iteração fluida

OpenSpec e alguns aspectos do Spec Kit favorecem iteração fluida e regeneração contínua. Nossa proposta ([D3](../planejamento/1%20-%20Decisões%20Tomadas.md)) é deliberadamente waterfall-leve, com gates M1/M2/M3 de aprovação humana explícita. A rigidez é **coerente com D1**: o leigo precisa de pontos de validação claros, não de um fluxo contínuo que ele não consegue acompanhar.

**Resolução:** manter gates. Justificar na dissertação como "divergência consciente do mainstream SDD, motivada pelo público-alvo".

### T3 — "Spec-as-source" vs. SRS como contrato humano-legível

No nível spec-as-source, a spec é otimizada para LLM, não para leitura humana. Nossa proposta ([D4](../planejamento/1%20-%20Decisões%20Tomadas.md)) requer que a SRS final seja um documento normativo legível (IREB §3.3.3 + RFC 2119), auditável por banca e orientador.

**Resolução:** operar no nível **spec-first** ou **spec-anchored** do SDD — nunca spec-as-source. Manter a SRS como artefato terminal humano-legível; artefatos intermediários podem ser otimizados para o agente.

### T4 — `/implement` automático fora de escopo

SDD tipicamente termina em geração de código. Nossa ferramenta termina em SRS aprovada pelo stakeholder — o código é responsabilidade da equipe técnica que receberá o documento.

**Resolução:** cortar a fase `/implement` do paradigma. Declarar explicitamente na dissertação que a ferramenta entrega o artefato de entrada do Spec-Flow, não o seu output final.

---

## 8. Princípios SDD adotáveis mantendo D1 e D4

| Princípio | Forma de adoção | Impacto | Esforço |
|---|---|---|---|
| **Constituição explícita** (`/speckit.constitution`) | Gerar `constitution.md` no início do M1 com D1-D11 versionadas como guardrails permanentes lidos por todos os agentes | Alto | Baixo |
| **Fase `/clarify` dedicada** | Fase entre Visão e Elicitação onde o agente lista underspecified areas e usa `ask_user choice` para resolver — conserva D1 | Alto | Médio |
| **Fase `/analyze` cross-artifact** | Agente Validação roda checagem de consistência Visão↔Elicitação↔SRS antes de apresentar M3 ao leigo | Alto | Médio |
| **Spec template estruturado** | O spec-template de 13 seções do Spec-Flow serve de referência para o template IREB §3.3.3; adotar seções complementares (HEART → mapa de valor, Traceability matrix) | Médio | Baixo |

---

## Referências

- Thoughtworks: https://thoughtworks.medium.com/spec-driven-development-d85995a81387
- GitHub Spec Kit: https://github.com/github/spec-kit
- InfoQ: https://www.infoq.com/articles/spec-driven-development/
- Augment Code (3 níveis): https://www.augmentcode.com/guides/what-is-spec-driven-development
- Microsoft Developer Blog: https://developer.microsoft.com/blog/spec-driven-development-spec-kit
- Martin Fowler / Thoughtworks (comparação ferramentas): https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html
- MarkTechPost (9 ferramentas SDD em 2026): https://www.marktechpost.com/2026/05/08/9-best-ai-tools-for-spec-driven-development-in-2026-kiro-bmad-gsd-and-more-compare/
- OpenSpec (Fission-AI): https://github.com/Fission-AI/OpenSpec
