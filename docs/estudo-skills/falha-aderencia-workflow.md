# Estudo de Caso: Falha de Aderência ao Workflow e "Instruction Neglect"

**Data:** 18 de Maio de 2026  
**Status:** Concluído  
**Tópico:** Arquitetura de Agentes / Confiabilidade de Workflows

---

## 1. O Incidente: O Que Aconteceu?

Durante o uso da ferramenta para documentar um "aplicativo de treinos", a IA ignorou completamente o fluxo de orquestração definido em `core/orchestrator.md` e os guardrails da `core/constitution.md`. 

### Sintomas observados:
- **Salto de Etapas (Gate Skipping):** A IA deveria iniciar pelo Marco 1 (Visão), coletando informações via `ask_user`. Em vez disso, ela gerou artefatos de todas as fases (M1 a M4) de uma só vez.
- **Violação de Nomenclatura:** Foram criados arquivos como `srs.md`, `fluxos.md` e `necessidades.md`. A tabela canônica de artefatos proíbe explicitamente esses nomes, exigindo nomes como `visao-produto-leigo.md` e `03.1-funcionais.md`.
- **Inexistência de Interação:** O fluxo iterativo foi substituído por uma geração "one-shot" de baixa qualidade, produzindo requisitos genéricos que não cumprem o rigor técnico esperado da ferramenta (IREB/EARS).
- **Perda da Persona:** A persona de "Orquestrador Leigo" foi substituída pela persona padrão de "Assistente de Programação", que foca em resolver o problema técnico o mais rápido possível em vez de documentar os requisitos.

## 2. A Causa Raiz: Por Que Falhou?

O problema identificado é conhecido na literatura de IA como **Instruction Neglect** (negligência de instrução) ou **Context Dilution**.

### Fatores principais:
1. **Natureza Probabilística:** LLMs são motores estatísticos de previsão de texto. Quando um usuário fornece um prompt com alto "potencial de resolução técnica" (ex: "app de treinos"), o modelo tende a seguir o caminho estatisticamente mais comum em seu treinamento: agir como um assistente de código que gera arquivos markdown rápidos.
2. **Fragilidade da Máquina de Estado em Texto:** Tentar forçar um fluxo complexo (Se A, então faça B; verifique Gate X) usando apenas prompts de texto é inerentemente instável. O modelo pode "alucinar" que já cumpriu os pré-requisitos ou simplesmente ignorar as restrições negativas ("NUNCA faça X") em favor de um resultado útil aparente.
3. **Sobrecarga de Contexto e Efeito "Lost in the Middle":** Em sessões longas, as instruções do sistema (no início) e a query do usuário (no fim) recebem mais atenção. As regras intermediárias de fluxo e os dados de estado migram para o "meio" da janela de contexto, onde a atenção do modelo é diluída, levando ao esquecimento de restrições críticas (ex: "sempre use ask_user").
4. **Alucinação de Aprovação:** O agente pode falsamente acreditar que o usuário já aprovou uma etapa se a confirmação estiver enterrada no histórico ou se ele "prever" que a aprovação é o próximo passo lógico, ignorando a necessidade de uma ferramenta física de interrupção.

## 3. Práticas de Mercado: Como a Indústria Resolve?

A tendência atual para agentes de produção é mover o controle de fluxo para fora do LLM.

### Análise de Repositórios e Frameworks Referência:

