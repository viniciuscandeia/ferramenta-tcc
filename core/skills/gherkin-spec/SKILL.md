---
name: gherkin-spec
description: Gera arquivos .feature Gherkin para cada RF com modal DEVE (RFC 2119 MUST). RFs com modal DEVERIA ou PODE são listados em spec/_skipped.md com justificativa. 1 arquivo .feature por RF-DEVE com nome <id-rf>-<slug-descricao>.feature. Cada feature tem Feature: + ≥ 1 Scenario (caminho feliz) + até 2 Scenarios borda. Referências: D20, D22.
when_to_use: Invocada pelo documenter como Passo 3 do Processo M3. Depende de srs-ireb-template (Passo 2) ter executado. Entrada obrigatória: 03.1-funcionais.md com campo modal preenchido (DEVE/DEVERIA/PODE) pela priorizacao de M2.
---

# Skill: gherkin-spec

**Referências:** Gherkin — Cucumber Documentation · RFC 2119 · D20 (testes em estado RED) · D22 (filtro modal DEVE)
**Marco:** M3 — Detalhamento (Passo 3)
**Invocada por:** `documenter`

---

## FILTRO RÍGIDO (D22)

Esta skill aplica um filtro binário sobre `03.1-funcionais.md`:

| Modal do RF | Ação |
|---|---|
| `DEVE` | Gerar arquivo `.feature` na pasta `spec/` |
| `DEVERIA` | Registrar em `spec/_skipped.md` com justificativa |
| `PODE` | Registrar em `spec/_skipped.md` com justificativa |

**Justificativa do filtro:** RFC 2119 distingue MUST (obrigatório) de SHOULD/MAY (não-obrigatórios). Specs Gherkin executáveis são geradas apenas para requisitos obrigatórios — os demais ficam documentados em `_skipped.md` para transparência e possível cobertura futura.

---

## PROCESSO

### Entrada

- `03.1-funcionais.md` — lista completa de RFs com campo modal preenchido (DEVE/DEVERIA/PODE)
- Saída de `requisito-ears` (Passo 1) — RFs já decompostos em Sujeito/Verbo/Objeto/Condição/Tipo-EARS

### Passos de execução

**Passo 1 — Separar RFs por modal**
- Ler todos os RFs de `03.1-funcionais.md`
- Construir duas listas:
  - `lista_deve`: todos os RFs com modal == DEVE
  - `lista_outros`: todos os RFs com modal == DEVERIA ou PODE

**Passo 2 — Gerar `.feature` para cada RF da lista_deve**
- Para cada RF em `lista_deve`:
  - Derivar nome de arquivo: `spec/<id-rf-lowercase>-<slug-da-descricao>.feature`
  - Slug: descrição em lowercase, espaços por hífens, sem acentos, máximo 40 caracteres
  - Escrever Feature + ≥ 1 Scenario de caminho feliz + até 2 Scenarios de borda (quando aplicável)
  - Usar padrão EARS para construir o contexto do Given (estado inicial = condição EARS se houver)
  - Se a descrição for muito vaga para compor Given/When/Then → marcar com `[VERIFICAR]` no comentário da Feature

**Passo 3 — Gerar `spec/_skipped.md`**
- Criar sempre (mesmo que vazio) para transparência
- Registrar todos os RFs de `lista_outros` com: ID | Modal | Descrição | Razão

**Passo 4 — Sem interação com usuário**
- Todos os cenários são derivados automaticamente dos artefatos de entrada
- Nenhuma pergunta ao usuário ou ao orquestrador durante esta skill

---

## ESTRUTURA DE CADA ARQUIVO .feature

### Convenção de nomenclatura

```
spec/rf-001-cadastro-produto.feature
spec/rf-002-enviar-confirmacao.feature
spec/rf-007-autenticar-usuario.feature
```

Regras de slug:
- ID em lowercase: `rf-001`, `rf-002`...
- Slug da descrição: primeiras palavras significativas, sem acentos, hifenizadas
- Exemplo: "Permitir cadastro de produto com variantes" → `cadastro-produto`

### Template de arquivo .feature

