---
name: situacao-problema
description: >
  
---

# Adapter Gemini CLI — situacao-problema

Lógica canônica: `ferramenta-tcc/core/skills/situacao-problema/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat — não assume invocação automática pelo runtime.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/situacao-problema/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
