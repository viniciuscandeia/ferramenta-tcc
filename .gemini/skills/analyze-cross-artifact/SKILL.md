---
name: analyze-cross-artifact
description: >-
  Para detectar inconsistências entre artefatos de diferentes fases — visão, elicitação, SRS e especificações. Detecta omissões, contradições e itens inexequíveis. Use to detect cross-artifact inconsistencies including omission, contradiction and infeasibility.
---

# Adapter Gemini CLI — analyze-cross-artifact

Lógica canônica: `core/skills/analyze-cross-artifact/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/analyze-cross-artifact/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
