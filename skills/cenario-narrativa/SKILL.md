---
name: cenario-narrativa
marco: [M2]
description: >-
  Para coletar cenários narrativos um dia normal de perfil e extrair necessidades implícitas. Use quando precisa de me descreva um dia típico, como você usaria o sistema no dia a dia. Use to collect day-in-the-life narratives and extract implicit needs.
---

# Adapter Claude Code — cenario-narrativa

Lógica canônica: `core/skills/cenario-narrativa/SKILL.md`

## Instruções de execução (Claude Code)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/cenario-narrativa/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
