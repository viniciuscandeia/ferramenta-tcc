---
name: questionario-feixe
description: >-
  Quando há áreas do sistema sem cobertura suficiente após as elicitações principais. Agrupa perguntas temáticas para cobrir lacunas. Use when areas of the system lack sufficient coverage after main elicitation rounds.
---

# Adapter Gemini CLI — questionario-feixe

Lógica canônica: `core/skills/questionario-feixe/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/questionario-feixe/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
