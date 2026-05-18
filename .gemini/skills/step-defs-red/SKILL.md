---
name: step-defs-red
description: >-
  Para gerar código de teste inicial RED que falha propositalmente em Python, JavaScript e C#. Operação técnica interna. Use to generate RED step definitions for Pytest-BDD, Cucumber-js and SpecFlow.
---

# Adapter Gemini CLI — step-defs-red

Lógica canônica: `ferramenta-tcc/core/skills/step-defs-red/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/step-defs-red/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
