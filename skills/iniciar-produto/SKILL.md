---
name: iniciar-produto
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
description: Inicia ou retoma o processo de documentação de requisitos do projeto
---

## Inicialização do plugin (passo obrigatório)

Antes de qualquer outra ação:
1. Ler `~/.claude/plugins/installed_plugins.json` via Read tool
2. Extrair `plugins["ferramenta-tcc@ferramenta-tcc"][0].installPath` → guardar mentalmente como **PLUGIN_ROOT** para toda esta sessão
3. Todas as referências a arquivos do plugin = `{PLUGIN_ROOT}/<arquivo>`
   - Auto-descobertos pelo CC: `skills/`, `agents/`, `hooks/hooks.json`
   - Conteúdo custom (não auto-descoberto): `content/orchestrator.md`, `content/constitution.md`, `content/marcos/`, `content/workflows/`, `content/catalogos-seed/`, `content/templates/`

## Execução

Ler e executar `{PLUGIN_ROOT}/content/orchestrator.md`.

O orquestrador irá:
1. Ler `{PLUGIN_ROOT}/content/constitution.md` e internalizar as regras D1/D3/D14/D15 como invioláveis.
2. Verificar estado do projeto (`estado-projeto.yaml` ou detection-based)
3. Identificar `marco_corrente` e carregar EXCLUSIVAMENTE `{PLUGIN_ROOT}/content/marcos/{marco_corrente}.md`
4. Conduzir o usuário pelas fases de documentação com perguntas estruturadas via AskUserQuestion

Nota D25: Sub-agentes NÃO são invocados via Agent/Task() tool — subagentes não têm acesso a `AskUserQuestion` (restrição documentada da plataforma: code.claude.com/docs/en/sub-agents), e toda elicitação depende dela. O orquestrador lê `{PLUGIN_ROOT}/agents/<nome>.md` como persona inline no mesmo contexto.

Filtragem de skills por marco (C0):
- Antes de invocar qualquer Agent ou Skill, verificar `estado-projeto.yaml.marco_corrente`
- Invocar APENAS skills cujo campo `marco:` no frontmatter inclua o marco corrente
- Skills transversais (traducao-leigo, traducao-gate) têm marco: [M1, M2, M3] — sempre disponíveis
- Exceção (utilitárias/entrada): `iniciar-produto`, `faq-inicial` e `exportar-pdf` podem ser invocadas a pedido do usuário em qualquer ponto do fluxo

Sequência canônica (C1): Executar skills na ordem definida em `{PLUGIN_ROOT}/content/marcos/{marco_corrente}.md`
chamando cada skill por nome explícito antes de aguardar auto-invocação.