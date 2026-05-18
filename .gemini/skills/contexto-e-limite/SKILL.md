---
name: contexto-e-limite
description: >-
  Quando precisa definir o que está dentro e fora do projeto. Use para esclarecer o que o sistema faz, o que não é responsabilidade do sistema, onde termina o produto. Use when clarifying what is in and out of scope.
---

# Adapter Gemini CLI — contexto-e-limite

Lógica canônica: `ferramenta-tcc/core/skills/contexto-e-limite/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/contexto-e-limite/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
