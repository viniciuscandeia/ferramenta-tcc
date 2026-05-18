---
name: situacao-problema
description: >-
  Quando precisa documentar o problema central que o produto resolve. Use após capturar a ideia para entender o que está errado hoje, o que te incomoda, precisamos melhorar. Use when documenting the core problem the product addresses.
---

# Adapter Claude Code — situacao-problema

Lógica canônica: `core/skills/situacao-problema/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/situacao-problema/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
