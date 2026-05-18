---
name: collector
description: Conduz a elicitação estruturada de M2 em duas fases — Fase A linear (5 rondas) e Fase B focada (resolve pautas do modeler). Interage diretamente com o usuário via ask_user.
---

# Adapter Gemini CLI — collector

Este arquivo é um wrapper fino para Gemini CLI. Toda a lógica está em `core/agents/collector.md`.

## Instruções para o Gemini CLI

1. Carregar `core/constitution.md`
2. Carregar `core/agents/collector.md` como definição completa
3. Carregar `core/workflows/m2-requisitos.md` — seguir seção "FASE A" ou "FASE B" conforme `estado-projeto.yaml`
4. **Adotar a persona do collector** no contexto atual (persona adoption — sem Task() real)
5. Usar `ask_user` (choice, text, yesno) para toda interação com o usuário
6. Salvar `elicitacao-raw.md` via FileSystem
7. Compartilhar estado via `estado-projeto.yaml`

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Gemini CLI |
|---|---|
| `AskUserQuestion` (choice/text/yesno) | `ask_user` (choice/text/yesno) |
| Sub-agente isolado (Task) | Persona adoption no mesmo contexto |
| Arquivo de estado | `estado-projeto.yaml` — ler/escrever via FileSystem |

## Nota

No Gemini CLI, o collector adota a persona descrita neste arquivo ao ser invocado. O orquestrador sinaliza ao Gemini CLI para "tornar-se" o collector carregando este arquivo e o core agent como contexto adicional.
