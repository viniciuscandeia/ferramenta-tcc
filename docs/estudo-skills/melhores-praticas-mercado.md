# Guia de Melhores Práticas: Agentes e Skills

Este documento consolida as diretrizes de mercado (OpenAI, Anthropic, Agent Skills) para a construção de agentes de IA robustos e skills eficientes, servindo como guia de estilo para o desenvolvimento das capacidades da ferramenta de elicitação de requisitos do TCC.

## 1. Arquitetura de Agentes

### Padrões de Raciocínio
- **ReAct (Reason + Act):** Utilize para tarefas dinâmicas e exploratórias onde o próximo passo depende da observação do passo anterior.
- **Plan-and-Execute:** Priorize para fluxos de trabalho estruturados da Engenharia de Requisitos (ex: gerar um SRS após a elicitação). É mais econômico em termos de tokens.

### Orquestração Multi-Agente
- **Princípio da Responsabilidade Única (SRP):** Evite agentes "canivete suíço". Crie agentes especialistas (ex: um Agente de Elicitação, um Agente de Análise de Conflitos, um Agente de Validação IREB).
- **Reflection & Critique:** Implemente um fluxo onde um agente gera o requisito e outro agente "crítico" o revisa contra as heurísticas de qualidade.

## 2. Design de Skills (Instruções Procedurais)

### Otimização para Descobrimento (Discoverability)
O agente decide carregar uma skill baseando-se apenas no YAML frontmatter.
- **Descrição Proativa:** Em vez de "Esta skill faz X", use "Use esta skill quando o usuário quiser realizar Y".
- **Gatilhos Explícitos:** Liste contextos claros de ativação para evitar que o agente tente resolver problemas sem as ferramentas adequadas.

### Divulgação Progressiva (Progressive Disclosure)
- **SKILL.md Enxuto:** Mantenha as instruções principais em menos de 500 linhas.
- **Pasta `references/`:** Mova documentações volumosas (ex: a norma ISO/IEC/IEEE 29148 completa) para arquivos de referência. Instrua o agente a ler esses arquivos apenas se necessário.

### Determinismo e Scripts
- **Não deixe a IA calcular:** Para tarefas de precisão (contagem de requisitos, formatação de arquivos, validação de sintaxe), utilize scripts em Python ou Bash na pasta `scripts/`.
- **Comando de Execução:** Instrua o agente a chamar o script e usar a saída (Observation) para continuar o raciocínio.

### Estilo de Instrução
- **Linguagem Imperativa:** Use "1. Pesquise por X. 2. Se X for encontrado, faça Y."
- **Explicação de Intento:** Explique o "porquê" por trás das regras cruciais para ajudar o agente a lidar com ambiguidades.

## 3. Paradigma Agente vs. Workflow

- **Workflow (Determinístico):** Utilize código tradicional se o processo for uma árvore de decisão clara e sem ambiguidades.
- **Agente (Probabilístico):** Utilize agentes de IA quando o processo exige julgamento humano, empatia na elicitação, tradução de linguagem leiga para técnica ou adaptação a cenários imprevistos.

## 4. Segurança e Guardrails

- **Limitação de Raio de Ação (Blast Radius):** Restrinja as permissões de leitura/escrita de cada skill ao mínimo necessário para sua tarefa.
- **Human-in-the-loop:** Desenhe skills que parem e peçam confirmação humana em gates críticos (ex: antes de finalizar o Marco 1).
