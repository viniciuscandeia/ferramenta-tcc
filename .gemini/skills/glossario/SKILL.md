---
name: glossario
description: >-
  Para detectar termos do domínio sem definição clara e construir o glossário do projeto. Use quando há palavras específicas do negócio que podem gerar ambiguidade entre as partes. Use to detect undefined domain terms and build the project glossary.
---

# Adapter Gemini CLI — glossario

Lógica canônica: `ferramenta-tcc/core/skills/glossario/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/glossario/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
