---
name: stakeholder-identifier
description: Define a visão do produto, o problema a resolver, as pessoas envolvidas e os limites do projeto. Executa o Marco 1 completo e gera os artefatos de aprovação da Fase 1.
---

# Adapter Claude Code — stakeholder-identifier

Este arquivo é um wrapper fino para Claude Code. Toda a lógica está em `core/agents/stakeholder-identifier.md`.

## Instruções para o agente Claude Code

1. Carregar `core/constitution.md`
2. Carregar `core/agents/stakeholder-identifier.md` como definição completa do sub-agente
3. Carregar `core/workflows/m1-visao.md` como sequência de execução
4. Executar conforme especificado no core agent
5. Usar `AskUserQuestion` para toda interação com o usuário (não usar Bash para perguntas)
6. Salvar artefatos na pasta do projeto corrente

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Claude Code |
|---|---|
| `ask_user` (texto, choice, yesno) | `AskUserQuestion` |
| Sub-agente isolado | `Task()` em processo isolado |
| Arquivo de estado | `estado-projeto.yaml` na pasta do projeto |
