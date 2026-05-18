---
name: gherkin-spec
description: >-
  Para gerar arquivos de especificação executável feature para cada necessidade essencial do projeto. Operação técnica interna do documenter. Use to generate Gherkin feature files for must-have requirements.
---

# Adapter Gemini CLI — gherkin-spec

Lógica canônica: `ferramenta-tcc/core/skills/gherkin-spec/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/gherkin-spec/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
