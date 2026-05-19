---
name: recomendacao-dominio
marco: [M2]
description: >-
  Para sugerir funcionalidades típicas do domínio do projeto como educação, saúde, e-commerce, gestão. Use após identificar o domínio para confirmar esses recursos fazem sentido para você. Use to recommend typical domain-specific features.
---

# Adapter Claude Code — recomendacao-dominio

Lógica canônica: `core/skills/recomendacao-dominio/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/recomendacao-dominio/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
