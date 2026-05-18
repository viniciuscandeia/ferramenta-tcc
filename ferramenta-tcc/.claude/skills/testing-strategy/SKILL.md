---
name: testing-strategy
description: >-
  Para gerar estratégia de testes para cada requisito de qualidade como performance, segurança, usabilidade. Operação técnica interna do documenter. Use to generate testing strategy for each non-functional requirement.
---

# Adapter Claude Code — testing-strategy

Lógica canônica: `core/skills/testing-strategy/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/testing-strategy/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
