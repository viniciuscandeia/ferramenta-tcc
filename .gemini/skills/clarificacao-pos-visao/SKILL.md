---
name: clarificacao-pos-visao
marco: [M1]
description: >-
  Quando há lacunas críticas de escopo, terminologia ou restrições após capturar a visão inicial. Ativada pelo agente quando 2 ou mais categorias têm lacunas críticas. Use when critical gaps remain after milestone 1 vision capture.
---

# Adapter Gemini CLI — clarificacao-pos-visao

Lógica canônica: `core/skills/clarificacao-pos-visao/SKILL.md`

> **Nota:** Gemini CLI não tem first-class skill discovery via manifesto (usa persona adoption).
> Este wrapper é documentação e forward-compat.

## Instruções de execução (Gemini CLI)

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Carregar `core/skills/clarificacao-pos-visao/SKILL.md`
3. Executar skill seguindo as fases e regras definidas no core
4. Usar `ask_user` para toda interação com o usuário (máximo 4 perguntas por chamada)
5. Nunca usar termos da blacklist D1 na comunicação com o usuário
