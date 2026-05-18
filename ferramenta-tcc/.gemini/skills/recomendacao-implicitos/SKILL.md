---
name: recomendacao-implicitos
description: >-
  Para sugerir requisitos implícitos como login, segurança, notificações, auditoria — o óbvio não-dito. Use para confirmar você precisa de controle de acesso, quer receber alertas. Use to surface implicit requirements not yet mentioned by the stakeholder.
---

# Adapter Gemini CLI — recomendacao-implicitos

Lógica canônica: `ferramenta-tcc/core/skills/recomendacao-implicitos/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/recomendacao-implicitos/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
