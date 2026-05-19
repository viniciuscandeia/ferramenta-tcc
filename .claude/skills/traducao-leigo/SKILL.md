---
name: traducao-leigo
marco: [M1, M2, M3]
description: >-
  Para verificar e reescrever texto removendo jargão técnico de ER antes de apresentar ao usuário leigo. Invocada por qualquer agente antes de exibir texto ao usuário. Use to verify and remove technical jargon before presenting any text to the layperson user.
---

# Adapter Claude Code — traducao-leigo

Lógica canônica: `core/skills/traducao-leigo/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/traducao-leigo/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
