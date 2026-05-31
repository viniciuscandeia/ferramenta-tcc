---
name: modelagem-visual
marco: [M3]
description: >-
  Gera diagramas Mermaid cobrindo as 3 perspectivas de modelagem IREB (estrutural/dados, funcional/atividade, comportamental/estados) mais contexto de sistema e caso de uso — a partir dos artefatos já produzidos em M1, M2 e M3, sem nenhuma interação com o usuário.
  Use no Marco 3, após gherkin-spec, para produzir documentos-tecnicos/03-documento/03.3-diagramas.md e o subconjunto leigo-safe consumido por traducao-gate.
  Generate Mermaid diagrams covering IREB modeling perspectives (structural, functional, behavioral) + context + use case from M1/M2/M3 artifacts; no user interaction; output to 03.3-diagramas.md.
when_to_use: Invocada pelo documenter no Passo 3.5 do Processo M3 (após gherkin-spec, antes de step-defs-red). Entrada: documentos-tecnicos/01-visao/01-visao-produto.md + 02.1-requisitos-funcionais.md + 02.5-glossario.md + 04-spec/*.feature. Saída: documentos-tecnicos/03-documento/03.3-diagramas.md.
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
- NÃO executar antes de `gherkin-spec` (Passo 3) concluído — usa `04-spec/*.feature` para derivar o fluxo
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md` (contexto + stakeholders)
- NÃO executar sem `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (caso de uso)
- NÃO executar sem `documentos-tecnicos/02-requisitos/02.5-glossario.md` (ER)
- ⛔ STOP se qualquer bloco Mermaid gerado falhar na validação de sintaxe antes de salvar
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar artefatos obrigatórios:
   - `documentos-tecnicos/01-visao/01-visao-produto.md` (seções: Contexto e Limites, Pessoas Envolvidas, Visão)
   - `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (RFs com modal preenchido)
   - `documentos-tecnicos/02-requisitos/02.5-glossario.md` (termos do domínio)
   - `documentos-tecnicos/03-documento/04-spec/` (pelo menos 1 `.feature`)
3. Carregar opcionais se existirem: `documentos-tecnicos/02-requisitos/02.3-restricoes.md` (sistemas externos)
4. Registrar: `nome_produto`, `perfis_onion` (camada 1), `integrações_externas`, lista de RFs DEVE, glossário, cenários Gherkin
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

## Fase 3 — Diagrama de Fluxo/Atividade (obrigatório)

**Input:** `04-spec/*.feature` — cenário "caminho feliz" do RF DEVE de maior prioridade

1. Selecionar o RF DEVE com modal prioritário (primeiro na lista ou explicitar o motivo)
2. Extrair passos do cenário "caminho feliz":
   - `Background` / `Given` → pré-condição (nó retangular antes da ação)
   - `When` → ação do usuário (nó retangular)
   - `And` após `When` → passos intermediários
   - `Then` → resultado esperado (nó retangular)
3. Se houver `Scenario Outline` com variações → identificar o caminho padrão
4. Se houver decisão implícita (ex: "usuário com permissão / sem permissão") →
   incluir losango de decisão com os dois caminhos
5. Montar `flowchart TD` conforme template catálogo `§3`

**Fallback:** se `04-spec/` estiver vazio ou sem caminho feliz claro → usar narrativa
de `cenario-narrativa` ou derivar do RF mais descritivo. Registrar no arquivo qual
fonte foi usada.

## Fase 4 — Diagrama ER (técnico)

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

## Fase 5 — Diagrama de Estados (técnico, condicional)

**Input:** `02.1-requisitos-funcionais.md` + `02.5-glossario.md`

1. Buscar padrões de ciclo de vida:
   - Verbos que implicam transição: cancelar, aprovar, publicar, arquivar, expirar,
     ativar, suspender, finalizar, confirmar, rejeitar
   - Campos de status no glossário (ex: "status: ativo | inativo | suspenso")
   - RFs do tipo "O sistema DEVE permitir cancelar [entidade]"
2. Se ≥ 1 entidade com ciclo de vida identificável → gerar `stateDiagram-v2`
   por entidade (máx 2; se mais, priorizar a mais central ao produto)
3. Se nenhum ciclo de vida → registrar nota e omitir:
   ```markdown
   > **Nota:** Diagrama de estados omitido — nenhum ciclo de vida de entidade
   > identificado nos artefatos de M1/M2.
   ```

## Fase 6 — Montar 03.3-diagramas.md

Estrutura do arquivo de saída:

```markdown
# Diagramas do Projeto — [Nome do Produto]

> Gerado por: `modelagem-visual` (ferramenta-tcc)
> Base normativa: IREB §3 perspectivas de modelagem + ISO 29148 (contexto e casos de uso)
> Motor: Mermaid (renderiza nativamente no GitHub e VSCode)

---

## 1. Contexto do Sistema

> Mostra onde o sistema se encaixa: quem usa e com quais outros sistemas ele se
> comunica.

[bloco mermaid contexto]

---

## 2. Caso de Uso — O que o Sistema Faz

> Mostra as funcionalidades principais e quem as executa.

[bloco mermaid caso de uso]

---

## 3. Fluxo Principal — [Nome do RF ou Processo]

> Passo a passo do processo mais importante do sistema.
> Baseado em: [ID do RF].

[bloco mermaid fluxo]

---

## 4. Estrutura de Dados (Entidade-Relacionamento)

> Mostra as informações que o sistema armazena e como se relacionam.
> Versão técnica — destinada à equipe de desenvolvimento.

[bloco mermaid erDiagram | ou nota de omissão]

---

## 5. Ciclo de Vida — [Nome da Entidade(s)]

> Mostra os estados pelos quais [entidade] passa durante o uso do sistema.
> Versão técnica — destinada à equipe de desenvolvimento.

[bloco mermaid stateDiagram-v2 | ou nota de omissão]

---

<!-- LEIGO-SAFE-START -->
## Como o sistema funciona

### Quem usa e o que o sistema faz

> [rótulos em linguagem de negócio]

[bloco mermaid contexto com rótulos leigo-safe]

### O que cada pessoa pode fazer

> [rótulos em linguagem de negócio]

[bloco mermaid caso de uso com rótulos leigo-safe]

### Como o fluxo principal funciona

> [rótulos em linguagem de negócio]

[bloco mermaid fluxo com rótulos leigo-safe]
<!-- LEIGO-SAFE-END -->
```

**Rótulos leigo-safe:** aplicar a transformação da blacklist D1 nos rótulos dos
nós dos 3 diagramas dentro do bloco `<!-- LEIGO-SAFE-START/END -->`.
Ver `content/catalogos-seed/conceitos/modelagem-visual.md §Regras de rotulagem leigo-safe`.

## Fase 7 — Saída e Sinalização

1. Salvar `documentos-tecnicos/03-documento/03.3-diagramas.md` (tamanho esperado: 80–200 linhas)
2. Registrar em `estado-projeto.yaml`: `modelagem_visual_gerada: true`
3. Sinalizar ao `documenter`: `modelagem-visual concluída → prosseguir para step-defs-red (Passo 4)`

<!-- internal -->
## Anti-Padrão: Diagrama Vazio sem Nota

**Como acontece:** Fase 4 (ER) encontra glossário pequeno e salva uma seção vazia
(apenas o heading `## 4. Estrutura de Dados` sem conteúdo ou bloco).

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
