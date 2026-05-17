# Guia de Criação e Arquitetura de Agentes: Claude Code & Gemini CLI

Este guia explora como criar, configurar e orquestrar **Sub-Agentes** (ou Personas) para transformar uma ferramenta CLI genérica em uma força de trabalho especializada e coordenada.

---

## 1. Por que usar Sub-Agentes?

Em vez de um único agente tentar resolver tudo, a arquitetura multi-agente oferece:
*   **Isolamento de Contexto:** Tarefas pesadas (como ler 50 arquivos de logs) ocorrem em uma janela separada. Apenas o resumo volta para você, economizando tokens e mantendo a sessão rápida.
*   **Especialização de Ferramentas:** Você pode limitar as ferramentas de um agente (ex: um "Pesquisador" pode ler arquivos, mas não pode executar comandos Bash ou escrever no disco).
*   **Paralelismo:** Vários sub-agentes podem trabalhar simultaneamente em tarefas independentes.

---

## 2. Estrutura de Definição de Agente

Tanto no Claude quanto no Gemini, os agentes são definidos por arquivos Markdown com Frontmatter YAML.

### Exemplo de Definição (`code-reviewer.md`):
```markdown
---
name: code-reviewer
description: Especialista em revisão de segurança e performance. Use quando o usuário pedir para "revisar", "auditar" ou "checar" código novo.
tools: [read_file, glob, grep_search]
model: sonnet
---

# Persona: Revisor Senior
Você é um engenheiro de software focado em segurança (OWASP) e performance.
Seu objetivo é encontrar vulnerabilidades e gargalos antes do merge.

## Diretrizes
1. Verifique sempre se há inputs não sanitizados.
2. Sugira o uso de `useMemo` ou `useCallback` apenas se necessário.
3. Se encontrar um erro, forneça a solução exata em um bloco de código.
```

---

## 3. Localização e Escopo

| Escopo | Caminho (Claude) | Caminho (Gemini) | Uso |
| :--- | :--- | :--- | :--- |
| **Projeto** | `.claude/agents/*.md` | `.gemini/agents/*.md` | Agentes específicos do repositório (compartilhados via Git). |
| **Pessoal** | `~/.claude/agents/*.md` | `~/.gemini/agents/*.md` | Seus especialistas pessoais em qualquer projeto. |

---

## 4. Padrões de Orquestração no CLI

### A. Delegação Automática (O Padrão "Gerente")
O agente principal lê a `description` de todos os sub-agentes ativos. Se o pedido do usuário combina com uma descrição, ele invoca o especialista automaticamente.
*   *Dica:* Capriche na `description` do YAML. Ela é o "critério de escolha" do agente principal.

### B. Invocação Explícita (Sintaxe `@`)
Você pode forçar o uso de um agente específico no terminal:
*   `@code-reviewer revise os últimos 3 commits.`

### C. O Padrão "Agentes como Ferramentas"
Neste modelo, o agente principal usa a ferramenta `invoke_agent` como se fosse um script. Ele manda o sub-agente realizar uma sub-tarefa e espera o resultado para continuar sua própria lógica.

---

## 5. Melhores Práticas para Personas CLI

1.  **Princípio da Menor Autoridade:** Dê ao sub-agente apenas as ferramentas (`tools`) estritamente necessárias. Um agente de documentação não precisa de acesso ao `run_shell_command`.
2.  **Saída Sintetizada:** Instrua seus sub-agentes a retornarem resumos executivos. O agente principal não quer ver o log de 200 linhas; ele quer saber se "o teste passou ou falhou".
3.  **Recursão Proibida:** No Gemini CLI, sub-agentes **não podem** chamar outros sub-agentes para evitar loops infinitos e custos explosivos.
4.  **Modelos Diferenciados:** Use modelos mais potentes (Sonnet/Pro) para o "Supervisor" e modelos mais rápidos/baratos (Haiku/Flash) para tarefas repetitivas de "Trabalhador".

---

## 6. Comandos de Gerenciamento

*   **Listar:** `/agents list`
*   **Recarregar:** `/agents reload` (após editar um arquivo .md)
*   **Criar (Claude):** `/agents` -> guia "Library" -> "Create New Agent"

---

> **Conclusão para o TCC:** Para sua ferramenta de Requisitos, você pode criar agentes como `vision-specialist`, `elicitation-coach` e `srs-writer`. O agente principal atua como o orquestrador do processo de engenharia de requisitos.
