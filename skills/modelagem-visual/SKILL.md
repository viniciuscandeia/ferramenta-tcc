---
name: modelagem-visual
marco: [M3]
description: >-
  Gera 3 diagramas Mermaid — Contexto do Sistema, Caso de Uso e Entidade-Relacionamento — a partir dos artefatos já produzidos em M1, M2 e M3, sem nenhuma interação com o usuário.
  Use no Marco 3, após requisito-ears, para produzir documentos-tecnicos/03-documento/03.3-diagramas.md. Os diagramas são embutidos nas seções do SRS pelo srs-ireb-montagem (Passo seguinte).
  Generate 3 Mermaid diagrams (context, use-case, ER) from M1/M2 artifacts; no user interaction; output to 03.3-diagramas.md for embedding into SRS sections.
when_to_use: Invocada pelo documenter no Passo 2 do Processo M3 (após requisito-ears, ANTES de srs-ireb-montagem). Entrada: documentos-tecnicos/01-visao/01-visao-produto.md + 02.1-requisitos-funcionais.md + 02.5-glossario.md. Saída: documentos-tecnicos/03-documento/03.3-diagramas.md.
---

## Filosofia desta skill (Regras Absolutas)

1. **Sem input adicional do usuário.** Todos os dados vêm de artefatos já produzidos.
   Diagrama que não pode ser gerado por falta de dado → nota explícita no arquivo de saída. Nunca perguntar ao usuário.
2. **Ausência documentada, nunca silenciosa.** Se um tipo de diagrama não se aplica
   (ex: sem ciclo de vida → sem diagrama de estados), registrar nota explicando.
   Anti-padrão: omitir a seção sem explicação.
3. **Rótulos técnicos no técnico; rótulos de negócio no leigo.** A skill gera ambas
   as versões. A versão técnica pode usar nomes de entidade como no glossário.
   A versão leigo usa exclusivamente linguagem de negócio (sem jargão da blacklist D1).
4. **Mermaid válido é obrigatório.** Qualquer bloco com sintaxe inválida bloqueia o
   passo — corrigir antes de salvar. Um bloco inválido que não renderiza é pior que
   a ausência do diagrama.

<HARD-GATE>
- NÃO executar antes de `requisito-ears` concluído — usa os RFs com modal preenchido
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md` (contexto + stakeholders)
- NÃO executar sem `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (caso de uso)
- NÃO executar sem `documentos-tecnicos/02-requisitos/02.5-glossario.md` (ER)
- ⛔ STOP se qualquer bloco Mermaid gerado falhar na validação de sintaxe antes de salvar
- Executar ANTES de `srs-ireb-montagem` — os diagramas são embutidos no SRS pelo próximo passo
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar artefatos obrigatórios:
   - `documentos-tecnicos/01-visao/01-visao-produto.md` (seções: Contexto e Limites, Pessoas Envolvidas, Visão)
   - `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (RFs com modal preenchido)
   - `documentos-tecnicos/02-requisitos/02.5-glossario.md` (termos do domínio)
3. Carregar opcionais se existirem: `documentos-tecnicos/02-requisitos/02.3-restricoes.md` (sistemas externos)
4. Registrar: `nome_produto`, `perfis_onion` (camada 1), `integrações_externas`, lista de RFs DEVE, glossário
5. Consultar `content/catalogos-seed/conceitos/modelagem-visual.md` para templates canônicos

## Fase 1 — Diagrama de Contexto (obrigatório)

**Input:** visão-produto.md §Contexto + stakeholders onion camada 1 + restrições externas

1. Extrair nome do produto/sistema
2. Extrair perfis que interagem diretamente (onion camada 1 = "usa")
3. Extrair sistemas externos / integrações de `02.3-restricoes.md` ou da seção de limites
4. Montar `flowchart LR` conforme template do catálogo `modelagem-visual.md §1`

**Verificação de sintaxe:** conferir que todos os IDs de nó são únicos e sem espaços;
rótulos com espaço entre `["..."]`.

## Fase 2 — Diagrama de Caso de Uso (obrigatório)

**Input:** `02.1-requisitos-funcionais.md` (RFs com modal DEVE) × onion camada 1

1. Extrair RFs com modal `DEVE` — são as funcionalidades que ganham caso de uso
2. Para cada RF: identificar o ator principal (quem executa — inferir do contexto ou
   do sujeito do EARS; se ambíguo, usar o perfil principal do onion)
3. Agrupar por ator → montar `flowchart LR` com atores à esquerda e funcionalidades à direita
4. Nomes de funcionalidade: versão curta da descrição do RF, sem sintaxe EARS
   (ex: "O sistema DEVE permitir cadastrar produto" → "Cadastrar produto")

**Limite:** se ≥ 8 funcionalidades, usar `subgraph` por módulo/grupo lógico.

## Fase 3 — Diagrama ER (técnico)

**Input:** `02.5-glossario.md`

1. Extrair substantivos do glossário que representem entidades persistíveis
   (coisas que o sistema armazena: Pedido, Cliente, Produto, Usuário, etc.)
2. Para cada entidade: identificar atributos mencionados no glossário ou nos RFs
   (id, nome, status, data são seguros como padrão)
3. Inferir relacionamentos das definições e dos RFs (ex: "RF-003 — o sistema DEVE
   listar pedidos de um cliente" → relação Cliente ||--o{ Pedido)
4. Montar `erDiagram` conforme template catálogo `§4`

**Condição de omissão:** se glossário tem < 3 substantivos candidatos a entidade →
não gerar ER. Registrar:
```markdown
> **Nota:** Diagrama ER omitido — glossário com menos de 3 entidades
> identificáveis nos artefatos de M2.
```

## Fase 4 — Montar 03.3-diagramas.md

Estrutura do arquivo de saída (3 diagramas técnicos + bloco leigo-safe com 2):

```markdown
# Diagramas do Produto — [Nome do Produto]

