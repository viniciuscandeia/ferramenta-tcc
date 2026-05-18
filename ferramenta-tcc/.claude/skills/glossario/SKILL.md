---
name: glossario
description: >-
  Para detectar termos do domínio sem definição clara e construir o glossário do projeto. Use quando há palavras específicas do negócio que podem gerar ambiguidade entre as partes. Use to detect undefined domain terms and build the project glossary.
---

# Adapter Claude Code — glossario

Lógica canônica: `core/skills/glossario/SKILL.md`

## Instruções de execução (Claude Code)

1. Carregar `core/constitution.md`
2. Carregar `core/skills/glossario/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `AskUserQuestion` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
