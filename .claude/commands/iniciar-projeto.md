---
description: Inicia ou retoma o processo de documentação de requisitos do projeto. Aciona o orquestrador principal que conduzirá todas as fases.
---

# /iniciar-projeto

Ler e executar `core/orchestrator.md`.

O orquestrador irá:
1. _(Constitution já injetada inline em agents/orchestrator.md — D15. Não ler em runtime.)_
2. Verificar estado do projeto (`estado-projeto.yaml` ou detection-based)
3. Identificar `marco_corrente` e carregar **exclusivamente** `core/marcos/{marco_corrente}.md`
4. Conduzir o usuário pelas fases de documentação com perguntas estruturadas

**Nota para o agente Claude Code:** Este comando carrega o orquestrador como contexto de sistema e o executa diretamente. O orquestrador gerencia sub-agentes via `Task()` **apenas do marco corrente**.

**Filtragem de skills por marco (C2):**
- Antes de invocar qualquer `Task(agent)`, ler `estado-projeto.yaml.marco_corrente`
- Considerar apenas skills cujo campo `marco:` no frontmatter inclua o marco corrente
- Exemplo: se `marco_corrente: M2`, as skills `gherkin-spec`, `srs-ireb-template`, `step-defs-red` (M3) **não existem** nesta sessão
- Skills transversais (`traducao-leigo`, `traducao-gate`) têm `marco: [M1, M2, M3]` — sempre disponíveis