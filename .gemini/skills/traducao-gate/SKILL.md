---
name: traducao-gate
marco: [M1, M2, M3]
description: >-
  Para gerar duas versões de artefatos de confirmação de fase — versão técnica normativa e versão em linguagem acessível para aprovação do usuário. Use at milestone gates to generate both normative and layperson versions of artifacts.
---

# Adapter Gemini CLI — traducao-gate

Lógica canônica: `core/skills/traducao-gate/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/traducao-gate/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
