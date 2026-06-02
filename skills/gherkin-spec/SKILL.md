---
name: gherkin-spec
marco: [M3]
description: >-
  Gera cenários de teste legíveis para cada funcionalidade obrigatória (modal DEVE) — um arquivo por funcionalidade, com caminho feliz e casos de borda.
  Use no Marco 3, após montar o documento de especificação, para criar os arquivos de cenário de teste.
  Generate Gherkin .feature files for DEVE-modal RFs only (D22); 1 file per RF; adequate coverage (Background, Scenario Outline+Examples, Rule, @tags supported); no user interaction; candidate R5.
---

## Filosofia desta skill (Regras Absolutas)

1. **Filtro D22 é inegociável.** Apenas RFs com modal `DEVE` recebem arquivo `.feature`. DEVERIA e PODE vão para `_skipped.md`. Sem exceção — gerar spec para não-DEVE cria cobertura falsa de requisitos não-obrigatórios.
2. **Sem interação com usuário.** Cenários são derivados 100% dos artefatos de entrada. Nenhuma pergunta durante geração.
3. **RF vago = arquivo `.feature` com placeholder, não omissão.** `[VERIFICAR]` na feature é visível e rastreável. Omitir o arquivo esconde a lacuna.

<HARD-GATE>
- NÃO executar antes de `srs-ireb-montagem` (Passo 2) concluído
- NÃO executar sem `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` com campo modal preenchido pela `priorizacao` de M2
- ⛔ STOP se `lista_deve` (RFs com DEVE) resultar em 0 itens — verificar se `priorizacao` executou corretamente
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` com campo modal e saída de `requisito-ears` (Passo 1)
3. Separar RFs:
   - `lista_deve`: todos com modal == `DEVE`
   - `lista_outros`: todos com modal == `DEVERIA` ou `PODE`

## Fase 1 — Geração dos `.feature`

Para cada RF em `lista_deve`:

**Nomenclatura do arquivo:**
`documentos-tecnicos/03-documento/04-spec/<id-rf-lowercase>-<slug-da-descricao>.feature`
Slug: descrição em lowercase, espaços por hífens, sem acentos, máx 40 chars.
Exemplos: `documentos-tecnicos/03-documento/04-spec/rf-001-cadastro-produto.feature`, `documentos-tecnicos/03-documento/04-spec/rf-002-enviar-confirmacao.feature`

**Template de arquivo:**
```gherkin
# [ID RF] — [Descrição completa do RF]
# Modal: DEVE | Tipo-EARS: [Ubíquo/Evento/Estado/Opcional/Indesejado]
# Gerado por: ferramenta-tcc (documenter > gherkin-spec)

Feature: [Descrição do RF como título de funcionalidade]
  Como [perfil do usuário de documentos-tecnicos/01-visao/01-visao-produto.md]
  Quero [ação principal do RF]
  Para que [objetivo ou benefício]

  Scenario: Caminho feliz — [nome descritivo]
    Given [precondição — estado inicial]
    When [ação do usuário ou evento que dispara o RF]
    Then [resultado verificável]

  Scenario: Borda — [nome descritivo, se aplicável]
    Given [precondição diferente]
    When [ação de borda]
    Then [resultado esperado para borda]
```

**Regras de cenário:**
- Usar condição EARS (do `requisito-ears`) para construir o Given do Evento/Estado/Indesejado
- Cobertura adequada ao RF: caminho feliz + bordas relevantes + cenários de erro. Sem teto rígido. Usar `Scenario Outline + Examples` quando há combinatória de dados (ex: múltiplos tipos de input inválido)
- Gherkin em português brasileiro — palavras-chave reservadas (Feature, Scenario, Scenario Outline, Background, Examples, Rule, Given, When, Then, And, But) em inglês; tags com `@` em lowercase-hyphen (ex: `@smoke`, `@regression`, `@gate-3`)
- RF com descrição vaga → gerar `.feature` com comentário `[VERIFICAR]` e 1 Scenario placeholder

**Exemplos concretos:**
```gherkin
# RF-001 — O sistema DEVE permitir cadastro de produto
# Modal: DEVE | Tipo-EARS: Ubíquo
Feature: Cadastro de produto
  Como administrador do catálogo
  Quero cadastrar novos produtos no sistema
  Para que estejam disponíveis para os clientes

  Scenario: Caminho feliz — cadastro com todos os campos obrigatórios
    Given que o administrador está autenticado no sistema
    When o administrador preenche nome, preço e categoria e confirma o cadastro
    Then o produto é salvo com sucesso e aparece na listagem do catálogo

  Scenario: Borda — tentativa de cadastro com campo obrigatório em branco
    Given que o administrador está autenticado no sistema
    When o administrador tenta confirmar o cadastro sem preencher o nome do produto
    Then o sistema exibe mensagem de erro indicando o campo obrigatório ausente
