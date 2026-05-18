---
name: validacao-checklist-ireb
description: >
  
---

# Adapter Claude Code — validacao-checklist-ireb

Lógica canônica: `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
