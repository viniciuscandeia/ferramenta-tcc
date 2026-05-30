---
name: necessidade-visao
description: >-
  Captura a necessidade central e a visão do produto em linguagem de negócio — primeira skill do Marco 1.
  Começa pelo problema (5-Whys/JTBD), depois sintetiza a visão e as metas de sucesso.
  Use quando o usuário descreve o que quer construir pela primeira vez ou ao iniciar o projeto.
  Capture core need, product vision and success goals for a layperson stakeholder; problem-first approach.
---

# Adapter Claude Code — necessidade-visao

Lógica canônica: `core/skills/necessidade-visao/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada inline — D15. Não ler em runtime.)_
2. Carregar `core/skills/necessidade-visao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada; 1 por turno na fase de descoberta)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
