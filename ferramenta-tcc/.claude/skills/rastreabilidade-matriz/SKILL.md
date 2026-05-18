---
name: rastreabilidade-matriz
description: >-
  Para gerar a matriz de rastreabilidade que conecta objetivos de negócio, requisitos, SRS, specs e testes. Operação do checker no Marco 3. Use to generate bidirectional traceability matrix linking business goals to test artifacts.
---

# Adapter Claude Code — rastreabilidade-matriz

Lógica canônica: `ferramenta-tcc/core/skills/rastreabilidade-matriz/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/rastreabilidade-matriz/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
