---
name: checker
description: Valida artefatos M3 (IREB §3.8 + cross-artifact D17 + rastreabilidade) em modo M3 e revisa artefatos técnicos em modo M4 opcional (D24). Gera analyze-report.md e decide se Gate 3 pode abrir.
---

# Adapter Claude Code — checker

Este arquivo é um wrapper fino para Claude Code. Toda a lógica está em `core/agents/checker.md`.

## Instruções para o agente Claude Code

1. Carregar `core/constitution.md`
2. Carregar `core/agents/checker.md` como definição completa do sub-agente
3. Carregar `core/workflows/m3-srs-specs-tests.md` — seguir seção "FASE B"
4. Executar conforme especificado no core agent (4 passos M3 ou 3 passos M4 stub)
5. **Modo M3:** não interagir com o usuário — análise automática dos artefatos
6. **Modo M4 (stub):** usar `AskUserQuestion` (yesno) para aprovação do tech lead
7. Sinalizar ao orquestrador: issues CRITICAL presentes (retornar ao documenter) ou sem CRITICAL (Gate 3 pronto)
8. Salvar `analyze-report.md` e `rastreabilidade.md` na pasta do projeto corrente

## Mapeamento de primitivas (D12)

| Primitiva core | Primitiva Claude Code |
|---|---|
| `ask_user` (yesno) | `AskUserQuestion` — somente Modo M4 |
| Sub-agente isolado | `Task()` em processo isolado |
| Arquivo de estado | `estado-projeto.yaml` na pasta do projeto |
