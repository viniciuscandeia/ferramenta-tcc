---
name: collector
description: Conduz a elicitação estruturada de M2 em duas fases — Fase A linear (5 rondas) e Fase B focada (resolve pautas do modeler). Interage diretamente com o usuário via AskUserQuestion.
---

# Adapter Claude Code — collector

Este arquivo é um wrapper fino para Claude Code. Toda a lógica está em `core/agents/collector.md`.

## Instruções para o agente Claude Code

1. Carregar `core/constitution.md`
2. Carregar `core/agents/collector.md` como definição completa do sub-agente
3. Carregar `core/workflows/m2-requisitos.md` — seguir seção "FASE A" ou "FASE B" conforme `estado-projeto.yaml`
4. Executar conforme especificado no core agent
5. Usar `AskUserQuestion` para toda interação com o usuário (não usar Bash para perguntas)
6. Salvar `elicitacao-raw.md` na pasta do projeto corrente
7. Sinalizar ao orquestrador ao concluir cada fase

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Claude Code |
|---|---|
| `ask_user` (texto, choice, yesno) | `AskUserQuestion` |
| Sub-agente isolado | `Task()` em processo isolado |
| Arquivo de estado | `estado-projeto.yaml` na pasta do projeto |