---
name: stakeholder-mapping
description: >-
  Quando precisa identificar quem usa, quem decide e quem é afetado pelo produto. Use para mapear quem vai usar, quem aprova, quem é impactado. Use when mapping people involved in or affected by the project.
---

# Adapter Claude Code — stakeholder-mapping

Lógica canônica: `core/skills/stakeholder-mapping/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/stakeholder-mapping/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
