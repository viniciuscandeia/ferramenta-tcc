---
name: srs-ireb-template
description: >-
  Para montar o documento completo do projeto com as 6 seções padrão IREB ISO 29148. Operação interna após todos os requisitos estarem formatados. Use to assemble the complete SRS with 6 IREB sections.
---

# Adapter Gemini CLI — srs-ireb-template

Lógica canônica: `core/skills/srs-ireb-template/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/srs-ireb-template/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
