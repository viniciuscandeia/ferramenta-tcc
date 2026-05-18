---
name: step-defs-red
description: Gera arquivos de step definitions em estado RED (falham imediatamente — sem implementação real) para os 3 frameworks alvo: Pytest-BDD (Python), Cucumber-js (JavaScript/TypeScript) e SpecFlow (.NET C#). Lê spec/*.feature gerado por gherkin-spec e gera 1 step def file por .feature em cada framework. Estado RED garantido: NotImplementedError (Python), throw new Error('PENDING') (JS), throw new PendingStepException() (C#).
when_to_use: Invocada pelo documenter como Passo 4 do Processo M3. Depende de gherkin-spec (Passo 3) ter executado. Entrada: spec/*.feature. Saída: tests/unit/ e tests/acceptance/ com step defs RED em 3 frameworks.
---

# Skill: step-defs-red

Gera arquivos de step definitions em estado RED para Pytest-BDD, Cucumber-js e SpecFlow.
Estado RED significa: estrutura criada, nenhum step implementado — todos lançam erro imediatamente.

---

## Processo (5 passos)

1. Ler todos os arquivos `spec/*.feature` gerados por gherkin-spec
2. Para cada `.feature`: extrair todos os textos de steps Given/When/Then
3. Para cada `.feature`: gerar arquivo Pytest-BDD (Seção A)
4. Para cada `.feature`: gerar arquivo Cucumber-js (Seção B)
5. Para cada `.feature`: gerar arquivo SpecFlow (Seção C)

---

## Seção A — Pytest-BDD (Python)

### Localização de saída

`tests/unit/<rf-id>-<slug>_steps.py` — espelhando a nomenclatura de `spec/`

### Convenção de nomenclatura

| Arquivo `.feature` | Arquivo step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/unit/rf-001-cadastro-produto_steps.py` |
| `spec/rf-002-busca-produto.feature` | `tests/unit/rf-002-busca-produto_steps.py` |

### Estrutura do arquivo

```python
# tests/unit/rf-001-cadastro-produto_steps.py
import pytest
from pytest_bdd import scenario, given, when, then

@scenario('../spec/rf-001-cadastro-produto.feature', '<título do cenário>')
def test_<slug_sem_hifens>():
    pass

@given("<texto do step Given>")
def dado_<slug_do_step>():
    raise NotImplementedError("Step RED — implementar antes de rodar")

@when("<texto do step When>")
def quando_<slug_do_step>():
    raise NotImplementedError("Step RED — implementar antes de rodar")

@then("<texto do step Then>")
def entao_<slug_do_step>():
    raise NotImplementedError("Step RED — implementar antes de rodar")
```

### Exemplo completo

```python
# tests/unit/rf-001-cadastro-produto_steps.py
import pytest
from pytest_bdd import scenario, given, when, then

@scenario('../spec/rf-001-cadastro-produto.feature', 'Cadastro de produto com sucesso')
def test_cadastro_produto():
    pass

@given("o artesão está na tela de cadastro")
def dado_artesao_na_tela():
    raise NotImplementedError("Step RED — implementar antes de rodar")

@when("ele preenche os dados do produto e confirma")
def quando_preenche_e_confirma():
    raise NotImplementedError("Step RED — implementar antes de rodar")

@then("o produto aparece no catálogo")
def entao_produto_no_catalogo():
    raise NotImplementedError("Step RED — implementar antes de rodar")
```

---

## Seção B — Cucumber-js (JavaScript/TypeScript)

### Localização de saída

`tests/acceptance/<rf-id>-<slug>.steps.js` (ou `.ts` se o projeto usar TypeScript)

### Convenção de nomenclatura

| Arquivo `.feature` | Arquivo step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/acceptance/rf-001-cadastro-produto.steps.js` |
| `spec/rf-002-busca-produto.feature` | `tests/acceptance/rf-002-busca-produto.steps.js` |

### Estrutura do arquivo

```javascript
// tests/acceptance/<rf-id>-<slug>.steps.js
const { Given, When, Then } = require('@cucumber/cucumber');

Given('<texto do step Given>', function () {
  throw new Error('PENDING: implementar antes de rodar');
});

When('<texto do step When>', function () {
  throw new Error('PENDING: implementar antes de rodar');
});

Then('<texto do step Then>', function () {
  throw new Error('PENDING: implementar antes de rodar');
});
```

### Exemplo completo

```javascript
// tests/acceptance/rf-001-cadastro-produto.steps.js
const { Given, When, Then } = require('@cucumber/cucumber');

Given('o artesão está na tela de cadastro', function () {
  throw new Error('PENDING: implementar antes de rodar');
});

When('ele preenche os dados do produto e confirma', function () {
  throw new Error('PENDING: implementar antes de rodar');
});

Then('o produto aparece no catálogo', function () {
  throw new Error('PENDING: implementar antes de rodar');
});
```

---

## Seção C — SpecFlow (.NET C#)

### Localização de saída

`tests/acceptance/<RfId><Slug>Steps.cs` — nomenclatura PascalCase sem hifens

### Convenção de nomenclatura

| Arquivo `.feature` | Arquivo step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/acceptance/Rf001CadastroProdutoSteps.cs` |
| `spec/rf-002-busca-produto.feature` | `tests/acceptance/Rf002BuscaProdutoSteps.cs` |

### Estrutura do arquivo

```csharp
// tests/acceptance/<RfId><Slug>Steps.cs
using TechTalk.SpecFlow;

[Binding]
public class <RfId><Slug>Steps
{
    [Given("<texto do step Given>")]
    public void Dado<SlugDoStep>()
    {
        throw new PendingStepException();
    }

    [When("<texto do step When>")]
    public void Quando<SlugDoStep>()
    {
        throw new PendingStepException();
    }

    [Then("<texto do step Then>")]
    public void Entao<SlugDoStep>()
    {
        throw new PendingStepException();
    }
}
```

### Exemplo completo

```csharp
// tests/acceptance/Rf001CadastroProdutoSteps.cs
using TechTalk.SpecFlow;

[Binding]
public class Rf001CadastroProdutoSteps
{
    [Given("o artesão está na tela de cadastro")]
    public void DadoArtesaoNaTela()
    {
        throw new PendingStepException();
    }

    [When("ele preenche os dados do produto e confirma")]
    public void QuandoPreencheEConfirma()
    {
        throw new PendingStepException();
    }

    [Then("o produto aparece no catálogo")]
    public void EntaoProdutoNoCatalogo()
    {
        throw new PendingStepException();
    }
}
```

---

## Regras

- Gerar **1 arquivo step def por `.feature` por framework** (total: N features × 3 arquivos)
- **Estado RED garantido** — todos os corpos de step devem lançar erro imediatamente, sem nenhuma lógica real
- **Não implementar** nenhum step — o objetivo é criar a estrutura para o desenvolvedor preencher
- **Espelhar a nomenclatura** de `spec/` (mesmo rf-id e slug)
- Pytest-BDD vai para `tests/unit/`; Cucumber-js e SpecFlow vão para `tests/acceptance/`
- **Sem interação com o usuário** — skill opera inteiramente sobre artefatos do sistema de arquivos
