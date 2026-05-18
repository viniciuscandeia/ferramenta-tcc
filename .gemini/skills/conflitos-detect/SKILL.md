---
name: conflitos-detect
description: >-
  Para detectar quando dois requisitos ou stakeholders têm necessidades contraditórias entre si. Operação interna após modelagem. Use to detect conflicts between requirements or between stakeholders' needs.
---

# Adapter Gemini CLI — conflitos-detect

Lógica canônica: `core/skills/conflitos-detect/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/conflitos-detect/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
