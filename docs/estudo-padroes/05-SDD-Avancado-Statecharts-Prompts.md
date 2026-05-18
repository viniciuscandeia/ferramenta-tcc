# Spec-Driven Development (SDD) Avançado

Este documento expande os conceitos básicos de SDD (veja `01-Spec-Driven-Development.md`), abordando ramificações avançadas e implementações modernas (2025-2026) que transcendem a simples geração de código a partir de texto.

---

## 1. Statecharts como a "Spec Executável" (UI e Lógica de Estado)

Na engenharia front-end e gestão de estado complexa, a especificação não é um documento Gherkin (Given/When/Then), mas sim um **Statechart** formal.

- **O que é:** Uma Máquina de Estados Finita hierárquica (ex: modelada via XState ou Stately) onde cada estado, transição e evento é matematicamente definido.
- **SDD "Top-Down":** Em vez da IA gerar código UI "bottom-up" (adicionando variáveis booleanas como `isLoading`, `hasError`), a IA lê o arquivo de definição do statechart (JSON ou TypeScript) como a **Spec**. 
- **O Benefício:** O código de interface gerado é inerentemente livre de "estados impossíveis". O stakeholder pode verificar a lógica da interface visualmente num simulador *antes* da geração do código.

---

## 2. "Spec-Driven" Prompt Engineering vs. "Vibe Coding"

Há uma distinção crescente na forma como humanos e agentes colaboram:

- **Vibe Coding:** Interações casuais, onde o humano pede coisas via chat de forma iterativa, o agente tenta adivinhar a intenção e faz edições na base de tentativa e erro. Acarreta alto "Integration Tax" (bugs cumulativos).
- **Spec-Coding (Spec-Driven Prompting):** O próprio processo de engenharia de prompt obedece a um pipeline rigoroso de SDD.
    1. `/constitution`: O agente carrega regras inegociáveis (ex: "sempre use TypeScript estrito").
    2. `/specify`: O agente e o humano definem o "o quê".
    3. `/plan`: O agente gera a arquitetura e dependências.
    4. `/implement`: Apenas na última etapa o agente atua.

Neste paradigma, a **spec funciona como o planejamento cognitivo do agente** (conectando-se ao padrão CoALA de arquiteturas cognitivas), servindo de ponte entre o requisito abstrato e a ação concreta do LLM.

---

## 3. Subagent-Driven Development (SDD Paralelo)

No ecossistema de agentes (como o framework `superpowers` ou AWS Kiro), a sigla SDD frequentemente se sobrepõe a **Subagent-Driven Development**.

- **O Paradigma:** Uma spec não é entregue a um único "agente-orquestrador" para ele implementar tudo.
- **Orquestração e Despacho:** A spec é traduzida em um **grafo de tarefas atômicas**. O agente orquestrador instancia múltiplos *sub-agentes efêmeros*, entregando a cada um apenas o fragmento da spec que lhe compete.
- **Vantagem de Contexto:** Previne a "degradação de contexto" (context drift). O agente encarregado do CSS não é distraído pela spec do banco de dados. Quando todos os sub-agentes reportam sucesso nos testes, o orquestrador faz o merge.

---

## Conexão com a Ferramenta de TCC

A ferramenta de elicitação de requisitos do TCC é, em si, um exercício de **Spec-Driven Prompt Engineering**.
- Ela evita o "vibe coding" com o stakeholder leigo ao impor um fluxo rígido de elicitação estruturada.
- O uso de sub-agentes (Agente de Conflitos, Agente NLP, Agente de Validação IREB) é uma implementação prática de **Subagent-Driven Development**, onde cada skill atua sobre um pedaço do processo de análise de requisitos.
