---
name: recomendacao-implicitos
description: >-
  Para sugerir requisitos implícitos como login, segurança, notificações, auditoria — o óbvio não-dito. Use para confirmar você precisa de controle de acesso, quer receber alertas. Use to surface implicit requirements not yet mentioned by the stakeholder.
---

# Adapter Claude Code — recomendacao-implicitos

Lógica canônica: `core/skills/recomendacao-implicitos/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/recomendacao-implicitos/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
