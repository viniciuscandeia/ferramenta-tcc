---
name: entrevista-estruturada
description: >-
  Para coletar rotinas atuais, frustrações e visão ideal via 4 perguntas estruturadas. Use quando precisa entender como você faz hoje, o que te incomoda, como seria ideal. Use to collect routines, frustrations and ideal vision via structured interview.
---

# Adapter Gemini CLI — entrevista-estruturada

Lógica canônica: `ferramenta-tcc/core/skills/entrevista-estruturada/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. Carregar `ferramenta-tcc/core/constitution.md`
2. Carregar `ferramenta-tcc/core/skills/entrevista-estruturada/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
