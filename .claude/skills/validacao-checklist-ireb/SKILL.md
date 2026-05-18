---
name: validacao-checklist-ireb
description: >-
  Para verificar a qualidade do documento de requisitos contra os 12 critérios IREB §3.8. Operação interna do checker. Use to validate the SRS against 12 IREB quality criteria including correctness, completeness and consistency.
---

# Adapter Claude Code — validacao-checklist-ireb

Lógica canônica: `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