1.  **[Microsoft Conductor](https://github.com/microsoft/conductor):** Utiliza uma orquestração baseada em **YAML e Jinja2**. A lição aqui é o determinismo total: o LLM nunca decide qual é o próximo passo; ele apenas executa a tarefa atual. O fluxo é "hardcoded" em um arquivo de configuração que o motor de execução segue cegamente.
2.  **[LangGraph (LangChain)](https://github.com/langchain-ai/langgraph):** Implementa o conceito de **Grafos de Estado**. O sistema usa "arestas condicionais" (conditional edges) onde uma função de código (não o LLM) avalia o estado e decide o próximo nó. Isso impede que o agente pule etapas, pois o grafo simplesmente não possui uma conexão direta entre o início e o fim sem passar pelos nós de validação.
3.  **[CrewAI](https://github.com/joaomdmoura/crewai):** Introduziu os **Flows**, que usam decoradores Python (`@start`, `@listen`, `@router`) para criar fluxos orientados a eventos. O uso de **Pydantic** para forçar saídas estruturadas garante que os dados passados entre agentes sejam validados por tipo, evitando que falhas de formatação quebrem o workflow.
4.  **[Statewright](https://github.com/statewright/statewright):** Um motor em Rust que foca em **Máquinas de Estado Formais (FSM)** para agentes. Ele restringe fisicamente quais ferramentas estão disponíveis para a IA com base no estado atual. Se o estado é "Aguardando Aprovação", a ferramenta de "Escrita de Arquivo" é desabilitada no nível do sistema.

### Soluções comuns sintetizadas:
- **Máquinas de Estado Determinísticas:** O controle de qual "nó" será executado a seguir é feito por código, não pela IA.
- **Saídas Estruturadas (Pydantic/JSON Schema):** Validação rígida antes de qualquer ação.
- **Ferramentas de "Zero Trust" e Interceptores:** O ambiente bloqueia chamadas a ferramentas se o estado interno não permitir.
- **Prompts Atômicos:** Entrega-se apenas as instruções da etapa atual (Marco), eliminando o conhecimento sobre fases futuras.

## 4. Padrões Arquiteturais para Loops de Elicitação

Um dos maiores desafios técnicos na Fase 2 (M2) é forçar a IA a manter um **loop iterativo de perguntas** (entrevista) sem pular etapas e tentar gerar os requisitos finais (como o `srs.md`) de forma prematura. Para evitar que a IA "fuja" da entrevista, os seguintes padrões devem ser aplicados:

### A. Ocultação do Objetivo Final (Prompts Atômicos Estritos)
O agente de elicitação não deve ter no seu contexto que o objetivo da ferramenta é "gerar um Documento de Requisitos".
*   **Anti-padrão:** "Entreviste o usuário para gerar o SRS." -> A IA ignora a entrevista e gera o SRS para finalizar a tarefa rapidamente.
*   **Padrão Seguro:** "Você é um investigador. Sua única função é mapear as regras de negócio usando a ferramenta `ask_user`. Seu trabalho termina quando o usuário não tiver mais nada a acrescentar."

### B. Padrão "Agenda" (State-Driven Pacing)
Em vez de um prompt genérico ("faça perguntas"), o loop deve ser guiado por uma estrutura de dados de estado (ex: uma lista em YAML de tópicos a investigar no `estado-projeto.yaml`).
*   A IA é instruída a focar em **apenas um tópico pendente por vez**.
*   A ferramenta só avança para o próximo tópico quando o usuário responde satisfatoriamente as perguntas do tópico atual, validado por um sistema de *checklist* em background ou confirmação de gate.

### C. Restrição de "Output Único" (Tool-Forced Interaction)
Durante a fase de elicitação, a IA deve ser proibida de responder ao usuário via texto livre (prosa no chat).
*   A única forma permitida de comunicação com o usuário deve ser através da invocação estruturada da ferramenta `ask_user`.
*   Se a IA tentar "narrar" requisitos no chat (ex: "Entendido, o requisito 1 será..."), o sistema deve bloquear o output e retornar um erro: "Erro: Utilize a ferramenta ask_user para interagir. Não liste requisitos agora."

### D. Diretivas de Ponto de Parada (Hard STOPs e XML)
Uso de *Chain of Thought* (Cadeia de Pensamento) forçado para que a IA valide a regra de parada antes de cada ação.
*   Injetar no prompt do agente tags XML exigindo reflexão:
    ```xml
    <regras_de_interacao>
      1. NUNCA assuma um requisito; você não é o dono do produto.
      2. Faça uma pergunta por vez.
      3. Após invocar o ask_user, VOCÊ DEVE PARAR IMEDIATAMENTE e aguardar.
    </regras_de_interacao>

    <thought_process_obrigatorio>
      Antes de agir, analise em <thought>: 
      "Eu já usei a ferramenta ask_user neste turno? Se sim, devo parar."
    </thought_process_obrigatorio>
    ```

## 5. Estudo de Caso — Zoox Vibe Engineering Framework (VEF)

O **Zoox VEF** é um exemplo de framework de engenharia de software orquestrado por IA que utiliza padrões rigorosos para evitar que o agente tome decisões arbitrárias ou ignore o workflow planejado.

### Padrões Identificados:
1.  **Habilitação de Skills Atômicas (Atomic Skills):** Diferente de um agente generalista, o VEF divide o trabalho em habilidades estritamente separadas (ex: `po-interview`, `dev-coding`). Ao entrar em uma skill, as instruções das outras são removidas do contexto, impedindo fisicamente que um agente de "entrevista" comece a "codar".
2.  **Diretiva `<HARD-GATE>`:** O uso de tags XML explícitas no topo do prompt (ex: `<HARD-GATE>DO NOT PROCEED TO CODING WITHOUT USER APPROVAL</HARD-GATE>`) cria uma barreira semântica de alta prioridade que o modelo reconhece como uma restrição inviolável do sistema, não apenas uma sugestão de estilo.
3.  **Travas Físicas de "Frescor" (Freshness Checks):** O framework valida o estado externo antes de permitir ações. Por exemplo, um agente de "revisão de código" pode ser instruído a verificar o hash do último commit (`git rev-parse HEAD`) e compará-lo com o registrado em seu relatório. Se houver discrepância, o agente é forçado a parar, evitando alucinações baseadas em estados obsoletos.
4.  **Checkpoints Estruturados via Ferramenta:** Em vez de prosa, o VEF utiliza ferramentas de interação (análogas ao `ask_user`) que forçam a escolha entre opções numeradas para transições de estado. Isso transforma o diálogo em uma entrada de dados controlada, reduzindo drasticamente a deriva do workflow.

## 6. Recomendações para a Ferramenta TCC

Para garantir que a ferramenta seja resiliente e siga o fluxo de ER, propomos as seguintes melhorias:

1. **Desacoplamento por Skill (Atomicidade):** Transformar cada Marco em uma Skill isolada no Gemini CLI. O Orquestrador central deve apenas invocar a Skill correspondente, ocultando as fases futuras para evitar que a IA tente "atalhar" o processo.
2. **Validação de "Pre-flight" e Interceptores:** Implementar scripts de verificação que impedem o agente de criar arquivos com nomes fora da tabela canônica ou sem aprovação de gate registrada em `estado-projeto.yaml`.
3. **Ancoragem de Restrições (XML):** Re-injetar restrições críticas (ex: "Use apenas português", "Sempre use ask_user") ao final de cada iteração para combater o efeito *Lost in the Middle*.
4. **Estado como Trava Física:** O `estado-projeto.yaml` deve agir como um semáforo físico. As ferramentas de escrita da IA devem ser programaticamente incapazes de atuar se o `marco_corrente` não for compatível com a ação.
5. **Adoção de Hard-Gates:** Integrar no `core/constitution.md` e nos prompts de agentes tags `<HARD-GATE>` para interrupções críticas que exigem `ask_user`.

---

## 7. Incidente de Acesso ao Diretório Core (Workspace Sandboxing)

Em Maio de 2026, foi identificado um ponto de falha crítico na inicialização da ferramenta: o agente "esqueceu" sua identidade e as regras da `constitution.md`.

### Diagnóstico Técnico:
A falha ocorreu devido ao **Workspace Sandboxing**. As IAs modernas operam em "caixas de areia" que restringem o uso de ferramentas (como `read_file`) estritamente ao diretório do projeto aberto pelo usuário.
- **O Bloqueio:** Quando a ferramenta solicitava que o agente lesse `~/.gemini/extensions/ferramenta-tcc/core/constitution.md`, o sistema de segurança bloqueava o acesso, pois o arquivo reside em uma pasta de sistema fora do projeto Desktop/TCC.
- **O Paradox do Bootstrap:** O agente precisa das regras para saber como agir com segurança, mas precisa agir (usar uma ferramenta de leitura) para descobrir as regras. Se a ferramenta falha, o agente reverte para seu comportamento padrão (assistente técnico), violando a identidade de Orquestrador de Requisitos.

## 8. Padrões de Mercado para Injeção de Instruções

A pesquisa na literatura e em frameworks de agentes (LangChain, Guardrails AI, NeMo) aponta para as seguintes estratégias para evitar o desvio de objetivo (Goal Drift):

### A. System Prompt vs. Contexto Externo
- **Core Identity (System Prompt):** Deve ser injetado **inline** e de forma estática. Regras inegociáveis de comportamento, tom de voz e restrições negativas (Blacklist de Jargão) devem ter disponibilidade de latência zero. O modelo dá maior prioridade de atenção ao que é marcado como `system_role`.
- **Knowledge Base (RAG/External):** Reservado para conhecimentos de domínio (ex: catálogos de RNF ou exemplos de SRS). O agente consulta estes arquivos sob demanda, pois a falha na leitura compromete apenas a tarefa específica, não a identidade do agente.

### B. Injeção no Build/Load Time
Frameworks robustos movem a "leitura de arquivos de configuração" para o momento em que a extensão é carregada pelo sistema, e não delegam essa tarefa ao LLM em runtime. O conteúdo é concatenado e entregue ao agente como uma única instrução mestre.

### C. Self-Correction Loops (Autocorreção)
Uso de interceptadores que, ao detectarem um desvio de workflow ou violação de regra (ex: uso de jargão técnico), reinjetam o erro como uma nova instrução de correção (ex: "Sua resposta anterior usou o termo proibido 'Stakeholder'. Reescreva usando o termo permitido 'Pessoa envolvida'").

## 9. Conclusão e Recomendações v0.2.1

Para mitigar 100% o risco de falha por Workspace Sandboxing e Instruction Neglect, a arquitetura da ferramenta-tcc deve ser refatorada conforme abaixo:

1. **Abolir a Leitura Ativa do Core:** Remover do `GEMINI.md` e dos agentes a instrução de "Ler core/constitution.md antes de qualquer resposta".
2. **Injeção Inline Compulsória:** O conteúdo da `constitution.md` deve ser movido para dentro do `GEMINI.md` principal da extensão ou embutido diretamente nos wrappers de sistema do Gemini CLI.
3. **Hierarchy of Constraints:** Utilizar tags XML para separar claramente as **Regras de Negócio** (probabilísticas) das **Regras de Workflow** (determinísticas), garantindo que as segundas tenham precedência visual e semântica no prompt assembled.
4. **Tool Permission Scoping:** Aceitar que ferramentas de leitura não terão acesso a pastas de sistema e mover qualquer dado necessário para a lógica do agente para dentro de arquivos que o CLI injeta automaticamente via contexto.

---
*Este documento consolida a investigação sobre aderência de workflow e define a base para a próxima iteração técnica da ferramenta.*

