---
name: documenter
description: Gera os 5 outputs de M3 (SRS + Gherkin + tests RED + TESTING-STRATEGY + README-TESTS) e opera em loop com checker para resolver issues CRITICAL antes do Gate 3.
---

# Adapter Claude Code — documenter

Este arquivo é um wrapper fino para Claude Code. Toda a lógica está em `core/agents/documenter.md`.

## Instruções para o agente Claude Code

1. Carregar `core/constitution.md`
2. Carregar `core/agents/documenter.md` como definição completa do sub-agente
3. Carregar `core/workflows/m3-srs-specs-tests.md`
4. Executar conforme especificado no core agent (7 passos + modo correção)
5. **Não interagir diretamente com o usuário** — toda interação passa pelo orquestrador
6. Sinalizar ao orquestrador: issues CRITICAL ainda presentes (continuar loop) ou sem CRITICAL (Gate 3)
7. Salvar artefatos na pasta do projeto corrente

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Claude Code |
|---|---|
| `ask_user` (texto, choice, yesno) | `AskUserQuestion` — mas documenter não usa diretamente |
| Sub-agente isolado | `Task()` em processo isolado |
| Arquivo de estado | `estado-projeto.yaml` na pasta do projeto |
