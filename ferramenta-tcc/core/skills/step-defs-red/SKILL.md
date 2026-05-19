---
name: step-defs-red
marco: [M3]
description: >-
  Gera os arquivos de código de teste em estado vermelho (estrutura criada, implementação propositalmente ausente) para três frameworks: Python, JavaScript e C#.
  Use no Marco 3, após gerar os cenários Gherkin, para criar a estrutura de testes que o time de desenvolvimento vai implementar.
  Generate RED state step definitions for Pytest-BDD, Cucumber-js, and SpecFlow from spec/*.feature; 3 files per feature; no user interaction; candidate R5.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de estado RED.** Todo step deve lançar erro imediatamente — sem lógica real, sem mocks, sem `pass` silencioso. Step que não falha não é RED. RED é o contrato com o desenvolvedor.
2. **3 frameworks, sem exceção.** 1 feature = 3 arquivos (Pytest-BDD + Cucumber-js + SpecFlow). Gerar em 1 ou 2 frameworks e silenciar o terceiro é omissão.
3. **Espelhar nomenclatura de `spec/` exatamente.** RF-001 em spec → rf-001 em tests/. Qualquer divergência quebra a rastreabilidade do `srs-ireb-template` seção 6.

<HARD-GATE>
- NÃO executar antes de `gherkin-spec` (Passo 3) concluído
- NÃO executar sem arquivos em `spec/*.feature` (lista_deve vazia = nada para gerar)
- ⛔ STOP se contagem de arquivos gerados ≠ N_features × 3 — verificar qual framework falhou antes de sinalizar conclusão
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Listar todos os arquivos em `spec/*.feature` (excluir `_skipped.md`)
3. Para cada `.feature`: extrair todos os textos de steps Given/When/Then

## Fase 1 — Geração Pytest-BDD (Python)

**Localização:** `tests/unit/<rf-id>-<slug>_steps.py`

| Feature | Step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/unit/rf-001-cadastro-produto_steps.py` |

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

**Exemplo concreto:**
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

## Fase 2 — Geração Cucumber-js (JavaScript/TypeScript)

**Localização:** `tests/acceptance/<rf-id>-<slug>.steps.js`

| Feature | Step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/acceptance/rf-001-cadastro-produto.steps.js` |

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

**Exemplo concreto:**
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

## Fase 3 — Geração SpecFlow (.NET C#)

**Localização:** `tests/acceptance/<RfId><Slug>Steps.cs` — PascalCase sem hifens

| Feature | Step def |
|---|---|
| `spec/rf-001-cadastro-produto.feature` | `tests/acceptance/Rf001CadastroProdutoSteps.cs` |

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

**Exemplo concreto:**
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

## Fase 4 — Saída

N features × 3 arquivos gerados:
- `tests/unit/<rf-id>-<slug>_steps.py` × N (Pytest-BDD)
- `tests/acceptance/<rf-id>-<slug>.steps.js` × N (Cucumber-js)
- `tests/acceptance/<RfId><Slug>Steps.cs` × N (SpecFlow)

Verificar: contagem = N_features × 3. Se divergir: ⛔ STOP.

Sinalizar ao `documenter`: step-defs-red concluído → prosseguir para `testing-strategy` (Passo 5).

<!-- internal -->
## Anti-Padrão: Step Def em 1 Framework, Silêncio nos Outros 2

**Como acontece:** A skill gera apenas Pytest-BDD para todos os features (loop parou na Fase 1) e registra sucesso. Cucumber-js e SpecFlow ficam sem cobertura — o `readme-tests` vai gerar instruções para frameworks sem arquivos.

**Como detectar:** Verificar contagem final: N_features × 3. Se ≠ → identificar qual Fase falhou (1, 2 ou 3) e qual feature causou o problema.

**O que fazer:** Falha em 1 framework para 1 feature não para a geração dos outros frameworks — registrar a falha em `_pendencias.md` e continuar. Só ⛔ STOP se contagem final divergir após os 3 passes.
<!-- /internal -->
