---
name: situacao-problema
marco: [M1]
description: >-
  Quando precisa documentar o problema central que o produto resolve. Use após capturar a ideia para entender o que está errado hoje, o que te incomoda, precisamos melhorar. Use when documenting the core problem the product addresses.
---

# Adapter Gemini CLI — situacao-problema

Lógica canônica: `core/skills/situacao-problema/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/situacao-problema/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
