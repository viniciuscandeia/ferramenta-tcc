# testes_gemini — Evidência de Execução da Ferramenta-TCC no Gemini CLI

**Finalidade:** documentar execuções da ferramenta-tcc no Gemini CLI para o TCC de Vinicius Candeia, incluindo análise de conformidade, causas-raiz de falha e comparação com outras soluções de mercado.

**Localização:** `~/Desktop/TCC/testes_gemini/` — raiz do monorepo, **fora** do repo público (não vai para GitHub via `git subtree`).

---

## Veredicto da Execução 01

A execução gerou artefatos semanticamente corretos (conteúdo de domínio plausível, linguagem leigo adequada), mas **reprovada por não-conformidade arquitetural** com a especificação canônica da ferramenta.

**Causa-raiz principal:** bug conhecido do Gemini CLI ([issue #21968](https://github.com/google-gemini/gemini-cli/issues/21968)) — skills e sub-agentes não são invocados automaticamente por description-matching, apenas quando instruídos explicitamente. A ferramenta-tcc depende fortemente desse contrato.

**Impacto:** ~10 artefatos obrigatórios ausentes, 4 arquivos com nomes fora do canônico, pipeline técnico de M3 inteiro ignorado (specs, testes, TESTING-STRATEGY, README-TESTS), loops M2/M3 não iteraram, `estado-projeto.yaml` inconsistente com os artefatos em disco.

---

## Estrutura

```
testes_gemini/
├── README.md                                   ← este arquivo
├── execucao-01-treinos-musculacao/
│   ├── artefatos-gerados/                      ← cópia dos arquivos produzidos pela ferramenta
│   ├── inventario-vs-canonico.md               ← tabela gerado vs. esperado por marco
│   ├── analise-causa-raiz.md                   ← causa-raiz técnica + evidência (issues, docs)
│   ├── comparativo-outros-plugins.md           ← como outros sistemas resolvem o mesmo problema
│   └── notas.md                                ← condições da execução e observações
└── analise-cross-platform/
    ├── gemini-cli-limitacoes.md                ← limitações conhecidas do Gemini CLI para skills/agents
    ├── claude-code-equivalentes.md             ← como Claude Code mitiga as mesmas fraquezas
    └── recomendacoes-arquiteturais.md          ← mudanças propostas para a ferramenta-tcc
```

---

## Domínio testado

App de organização de treinos de musculação. Usuário ainda não definiu nome do produto (campo placeholder na execução).

## Data da execução

2026-05-20 (ver `notas.md` para detalhes de versão do CLI).

## Original preservado

Os artefatos originais permanecem em `~/Desktop/Teste/` intocados. A pasta `artefatos-gerados/` é cópia bit-a-bit para fins de evidência permanente.
