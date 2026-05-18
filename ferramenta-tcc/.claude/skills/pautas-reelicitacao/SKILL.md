---
name: pautas-reelicitacao
description: >-
  Para identificar lacunas nos artefatos de M2 que impedem avançar para a próxima confirmação de fase. Operação interna sem interação com o usuário. Use to identify gaps in milestone 2 artifacts that block the gate.
---

# Adapter Claude Code — pautas-reelicitacao

Lógica canônica: `ferramenta-tcc/core/skills/pautas-reelicitacao/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/pautas-reelicitacao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
