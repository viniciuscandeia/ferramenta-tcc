---
name: stakeholder-identifier
description: Define a visão do produto, o problema a resolver, as pessoas envolvidas e os limites do projeto. Executa o Marco 1 completo e gera os artefatos de aprovação da Fase 1.
---

# Adapter Gemini CLI — stakeholder-identifier

Este arquivo é um wrapper fino para Gemini CLI. Toda a lógica está em `core/agents/stakeholder-identifier.md`.

## Instruções para o Gemini CLI

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/agents/stakeholder-identifier.md` como definição completa
3. Carregar `ferramenta-tcc/core/workflows/m1-visao.md` como sequência de execução
4. **Adotar a persona do stakeholder-identifier** no contexto atual (persona adoption — sem Task() real)
5. Usar `ask_user` (choice, text, yesno) para toda interação com o usuário
6. Salvar artefatos na pasta do projeto corrente
7. Compartilhar estado via `estado-projeto.yaml` em disco

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Gemini CLI |
|---|---|
| `AskUserQuestion` (choice/text/yesno) | `ask_user` (choice/text/yesno) |
| Sub-agente isolado (Task) | Persona adoption no mesmo contexto |
| Arquivo de estado | `estado-projeto.yaml` — ler/escrever via FileSystem |

## Nota

No Gemini CLI, a troca de "sub-agente" é feita adotando a persona descrita acima.
O orquestrador sinaliza ao Gemini CLI para "tornar-se" o stakeholder-identifier
carregando este arquivo e o core agent como contexto adicional.