```

## Construtos Gherkin avançados

### Background — pré-condições compartilhadas

Usar quando 2+ Scenarios da mesma feature partilham exatamente o mesmo Given. Evita repetição.

```gherkin
Feature: Gerenciamento de estoque
  Como gerente de loja
  Quero controlar o nível de estoque dos produtos
  Para evitar rupturas ou excessos

  Background:
    Given que o gerente está autenticado
    And que o produto "Caneta Azul" existe no catálogo com estoque 50

  Scenario: Ajuste de estoque com quantidade válida
    When o gerente ajusta o estoque para 80 unidades
    Then o estoque é atualizado para 80 e a alteração é registrada no histórico

  Scenario: Tentativa de ajuste com quantidade negativa
    When o gerente tenta definir o estoque para -5 unidades
    Then o sistema recusa e exibe "Quantidade não pode ser negativa"
```

### Scenario Outline + Examples — dados tabulados

Usar quando o mesmo fluxo precisa ser testado com múltiplos conjuntos de dados. Substitui cópia de Scenarios com valores diferentes.

```gherkin
  Scenario Outline: Validação de campo <campo> obrigatório
    Given que o formulário de cadastro está aberto
    When o usuário submete o formulário sem preencher <campo>
    Then o sistema exibe a mensagem "<mensagem>"

    Examples:
      | campo   | mensagem                          |
      | nome    | "Nome é obrigatório"              |
      | e-mail  | "E-mail é obrigatório"            |
      | senha   | "Senha deve ter mínimo 8 dígitos" |
```

### Rule — agrupamento por regra de negócio

Disponível em Cucumber 6+. Usar quando uma feature contém múltiplas regras de negócio distintas e é mais claro agrupá-las.

```gherkin
Feature: Política de desconto
  Como comprador
  Quero ver descontos aplicados ao meu pedido
  Para saber o valor final

  Rule: Desconto de fidelidade se ≥ 5 pedidos anteriores
    @smoke
    Scenario: Cliente fidelizado recebe 10% de desconto
      Given que o cliente tem 6 pedidos anteriores
      When visualiza o resumo do pedido
      Then o desconto de 10% é exibido no total

  Rule: Sem desconto para cliente novo
    Scenario: Cliente novo não recebe desconto
      Given que o cliente tem 0 pedidos anteriores
      When visualiza o resumo do pedido
      Then o total é exibido sem desconto
```

### Tags — filtros de execução

Adicionar tags antes de `Feature:` ou `Scenario:` para classificar e filtrar:

| Tag | Quando usar |
|---|---|
| `@smoke` | Cenário crítico de validação rápida |
| `@regression` | Cenário de regressão completa |
| `@gate-3` | Cenário a ser verificado no Gate 3 |
| `@wip` | Cenário em desenvolvimento (a ignorar em CI) |

Exemplo:
```gherkin
@smoke @regression
Feature: Login de usuário

  @gate-3
  Scenario: Login com credenciais válidas
    Given que o usuário está na tela de login
    When informa e-mail e senha corretos
    Then é redirecionado para a tela inicial
```

## Fase 2 — Geração de `documentos-tecnicos/03-documento/04-spec/_skipped.md`

Criar sempre (mesmo vazio) para transparência e rastreabilidade:

```markdown
# Requisitos sem especificação Gherkin

RFs com modal DEVERIA ou PODE não recebem spec Gherkin nesta fase (RFC 2119 — não-obrigatórios).

| RF ID | Modal | Descrição | Razão |
|---|---|---|---|
| RF-004 | DEVERIA | ... | Modal não-obrigatório (RFC 2119 SHOULD) |
| RF-007 | PODE | ... | Modal opcional (RFC 2119 MAY) |
```

## Fase 3 — Saída

N arquivos em `documentos-tecnicos/03-documento/04-spec/` (1 por RF-DEVE) + `documentos-tecnicos/03-documento/04-spec/_skipped.md`.
IDs dos arquivos correspondem exatamente aos IDs de `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (sem renumeração).

Sinalizar ao `documenter`: gherkin-spec concluído → prosseguir para `step-defs-red` (Passo 4).

<!-- internal -->
## Anti-Padrão: Cenário de Borda Sem Caso Real

**Como acontece:** Sem teto de Scenarios, a skill pode gerar bordas genéricas para "aparentar completude" — RF-003 ("O sistema DEVE exibir catálogo") não tem caso de borda óbvio, mas o agente gera "catálogo vazio" sem embasamento no domínio do projeto.

**Como detectar:** Scenario de borda com Given/When/Then genéricos que seriam iguais para qualquer RF do mesmo tipo. Borda sem especificidade de domínio = ruído.

**O que fazer:** Bordas são opcionais (até 2, não obrigatórias). Se não há caso de borda óbvio derivável dos artefatos → gerar apenas 1 Scenario (caminho feliz). Melhor 1 Scenario correto que 3 Scenarios com 2 genéricos.
<!-- /internal -->