> Gerado por: `modelagem-visual` (ferramenta-tcc)
> Motor: Mermaid (renderiza nativamente no GitHub e VSCode)
> Os diagramas abaixo são embutidos nas seções do documento de requisitos pelo próximo passo.

---

## 1. Contexto do Sistema

> Mostra onde o produto se encaixa: quem usa e com quais outros sistemas ele se
> comunica.
> Destinado à Seção 2.1 do documento de requisitos.

[bloco mermaid contexto]

---

## 2. Caso de Uso — O que o Sistema Faz

> Mostra as funcionalidades principais e quem as executa.
> Destinado à Seção 3 do documento de requisitos.

[bloco mermaid caso de uso]

---

## 3. Estrutura de Dados (Entidade-Relacionamento)

> Mostra as informações que o sistema armazena e como se relacionam.
> Versão técnica — destinada à Seção 4 do documento de requisitos.

[bloco mermaid erDiagram | ou nota de omissão]

---

<!-- LEIGO-SAFE-START -->
## Como o produto funciona

### Quem usa e o que o produto faz

> [rótulos em linguagem de negócio]

[bloco mermaid contexto com rótulos leigo-safe]

### O que cada pessoa pode fazer

> [rótulos em linguagem de negócio]

[bloco mermaid caso de uso com rótulos leigo-safe]
<!-- LEIGO-SAFE-END -->
```

**Rótulos leigo-safe:** aplicar a transformação da blacklist D1 nos rótulos dos
nós dos 2 diagramas dentro do bloco `<!-- LEIGO-SAFE-START/END -->`.
Ver `content/catalogos-seed/conceitos/modelagem-visual.md §Regras de rotulagem leigo-safe`.

## Fase 5 — Saída e Sinalização

1. Salvar `documentos-tecnicos/03-documento/03.3-diagramas.md` (tamanho esperado: 60–150 linhas)
2. Registrar em `estado-projeto.yaml`: `modelagem_visual_gerada: true`
3. Sinalizar ao `documenter`: `modelagem-visual concluída → prosseguir para srs-ireb-montagem (Passo 3)`

<!-- internal -->
## Futuro — Diagramas de Caso de Uso por Módulo (item 13 do feedback)

Melhoria futura: gerar um diagrama de caso de uso por módulo de requisitos (§3.X do SRS),
em vez de um único diagrama global. Requer que o agrupamento de módulos (srs-ireb-montagem)
seja executado primeiro e que o diagrama receba os módulos como subgraphs.
Não implementar agora — registrar como ponto de evolução para a próxima versão.
<!-- /internal -->

<!-- internal -->
## Anti-Padrão: Diagrama Vazio sem Nota

**Como acontece:** Fase 3 (ER) encontra glossário pequeno e salva uma seção vazia
(apenas o heading `## 3. Estrutura de Dados` sem conteúdo ou bloco).

**Como detectar:** Seção presente no arquivo sem bloco `mermaid` nem nota de omissão.

**O que fazer:** Toda seção sem diagrama DEVE ter uma nota de omissão explícita
(`> **Nota:** ... omitido — [motivo]`). Nunca deixar seção vazia.

## Anti-Padrão: Rótulos EARS no Diagrama

**Como acontece:** Skill copia a descrição EARS do RF diretamente como rótulo do nó:
`"O sistema DEVE permitir que o usuário cadastre um produto com nome e preço"`.

**Como detectar:** Rótulo com `DEVE`, `DEVERIA`, `PODE` ou sintaxe `[Sujeito] DEVE [verbo]`.

**O que fazer:** Extrair só o verbo + objeto: "Cadastrar produto com nome e preço".
Na versão leigo: "Adicionar produto".
<!-- /internal -->
