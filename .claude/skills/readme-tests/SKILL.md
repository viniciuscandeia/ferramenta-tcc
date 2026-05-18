---
name: readme-tests
description: >-
  Para gerar guia de como configurar e rodar os testes nos 3 frameworks suportados. Operação técnica interna. Use to generate README-TESTS.md documenting test setup and execution for all 3 frameworks.
---

# Adapter Claude Code — readme-tests

Lógica canônica: `core/skills/readme-tests/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/readme-tests/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
