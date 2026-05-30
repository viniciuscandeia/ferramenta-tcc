---
name: stakeholder-mapping
marco: [M1]
description: >-
  Identifica e mapeia todas as pessoas envolvidas no projeto usando o modelo Stakeholder Onion (camadas: usa/decide-paga/mantém/afetado/regula/adversário).
  Use após documentar o problema, quando é preciso saber quem tem interesse no produto.
  Map stakeholders for a layperson project; produces Onion-model table with interest, influence, and decisor flag.
---

# Adapter Claude Code — stakeholder-mapping

Lógica canônica: `core/skills/stakeholder-mapping/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/stakeholder-mapping/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
