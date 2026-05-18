---
name: gherkin-spec
description: >-
  Gera cenários de teste legíveis para cada funcionalidade obrigatória (modal DEVE) — um arquivo por funcionalidade, com caminho feliz e casos de borda.
  Use no Marco 3, após montar o documento de especificação, para criar os arquivos de cenário de teste.
  Generate Gherkin .feature files for DEVE-modal RFs only (D22); 1 file per RF; caminho feliz + up to 2 borders; no user interaction; candidate R5.
---

## Filosofia desta skill (Regras Absolutas)

1. **Filtro D22 é inegociável.** Apenas RFs com modal `DEVE` recebem arquivo `.feature`. DEVERIA e PODE vão para `_skipped.md`. Sem exceção — gerar spec para não-DEVE cria cobertura falsa de requisitos não-obrigatórios.
2. **Sem interação com usuário.** Cenários são derivados 100% dos artefatos de entrada. Nenhuma pergunta durante geração.
3. **RF vago = arquivo `.feature` com placeholder, não omissão.** `[VERIFICAR]` na feature é visível e rastreável. Omitir o arquivo esconde a lacuna.

<HARD-GATE>
- NÃO executar antes de `srs-ireb-template` (Passo 2) concluído
- NÃO executar sem `03.1-funcionais.md` com campo modal preenchido pela `priorizacao` de M2
- ⛔ STOP se `lista_deve` (RFs com DEVE) resultar em 0 itens — verificar se `priorizacao` executou corretamente
</HARD-GATE>

## Fase 0 — Inicialização

1. Carregar `core/constitution.md` (guardrail D1 + Output Discipline)
2. Verificar `03.1-funcionais.md` com campo modal e saída de `requisito-ears` (Passo 1)
3. Separar RFs:
   - `lista_deve`: todos com modal == `DEVE`
   - `lista_outros`: todos com modal == `DEVERIA` ou `PODE`

## Fase 1 — Geração dos `.feature`

Para cada RF em `lista_deve`:

**Nomenclatura do arquivo:**
`spec/<id-rf-lowercase>-<slug-da-descricao>.feature`
Slug: descrição em lowercase, espaços por hífens, sem acentos, máx 40 chars.
Exemplos: `spec/rf-001-cadastro-produto.feature`, `spec/rf-002-enviar-confirmacao.feature`

**Template de arquivo:**
```gherkin
# [ID RF] — [Descrição completa do RF]
# Modal: DEVE | Tipo-EARS: [Ubíquo/Evento/Estado/Opcional/Indesejado]
# Gerado por: ferramenta-tcc (documenter > gherkin-spec)

Feature: [Descrição do RF como título de funcionalidade]
  Como [perfil do usuário de visao-produto-normativo.md]
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
- Máximo 3 Scenarios por `.feature` (1 caminho feliz + até 2 bordas)
- Gherkin em português brasileiro — palavras-chave reservadas (Feature, Scenario, Given, When, Then, And, But, Background) em inglês
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

## Fase 2 — Geração de `spec/_skipped.md`

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

N arquivos em `spec/` (1 por RF-DEVE) + `spec/_skipped.md`.
IDs dos arquivos correspondem exatamente aos IDs de `03.1-funcionais.md` (sem renumeração).

Sinalizar ao `documenter`: gherkin-spec concluído → prosseguir para `step-defs-red` (Passo 4).

<!-- internal -->
## Anti-Padrão: Cenário de Borda Sem Caso Real

**Como acontece:** A skill gera 2 Scenarios de borda obrigatoriamente para "completude", mas o RF-003 ("O sistema DEVE exibir catálogo") não tem caso de borda óbvio. Os Scenarios gerados são genéricos ("catálogo vazio") sem embasamento no domínio do projeto.

**Como detectar:** Scenario de borda com Given/When/Then genéricos que seriam iguais para qualquer RF do mesmo tipo. Borda sem especificidade de domínio = ruído.

**O que fazer:** Bordas são opcionais (até 2, não obrigatórias). Se não há caso de borda óbvio derivável dos artefatos → gerar apenas 1 Scenario (caminho feliz). Melhor 1 Scenario correto que 3 Scenarios com 2 genéricos.
<!-- /internal -->
