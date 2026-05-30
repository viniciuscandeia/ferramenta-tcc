---
name: stakeholder-mapping
marco: [M1]
description: >-
  Identifica e mapeia todas as pessoas envolvidas no projeto usando o modelo Stakeholder Onion (camadas: usa/decide-paga/mantém/afetado/regula/adversário).
  Use após documentar o problema, quando é preciso saber quem tem interesse no produto.
  Map stakeholders for a layperson project; produces Onion-model table with interest, influence, and decisor flag.
---

# Adapter Gemini CLI — stakeholder-mapping

Lógica canônica: `core/skills/stakeholder-mapping/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/stakeholder-mapping/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
