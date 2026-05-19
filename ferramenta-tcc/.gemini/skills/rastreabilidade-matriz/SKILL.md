---
name: rastreabilidade-matriz
marco: [M3]
description: >-
  Para gerar a matriz de rastreabilidade que conecta objetivos de negócio, requisitos, SRS, specs e testes. Operação do checker no Marco 3. Use to generate bidirectional traceability matrix linking business goals to test artifacts.
---

# Adapter Gemini CLI — rastreabilidade-matriz

Lógica canônica: `core/skills/rastreabilidade-matriz/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/rastreabilidade-matriz/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
