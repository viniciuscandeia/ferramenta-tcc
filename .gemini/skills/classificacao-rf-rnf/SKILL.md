---
name: classificacao-rf-rnf
description: >-
  Para classificar itens coletados em o que faz, como se comporta, restrições e premissas do projeto. Use após elicitação completa para organizar tudo que foi descoberto. Use to classify collected items into functional, quality requirements, constraints and assumptions.
---

# Adapter Gemini CLI — classificacao-rf-rnf

Lógica canônica: `core/skills/classificacao-rf-rnf/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/classificacao-rf-rnf/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
