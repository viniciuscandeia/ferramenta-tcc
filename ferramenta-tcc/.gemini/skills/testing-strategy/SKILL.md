---
name: testing-strategy
description: >-
  Para gerar estratégia de testes para cada requisito de qualidade como performance, segurança, usabilidade. Operação técnica interna do documenter. Use to generate testing strategy for each non-functional requirement.
---

# Adapter Gemini CLI — testing-strategy

Lógica canônica: `core/skills/testing-strategy/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/testing-strategy/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
