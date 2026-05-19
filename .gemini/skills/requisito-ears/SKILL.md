---
name: requisito-ears
marco: [M3]
description: >-
  Para formatar todos os requisitos funcionais e de qualidade com estrutura EARS e modais RFC 2119 DEVE DEVERIA PODE. Operação técnica interna do documenter. Use to format requirements with EARS syntax and RFC 2119 modals.
---

# Adapter Gemini CLI — requisito-ears

Lógica canônica: `core/skills/requisito-ears/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/requisito-ears/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
