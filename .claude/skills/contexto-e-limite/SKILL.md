---
name: contexto-e-limite
marco: [M1]
description: >-
  Quando precisa definir o que está dentro e fora do projeto. Use para esclarecer o que o sistema faz, o que não é responsabilidade do sistema, onde termina o produto. Use when clarifying what is in and out of scope.
---

# Adapter Claude Code — contexto-e-limite

Lógica canônica: `core/skills/contexto-e-limite/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/contexto-e-limite/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
