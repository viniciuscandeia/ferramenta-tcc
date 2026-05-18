# Análise do Ecossistema Comunitário de Skills (Claude & Gemini)

## Introdução
O ecossistema de agentes de IA está passando por uma transição rápida de "prompts de sistema longos" para "pacotes de capacidades instaláveis" conhecidos como **Skills**. Esta mudança permite maior modularidade, facilidade de compartilhamento e economia de contexto.

## Panorama do Ecossistema

### 1. Ecossistema Claude Code (Anthropic & Comunidade)
O Claude Code possui a comunidade mais ativa em termos de volume e diversidade de skills.

- **Repositórios Oficiais (`anthropics/skills`):**
    - Além do repositório de plugins, a Anthropic mantém uma coleção focada em utilitários de produtividade.
    - **Skill-Creator:** Introduz a ideia de que o próprio agente deve ajudar a documentar e refinar novas capacidades de forma iterativa.
- **Marketplaces da Comunidade:**
    - Repositórios como `jeremylongshore/claude-code-plugins-plus-skills` demonstram uma escala massiva (mais de 2800 skills), cobrindo desde linguagens obscuras até fluxos complexos de engenharia.
- **Abordagem de Personas e Instintos:**
    - **Personas (`alirezarezvani`):** Uso de skills para definir o "mindset" do agente (ex: atuar como um CTO ou um Analista de Segurança).
    - **Instintos (`affaan-m`):** Surgimento do conceito de **Instincts** — comportamentos globais de "baixo nível" (como "pesquise antes de responder") que operam em uma camada abaixo das skills procedurais.

### 2. Ecossistema Gemini CLI (Google & Comunidade)
O ecossistema Gemini está focado em integração profunda com infraestrutura e APIs em tempo real.

- **Foco em API e MCP:**
    - Repositórios oficiais focam em ensinar o agente a usar as capacidades multimodais e de streaming do Gemini (Live API, Interaction API).
    - O uso do **Model Context Protocol (MCP)** é central para conectar o Gemini a fontes de dados externas (como o Google Cloud Knowledge Catalog).
- **Extensões de Produtividade:**
    - Surgimento de ferramentas como o `gemini-cli-skill-creator` que buscam padronizar a criação de skills via linha de comando, tornando o processo de extensão do agente parte do fluxo de trabalho do desenvolvedor.
- **Interoperabilidade:**
    - Projetos como o `gemini_cli_skill` para Claude mostram uma tendência de usar agentes diferentes para tarefas onde cada um brilha (ex: Claude para codificação, Gemini para pesquisa rápida e análise de logs).

## Principais Aprendizados para o TCC

### Modularização vs. Monolito
A tendência clara é quebrar fluxos complexos de Engenharia de Requisitos (ER) em skills atômicas. Em vez de um "Agente de ER" monolítico, devemos ter skills separadas para "Entrevista Estruturada", "Escrita de User Stories" e "Validação IREB".

### Separação de Camadas
- **Camada de Instinto:** Regras globais de "Não use jargão técnico com o usuário" (Diretiva D1).
- **Camada de Skill:** Procedimentos específicos de cada técnica de elicitação.
- **Camada de Ferramenta:** Scripts e comandos MCP para salvar e ler os requisitos no disco.

### Evolução Assistida
A inclusão de uma skill de meta-desenvolvimento (como a `skill-creator`) pode ser um diferencial para permitir que o sistema se adapte a novos domínios de software de forma semi-autônoma.
