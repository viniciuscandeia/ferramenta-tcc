---
name: classificacao-rf-rnf
marco: [M2]
description: >-
  Para classificar itens coletados em o que faz, como se comporta, restrições e premissas do projeto. Use após elicitação completa para organizar tudo que foi descoberto. Use to classify collected items into functional, quality requirements, constraints and assumptions.
---

# Adapter Claude Code — classificacao-rf-rnf

Lógica canônica: `core/skills/classificacao-rf-rnf/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/classificacao-rf-rnf/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
