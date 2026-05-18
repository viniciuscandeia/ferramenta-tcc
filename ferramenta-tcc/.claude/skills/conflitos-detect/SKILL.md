---
name: conflitos-detect
description: >-
  Para detectar quando dois requisitos ou stakeholders têm necessidades contraditórias entre si. Operação interna após modelagem. Use to detect conflicts between requirements or between stakeholders' needs.
---

# Adapter Claude Code — conflitos-detect

Lógica canônica: `ferramenta-tcc/core/skills/conflitos-detect/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/conflitos-detect/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
