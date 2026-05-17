# Ergonomia e UX no CLI para Agentes de IA

Trabalhar com agentes de IA no terminal (CLI) apresenta um desafio único: como criar uma experiência fluida para **humanos leigos** enquanto mantemos a precisão necessária para a **máquina**. No seu TCC, onde o usuário responde perguntas da IA, a ergonomia é o que separa um "chatbot chato" de uma ferramenta produtiva.

---

## 1. O Conceito de "Arquitetura de Modo Duplo"

O seu plugin deve ser capaz de detectar se está falando com um humano ou com outro agente/script.
*   **Modo Humano:** Focado em legibilidade, spinners de progresso, cores (ANSI) e questionários amigáveis.
*   **Modo Agente:** Saída pura em JSON, sem cores, focada em ser processada por código.

---

## 2. Padrões de Interação Human-in-the-Loop (HITL)

O uso da ferramenta `ask_user` é o coração da interação. Não a use apenas para perguntas abertas.

### A. O Questionário Estruturado (Wizards)
Em vez de pedir para o usuário escrever um parágrafo, ofereça opções.
*   **Múltipla Escolha:** "Qual destes stakeholders melhor descreve o seu papel? [1] Gestor, [2] Desenvolvedor, [3] Usuário Final".
*   **Confirmação Atômica:** Em vez de "O que você acha desta regra?", use "Esta regra de negócio está correta? [S/n]".

### B. Plan Mode (Pesquisa antes da Ação)
Antes de o agente começar a escrever requisitos, ele deve apresentar um **Plano de Elicitação** ao usuário via `ask_user`.
*   *Exemplo:* "Vou começar perguntando sobre a Visão do Produto, depois sobre os Atores e por fim sobre as Restrições. Está de acordo?".
*   **Benefício:** Isso dá ao usuário a sensação de controle e reduz a ansiedade de não saber o que a IA está fazendo.

---

## 3. Prevenindo a Fadiga do Usuário (User Fatigue)

Interagir com uma IA pode ser exaustivo se ela perguntar demais ou der informações inúteis.

### A. Autonomia Graduada
Não peça permissão para tudo. Classifique as ações por risco:
*   **Baixo Risco (Leitura):** O agente lê os catálogos típicos sem avisar.
*   **Médio Risco (Anotação):** O agente anota um fato na memória e apenas mostra um log discreto: `[Memória] Stakeholder Maria adicionado`.
*   **Alto Risco (Escrita/Finalização):** O agente para e pede aprovação explícita antes de gerar o documento SRS final.

### B. Atualizações por "Tópicos" (Topic Model)
Evite o "streaming" de pensamentos da IA (aquele texto que rola infinitamente). 
*   Use atualizações de status que resumem a **intenção** (ex: "Analisando consistência dos requisitos...") em vez da **mecânica** (ex: "Lendo arquivo X... comparando com Y...").

### C. Batching (Agrupamento)
Se a IA identificou 5 conflitos nos requisitos, ela não deve fazer 5 perguntas separadas. Ela deve agrupar:
*   "Encontrei 5 inconsistências. Gostaria de revisá-las uma a uma ou quer que eu tente resolver as mais simples automaticamente?".

---

## 4. Design para "Pausa e Retomada"

Como discutido na Gestão de Memória, a ergonomia exige que o usuário possa sair a qualquer momento.
*   **Checkpoints Visuais:** Sempre que um sub-objetivo for atingido, mostre um resumo: *"Marco 1 concluído. Todos os dados salvos em `.ferramenta-ers/`. Você pode fechar o terminal e continuar amanhã."*

---

## 5. Dicas de Ouro para o seu TCC

1.  **Use a Ferramenta de Diferença (Diff):** Quando o agente sugerir uma mudança em um requisito já escrito, não mostre o texto todo de novo. Mostre apenas o que mudou (estilo `git diff`). É muito mais fácil para o humano revisar.
2.  **Saída de Erro Amigável:** Se o agente falhar (ex: API do Google fora do ar), não mostre um erro de código. Diga: *"Tive um problema de conexão. Não se preocupe, seu progresso está salvo. Tente novamente em alguns minutos."*
3.  **Sugestão de "Próximos Passos":** Ao final de cada interação, o agente deve sugerir o que o usuário pode fazer a seguir: *"Sugestão: Agora podemos definir as restrições de segurança ou revisar os atores."*