```gherkin
# [ID RF] — [Descrição completa do RF]
# Modal: DEVE | Tipo-EARS: [Ubíquo/Evento/Estado/Opcional/Indesejado]
# Gerado por: ferramenta-tcc (documenter > gherkin-spec)

Feature: [Descrição do RF como título de funcionalidade]
  Como [perfil do usuário — extraído de visao-produto-normativo.md]
  Quero [ação principal do RF]
  Para que [objetivo ou benefício]

  Scenario: Caminho feliz — [nome descritivo do caso principal]
    Given [precondição — estado inicial do sistema antes da ação]
    When [ação do usuário ou evento externo que dispara o RF]
    Then [resultado esperado — comportamento verificável do sistema]

  Scenario: Borda — [nome descritivo do caso de borda 1, se aplicável]
    Given [precondição diferente do caminho feliz]
    When [ação que representa o caso de borda]
    Then [resultado esperado para o caso de borda]

  Scenario: Borda — [nome descritivo do caso de borda 2, se aplicável]
    Given [outra precondição de borda]
    When [ação de borda]
    Then [resultado esperado]
```

### Exemplo concreto — RF-001 Ubíquo

```gherkin
# RF-001 — O sistema DEVE permitir cadastro de produto
# Modal: DEVE | Tipo-EARS: Ubíquo
# Gerado por: ferramenta-tcc (documenter > gherkin-spec)

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

  Scenario: Borda — cadastro de produto com nome duplicado
    Given que já existe um produto com o mesmo nome no catálogo
    When o administrador tenta cadastrar um produto com o mesmo nome
    Then o sistema exibe alerta de duplicidade e solicita confirmação antes de prosseguir
```

### Exemplo concreto — RF-002 Evento

```gherkin
# RF-002 — Quando um pedido for concluído, o sistema DEVE enviar confirmação por e-mail
# Modal: DEVE | Tipo-EARS: Evento
# Gerado por: ferramenta-tcc (documenter > gherkin-spec)

Feature: Envio de confirmação por e-mail ao concluir pedido
  Como cliente da plataforma
  Quero receber confirmação por e-mail ao finalizar uma compra
  Para ter comprovante da transação

  Scenario: Caminho feliz — confirmação enviada ao concluir pedido
    Given que o cliente finalizou o fluxo de pagamento com sucesso
    When o sistema registra o pedido como concluído
    Then o sistema envia e-mail de confirmação com o número do pedido e resumo dos itens

  Scenario: Borda — e-mail do cliente inválido ou em branco
    Given que o pedido foi concluído mas o e-mail cadastrado é inválido
    When o sistema tenta enviar a confirmação
    Then o sistema registra falha de envio no log e enfileira nova tentativa em 5 minutos
```

---

## ESTRUTURA DE spec/_skipped.md

```markdown
# Requisitos sem especificação Gherkin

RFs com modal DEVERIA ou PODE não recebem spec Gherkin nesta fase (RFC 2119 — não-obrigatórios).
Estes requisitos podem receber cobertura em fases futuras ou por decisão da equipe técnica.

| RF ID | Modal | Descrição | Razão |
|---|---|---|---|
| RF-004 | DEVERIA | O sistema DEVERIA permitir exportação em PDF | Modal não-obrigatório (RFC 2119 SHOULD) |
| RF-007 | PODE | O sistema PODE exibir notificações push | Modal opcional (RFC 2119 MAY) |
```

---

## REGRAS

- Não interagir com o usuário — geração totalmente automatizada
- Não gerar spec para RFs com modal DEVERIA ou PODE (D22 — proibição explícita)
- Cada arquivo `.feature` é independente — sem referências cruzadas entre features
- Não gerar step definitions (essa responsabilidade é do Passo 4 — `step-defs-red`)
- Gherkin escrito em português brasileiro — exceto palavras-chave reservadas (Feature, Scenario, Given, When, Then, And, But, Background)
- Máximo de 3 Scenarios por `.feature` (1 caminho feliz + até 2 bordas)
- RFs com descrição vaga demais → gerar `.feature` com comentário `[VERIFICAR]` e um Scenario placeholder (não omitir o arquivo)
- `spec/_skipped.md` deve ser gerado sempre, mesmo que vazio (garante transparência e rastreabilidade)
- IDs dos arquivos devem corresponder exatamente aos IDs de `03.1-funcionais.md` (sem renumeração)
