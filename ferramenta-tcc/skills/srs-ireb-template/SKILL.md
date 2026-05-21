---
name: srs-ireb-template
marco: [M3]
description: >-
  Para montar o documento completo do projeto com as 6 seções padrão IREB ISO 29148. Operação interna após todos os requisitos estarem formatados. Use to assemble the complete SRS with 6 IREB sections.
---

# Adapter Claude Code — srs-ireb-template

Lógica canônica: `core/skills/srs-ireb-template/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/srs-ireb-template/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
