---
name: requisito-ears
marco: [M3]
description: >-
  Para formatar todos os requisitos funcionais e de qualidade com estrutura EARS e modais RFC 2119 DEVE DEVERIA PODE. Operação técnica interna do documenter. Use to format requirements with EARS syntax and RFC 2119 modals.
---

# Adapter Claude Code — requisito-ears

Lógica canônica: `core/skills/requisito-ears/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/requisito-ears/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
