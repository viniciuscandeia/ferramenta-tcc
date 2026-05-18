---
name: step-defs-red
description: >-
  Para gerar código de teste inicial RED que falha propositalmente em Python, JavaScript e C#. Operação técnica interna. Use to generate RED step definitions for Pytest-BDD, Cucumber-js and SpecFlow.
---

# Adapter Claude Code — step-defs-red

Lógica canônica: `ferramenta-tcc/core/skills/step-defs-red/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/step-defs-red/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
