---
name: priorizacao
description: >-
  Para definir o que é essencial, recomendado ou opcional em cada necessidade do projeto. Use para perguntar o que vem primeiro, o que é indispensável, o que pode ficar para depois. Use to prioritize requirements and assign must, should, may importance levels.
---

# Adapter Claude Code — priorizacao

Lógica canônica: `core/skills/priorizacao/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/priorizacao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
