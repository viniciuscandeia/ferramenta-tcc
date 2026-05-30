---
name: necessidade-visao
description: >-
  Captura a necessidade central e a visão do produto em linguagem de negócio — primeira skill do Marco 1.
  Começa pelo problema (5-Whys/JTBD), depois sintetiza a visão e as metas de sucesso.
  Use quando o usuário descreve o que quer construir pela primeira vez ou ao iniciar o projeto.
  Capture core need, product vision and success goals for a layperson stakeholder; problem-first approach.
---

# Adapter Gemini CLI — necessidade-visao

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

Lógica canônica: `core/skills/necessidade-visao/SKILL.md`

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada via GEMINI.md — D15. Não ler em runtime.)_
2. Carregar `core/skills/necessidade-visao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada; 1 por turno na fase de descoberta)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
