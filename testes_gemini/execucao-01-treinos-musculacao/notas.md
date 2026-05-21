# Notas de Execução — Execução 01: Treinos de Musculação

## Condições da execução

- **Data:** 2026-05-20
- **Plataforma:** Gemini CLI
- **Versão do CLI:** não registrada — verificar com `gemini --version` na próxima execução
- **Modelo:** não registrado — verificar nas configurações do CLI
- **Pasta de saída:** `~/Desktop/Teste/`
- **Comando de entrada:** `/iniciar-projeto`
- **Domínio:** app de organização de treinos de musculação
- **Nome do produto:** não definido pelo usuário durante a sessão (placeholder "Ainda não pensei" no `vision-box.md`)

## Observações da execução

- Usuário completou toda a interação até o Marco 4 (aprovação técnica gerada).
- Não houve interrupções reportadas.
- Artefatos foram gerados continuamente na mesma sessão.
- Número exato de turnos/mensagens não registrado — estimar em próximas execuções.

## O que funcionou

- Linguagem leigo adequada (lista-negra D1 respeitada nos documentos voltados ao usuário).
- Conteúdo de domínio coerente: tipos de série (Aquecimento/Reconhecimento/Trabalho), sugestão de carga, cronômetro, sincronização offline-first, identidade visual.
- Fluxo narrativo de usuário capturado em `fluxos.md` — 3 fluxos distintos.
- `pautas-reelicitacao.md` sem itens pendentes (gates nominalmente abertos).

## O que não funcionou

- Nomes de artefatos fora do canônico: `vision-box.md`, `necessidades.md`, `fluxos.md`, `srs.md` — todos explicitamente listados como inválidos nas tabelas canônicas dos marcos.
- Versão leigo + normativa ausentes para todos os marcos (skill `traducao-gate` não invocada).
- Estrutura `03.x` do M2 ausente (9 arquivos esperados, 0 produzidos).
- Pipeline técnico do M3 completamente ausente: specs, testes, TESTING-STRATEGY, README-TESTS.
- `revisao-tecnica.md` ausente, mas `aprovacao-tecnica.md` gerada (M4 pulou pré-requisito).
- `estado-projeto.yaml` inconsistente: Gate 4 marcado como pendente, mas aprovação técnica no disco.

## Hipótese de falha

A ferramenta-tcc foi projetada assumindo que o Gemini CLI invoca skills por description-matching automático. Na prática, o Gemini CLI **não faz isso** (ver `analise-causa-raiz.md`). O orquestrador executou sem invocar as skills responsáveis por padronizar nomes, decompor artefatos e gerar a camada técnica.

## Próximos passos sugeridos

1. Verificar versão do Gemini CLI usada nesta execução.
2. Re-executar após correções C1+C2 (ver `../analise-cross-platform/recomendacoes-arquiteturais.md`).
3. Registrar novas execuções como `execucao-02-*`, `execucao-03-*` etc.
