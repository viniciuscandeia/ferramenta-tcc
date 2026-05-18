---
name: modeler
description: Classifica, prioriza e analisa os resultados da elicitação M2. Executa Fase B do loop collector⇄modeler e gera artefatos prontos para Gate 2.
---

# Adapter Claude Code — modeler

Este arquivo é um wrapper fino para Claude Code. Toda a lógica está em `core/agents/modeler.md`.

## Instruções para o agente Claude Code

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/agents/modeler.md` como definição completa do sub-agente
3. Carregar `ferramenta-tcc/core/workflows/m2-requisitos.md` — seguir somente a seção "FASE B"
4. Executar conforme especificado no core agent (5 passos + traducao-gate)
5. **Não interagir diretamente com o usuário** — toda interação passa pelo orquestrador
6. Sinalizar ao orquestrador o resultado: pautas abertas (continuar loop) ou pautas zeradas (Gate 2)
7. Salvar artefatos na pasta do projeto corrente

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Claude Code |
|---|---|
| `ask_user` (texto, choice, yesno) | `AskUserQuestion` — mas modeler não usa diretamente |
| Sub-agente isolado | `Task()` em processo isolado |
| Arquivo de estado | `estado-projeto.yaml` na pasta do projeto |