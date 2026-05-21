---
name: iniciar-projeto
description: Inicia ou retoma o processo de documentação de requisitos do projeto
---

## Inicialização do plugin (passo obrigatório)

Antes de qualquer outra ação:
1. Ler `~/.claude/plugins/installed_plugins.json` via Read tool
2. Extrair `plugins["ferramenta-tcc@ferramenta-tcc"][0].installPath` → guardar mentalmente como **PLUGIN_ROOT** para toda esta sessão
3. Todas as referências `core/X` neste skill e nos arquivos carregados = `{PLUGIN_ROOT}/core/X`

## Execução

Ler e executar `{PLUGIN_ROOT}/core/orchestrator.md`.

O orquestrador irá:
1. (Constitution já injetada inline — D15. Não ler em runtime.)
2. Verificar estado do projeto (`estado-projeto.yaml` ou detection-based)
3. Identificar `marco_corrente` e carregar EXCLUSIVAMENTE `{PLUGIN_ROOT}/core/marcos/{marco_corrente}.md`
4. Conduzir o usuário pelas fases de documentação com perguntas estruturadas via AskUserQuestion

Nota Claude Code: Sub-agentes invocados via Agent tool recebem PLUGIN_ROOT no prompt de invocação para que possam acessar `{PLUGIN_ROOT}/core/agents/<nome>.md`.

Filtragem de skills por marco (C0):
- Antes de invocar qualquer Agent ou Skill, verificar `estado-projeto.yaml.marco_corrente`
- Invocar APENAS skills cujo campo `marco:` no frontmatter inclua o marco corrente
- Skills transversais (traducao-leigo, traducao-gate) têm marco: [M1, M2, M3] — sempre disponíveis

Sequência canônica (C1): Executar skills na ordem definida em `{PLUGIN_ROOT}/core/marcos/{marco_corrente}.md`
chamando cada skill por nome explícito antes de aguardar auto-invocação.