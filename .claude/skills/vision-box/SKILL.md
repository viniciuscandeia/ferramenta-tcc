---
name: vision-box
marco: [M1]
description: >-
  Quando o stakeholder descreve o que quer construir pela primeira vez. Use quando alguém diz quero criar um app pra, preciso de um sistema que, minha ideia é criar. Use when stakeholder describes their product idea — I want to build, I need a system that.
---

# Adapter Claude Code — vision-box

Lógica canônica: `core/skills/vision-box/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/vision-box/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
