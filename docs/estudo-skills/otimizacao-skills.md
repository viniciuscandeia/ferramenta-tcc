# Guia de Escrita e Otimização de Skills: Claude Code & Gemini CLI

Este guia detalha estratégias avançadas para projetar, escrever e otimizar Skills para agentes de IA baseados em CLI, focando em **eficiência de contexto**, **precisão de ativação** e **confiabilidade da execução**.

---

## 1. Arquitetura da Skill: O Princípio da Divulgação Progressiva

O maior desafio em agentes CLI é a **Janela de Contexto**. Injetar todas as instruções de uma vez torna o agente lento e propenso a erros. A solução é a Divulgação Progressiva (*Progressive Disclosure*).

### Camadas de Dados:
1.  **Frontmatter (Gatilho):** Apenas o nome e a descrição são carregados inicialmente. É o "SEO" da sua skill.
2.  **SKILL.md (Processo):** Carregado apenas após a ativação. Deve conter a *lógica de fluxo* (Plan-Act-Validate), não dados brutos.
3.  **Recursos Adjacentes (On-Demand):**
    *   `/scripts`: Lógica determinística (ex: regex complexos, chamadas de API).
    *   `/references`: Documentação pesada, schemas e guias de estilo que o agente lê apenas se precisar.

---

## 2. Otimização do Frontmatter (YAML)

A descrição determina **quando** a skill é usada.

*   **Palavras-Chave de Intenção:** Use verbos de ação específicos: "auditar", "migrar", "refatorar", "validar".
*   **Contexto de Ativação:** Seja explícito.
    *   *Ruim:* `description: Skill para testes.`
    *   *Bom:* `description: Especialista em auditoria de segurança OWASP para Node.js. Use quando o usuário pedir para "checar vulnerabilidades" ou "revisar segurança" no código.`

---

## 3. Prompt Engineering para `SKILL.md`

### Estrutura Sugerida:
1.  **# Core Mandates:** Regras inegociáveis (ex: "NUNCA altere arquivos .env", "SEMPRE use o script X para validar").
2.  **# Procedural Workflow:** Passo a passo determinístico. Use listas numeradas para forçar o agente a seguir uma sequência lógica.
3.  **# Degrees of Freedom:** Defina o nível de autonomia.
    *   *Baixa Liberdade:* "Execute o script `scripts/deploy.sh` e relate o erro." (Para tarefas críticas).
    *   *Alta Liberdade:* "Proponha três alternativas de design para o componente." (Para tarefas criativas).

### Técnicas de Otimização:
*   **Injeção de Comandos (Claude):** Use ``! `comando` `` para injetar a saída de um shell command diretamente na instrução da skill.
*   **Sub-Agentes (Fork):** Use `context: fork` no frontmatter para tarefas que precisam de um ambiente limpo e isolado, evitando que o histórico da conversa principal confunda o agente.
*   **Verificação de Sucesso:** Termine sempre com uma instrução de validação (ex: "Após a mudança, execute os testes unitários e confirme se o erro X foi resolvido").

---

## 4. Ergonomia Agêntica e Scripts

Skills poderosas não apenas "falam", elas "fazem".

*   **Saída Amigável ao LLM (LLM-Friendly):** Scripts em `/scripts` devem retornar texto limpo (Markdown ou JSON simplificado). Evite stacktraces gigantes; capture o erro e retorne apenas a causa raiz.
*   **Tratamento de Erros:** Ensine a skill a se auto-corrigir.
    *   *Exemplo:* "Se o script de lint falhar com erro de ponto e vírgula, execute o comando de autofix antes de tentar novamente."
*   **Truncagem Inteligente:** Se um script gera muita saída, programe-o para retornar apenas as primeiras/últimas 50 linhas ou um resumo dos erros.

---

## 5. Manutenção e Iteração

1.  **Avaliação de Contexto:** Periodicamente, verifique se a sua `SKILL.md` está crescendo demais. Se passar de 500 linhas, mova partes para `/references`.
2.  **Teste de Gatilho:** Tente "provocar" a ativação da skill com frases ambíguas para ajustar a `description`.
3.  **Dry Runs:** Peça ao agente para "Explicar como você usaria a skill X para o problema Y" antes de deixá-lo executar.

---

> **Dica de Ouro:** Utilize a skill nativa `skill-creator` para gerar o boilerplate inicial. Ela já vem configurada com esses padrões de otimização.
