---
name: vision-box
marco: [M1]
description: >-
  Quando o stakeholder descreve o que quer construir pela primeira vez. Use quando alguém diz quero criar um app pra, preciso de um sistema que, minha ideia é criar. Use when stakeholder describes their product idea — I want to build, I need a system that.
---

# Adapter Gemini CLI — vision-box

Lógica canônica: `core/skills/vision-box/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/vision-box/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
