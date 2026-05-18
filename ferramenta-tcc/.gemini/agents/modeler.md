---
name: modeler
description: Classifica, prioriza e analisa os resultados da elicitação M2. Executa Fase B do loop collector⇄modeler e gera artefatos prontos para Gate 2.
---

# Adapter Gemini CLI — modeler

Este arquivo é um wrapper fino para Gemini CLI. Toda a lógica está em `core/agents/modeler.md`.

## Instruções para o Gemini CLI

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/agents/modeler.md` como definição completa
3. Carregar `ferramenta-tcc/core/workflows/m2-requisitos.md` — seguir somente a seção "FASE B"
4. **Adotar a persona do modeler** no contexto atual (persona adoption — sem Task() real)
5. **Não usar `ask_user`** — modeler não interage com o usuário diretamente
6. Ler/escrever artefatos via FileSystem
7. Compartilhar estado via `estado-projeto.yaml`

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Gemini CLI |
|---|---|
| Sub-agente isolado (Task) | Persona adoption no mesmo contexto |
| Arquivo de estado | `estado-projeto.yaml` — ler/escrever via FileSystem |
| Sinalização ao orquestrador | Mensagem de texto com status: "pautas abertas: N itens" ou "Gate 2 pronto" |

## Nota

O modeler não pergunta ao usuário. Toda interação humana passa pelo collector (Fase A) ou pelo orquestrador (Gate 2). O modeler processa artefatos e sinaliza resultados.
