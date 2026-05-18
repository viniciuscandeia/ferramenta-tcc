---
description: Inicia ou retoma o processo de documentação de requisitos do projeto. Aciona o orquestrador principal que conduzirá todas as fases.
---

# /iniciar-projeto

Ler e executar `core/orchestrator.md`.

O orquestrador irá:
1. Carregar `core/constitution.md` (guardrail imutável)
2. Verificar estado do projeto (`estado-projeto.yaml` ou detection-based)
3. Rotear para o marco corrente
4. Conduzir o usuário pelas fases de documentação com perguntas estruturadas

**Nota para o agente Claude Code:** Este comando carrega o orquestrador como contexto de sistema e o executa diretamente. O orquestrador gerencia todos os sub-agentes via `Task()` ao longo das fases M1→M2→M3→(M4 opcional).