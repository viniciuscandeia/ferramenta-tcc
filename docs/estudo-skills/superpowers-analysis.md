# Análise do Framework Superpowers

## Introdução
O repositório `obra/superpowers` é um framework de skills e uma metodologia de desenvolvimento de software projetada especificamente para agentes de IA. Ele trata a documentação de processos (skills) com o mesmo rigor técnico de código de produção, focando em combater o desvio do agente (agent drift) e garantir a conformidade com metodologias como TDD e SDD.

## Pontos Fortes e Metodologia

### 1. Estrutura Padronizada e Otimização para Busca (CSO)
As skills utilizam um frontmatter YAML que define o nome e uma descrição otimizada para busca.
- **Triggering Condicional:** Descrições começam com "Use when..." (Use quando...), permitindo que o agente identifique rapidamente se a skill é relevante para a tarefa atual sem precisar ler o corpo completo do documento de imediato.
- **Vantagem:** Reduz o consumo desnecessário de tokens de contexto.

### 2. "Lei de Ferro" (Iron Law) e Resistência ao Desvio
Para evitar que o agente tome atalhos ou ignore regras sob pressão:
- **Iron Law:** Cada skill define uma regra mestre inegociável (ex: "Nenhum código de produção sem um teste falhando primeiro").
- **Tabelas de Racionalização:** Uma seção de "Agente vs. Realidade" que lista desculpas comuns que IAs usam para pular etapas (ex: "Isso é simples demais para testar") e fornece a resposta lógica para manter o agente no caminho certo.

### 3. TDD aplicado à Documentação de Processo
A criação e evolução de uma skill não é apenas escrita criativa, mas segue o ciclo de Test-Driven Development:
- **Red:** Prova-se que o agente falha ou é ineficiente sem a skill.
- **Green:** Escreve-se a instrução mínima necessária para que o agente cumpra o objetivo.
- **Refactor:** Otimiza-se a skill para fechar brechas e reduzir verbosidade.

### 4. Lógica Visual (Fluxogramas)
O uso de diagramas em Graphviz (DOT) ou Mermaid embutidos ajuda o agente a manter o estado durante processos complexos.
- **Representação Espacial:** Ter uma visão espacial do fluxo de decisão ajuda a IA a navegar por loops de repetição (como o ciclo TDD) sem se perder na "conversa".

### 5. Eficiência de Contexto e Gerenciamento de Dependências
- **Separação de Preocupações:** Instruções de alto nível ficam em `SKILL.md`, enquanto documentações pesadas de APIs ou referências externas ficam em arquivos auxiliares.
- **Explicit Requirement Markers:** Uso de marcadores como `**REQUIRED BACKGROUND**` para ligar dependências sem forçar o carregamento de todo o conhecimento de uma vez.

## Aplicação no TCC
Esta análise servirá de base para a criação das skills da ferramenta de elicitação de requisitos, garantindo que as perguntas feitas ao usuário sigam um rigor metodológico e que o agente não se desvie do protocolo de IREB §3.3.3.
