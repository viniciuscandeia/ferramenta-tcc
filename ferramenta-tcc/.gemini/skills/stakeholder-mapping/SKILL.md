---
name: stakeholder-mapping
marco: [M1]
description: >-
  Quando precisa identificar quem usa, quem decide e quem é afetado pelo produto. Use para mapear quem vai usar, quem aprova, quem é impactado. Use when mapping people involved in or affected by the project.
---

# Adapter Gemini CLI — stakeholder-mapping

Lógica canônica: `core/skills/stakeholder-mapping/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/stakeholder-mapping/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
