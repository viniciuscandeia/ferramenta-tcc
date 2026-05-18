---
name: analyze-cross-artifact
description: >-
  Para detectar inconsistências entre artefatos de diferentes fases — visão, elicitação, SRS e especificações. Detecta omissões, contradições e itens inexequíveis. Use to detect cross-artifact inconsistencies including omission, contradiction and infeasibility.
---

# Adapter Claude Code — analyze-cross-artifact

Lógica canônica: `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
