---
name: entrevista-estruturada
marco: [M2]
description: >-
  Para coletar rotinas atuais, frustrações e visão ideal via 4 perguntas estruturadas. Use quando precisa entender como você faz hoje, o que te incomoda, como seria ideal. Use to collect routines, frustrations and ideal vision via structured interview.
---

# Adapter Claude Code — entrevista-estruturada

Lógica canônica: `core/skills/entrevista-estruturada/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/entrevista-estruturada/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
