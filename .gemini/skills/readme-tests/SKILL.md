---
name: readme-tests
description: >-
  Para gerar guia de como configurar e rodar os testes nos 3 frameworks suportados. Operação técnica interna. Use to generate README-TESTS.md documenting test setup and execution for all 3 frameworks.
---

# Adapter Gemini CLI — readme-tests

Lógica canônica: `ferramenta-tcc/core/skills/readme-tests/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/readme-tests/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
