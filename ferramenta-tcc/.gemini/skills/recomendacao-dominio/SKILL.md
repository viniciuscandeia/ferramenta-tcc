---
name: recomendacao-dominio
marco: [M2]
description: >-
  Para sugerir funcionalidades típicas do domínio do projeto como educação, saúde, e-commerce, gestão. Use após identificar o domínio para confirmar esses recursos fazem sentido para você. Use to recommend typical domain-specific features.
---

# Adapter Gemini CLI — recomendacao-dominio

Lógica canônica: `core/skills/recomendacao-dominio/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/recomendacao-dominio/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
