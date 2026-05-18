---
name: priorizacao
description: >-
  Para definir o que é essencial, recomendado ou opcional em cada necessidade do projeto. Use para perguntar o que vem primeiro, o que é indispensável, o que pode ficar para depois. Use to prioritize requirements and assign must, should, may importance levels.
---

# Adapter Gemini CLI — priorizacao

Lógica canônica: `ferramenta-tcc/core/skills/priorizacao/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/priorizacao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
