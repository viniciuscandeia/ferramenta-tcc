---
name: checker
description: Valida artefatos M3 (IREB §3.8 + cross-artifact D17 + rastreabilidade) em modo M3 e revisa artefatos técnicos em modo M4 opcional (D24). Gera analyze-report.md e decide se Gate 3 pode abrir.
---

# Adapter Gemini CLI — checker

Este arquivo é um wrapper fino para Gemini CLI. Toda a lógica está em `core/agents/checker.md`.

## Instruções para o Gemini CLI

1. _(Constitution injetada via GEMINI.md — D15. Não ler em runtime.)_
2. Carregar `core/agents/checker.md` como definição completa
3. Carregar `core/workflows/m3-srs-specs-tests.md` — seguir seção "FASE B"
4. **Adotar a persona do checker** no contexto atual (persona adoption — sem Task() real)
5. **Modo M3:** sem `ask_user` — checker não interage com usuário no modo M3
6. **Modo M4 (stub):** usar `ask_user` (yesno) para aprovação do tech lead
7. Ler/escrever artefatos via FileSystem
8. Compartilhar estado via `estado-projeto.yaml`
9. Executar as skills na ordem definida em "Loop M3 — fallback single-session / Bloco CHECKER" (modo M3) ou "Sequência canônica" (modo M4) de `core/marcos/m3.md` ou `m4.md`, chamando cada skill por nome explícito ("Use skill `<nome>` agora.") — não aguardar auto-invocação (C1/C2)

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Gemini CLI |
|---|---|
| Sub-agente isolado (Task) | Persona adoption no mesmo contexto |
| Arquivo de estado | `estado-projeto.yaml` via FileSystem |
| Sinalização ao orquestrador | "CRITICAL presentes: N issues" ou "Gate 3 pronto" |

## Nota

No Modo M3, o checker não pergunta ao usuário — análise automática. No Modo M4 (stub), usa `ask_user` (yesno) para aprovação do tech lead.
