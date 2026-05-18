---
name: traducao-leigo
description: >-
  Para verificar e reescrever texto removendo jargão técnico de ER antes de apresentar ao usuário leigo. Invocada por qualquer agente antes de exibir texto ao usuário. Use to verify and remove technical jargon before presenting any text to the layperson user.
---

# Adapter Gemini CLI — traducao-leigo

Lógica canônica: `core/skills/traducao-leigo/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/traducao-leigo/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
