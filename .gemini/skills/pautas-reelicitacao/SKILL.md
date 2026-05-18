---
name: pautas-reelicitacao
description: >-
  Para identificar lacunas nos artefatos de M2 que impedem avançar para a próxima confirmação de fase. Operação interna sem interação com o usuário. Use to identify gaps in milestone 2 artifacts that block the gate.
---

# Adapter Gemini CLI — pautas-reelicitacao

Lógica canônica: `core/skills/pautas-reelicitacao/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/pautas-reelicitacao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
