---
name: readme-tests
description: Gera README-TESTS.md documentando como configurar e rodar os testes nos 3 frameworks: Pytest-BDD (Python), Cucumber-js (JavaScript/TypeScript) e SpecFlow (.NET C#). Cada seção inclui: pré-requisitos, comandos de instalação, comando para rodar todos os testes, comando para rodar teste específico, e estrutura de pastas esperada. Referência: D23.
when_to_use: Invocada pelo documenter como Passo 6 do Processo M3. Depende de step-defs-red (Passo 4) ter executado. Saída: README-TESTS.md na raiz do projeto.
---

# Skill: readme-tests

Gera `README-TESTS.md` documentando como instalar dependências e executar os testes
nos 3 frameworks gerados por step-defs-red. Inclui avisos sobre estado RED.

---

## Processo

Preenchimento de template: a skill gera `README-TESTS.md` substituindo os
marcadores abaixo com informações específicas do projeto (nome do produto, IDs dos RFs reais).

---

## Template de saída — README-TESTS.md

```markdown
# README: Como Rodar os Testes

> ⚠️ Os testes estão em estado RED (estrutura criada, implementação pendente).
> Eles falharão até que os step definitions sejam implementados com código real.

## Visão Geral

Este projeto gerou step definitions em 3 frameworks a partir dos cenários Gherkin em `spec/`.
Os arquivos de teste existem e compilam, mas cada step lança um erro imediatamente —
eles devem ser implementados pelo time de desenvolvimento antes de qualquer execução real.

```
projeto/
├── spec/              # Cenários Gherkin (.feature) — lidos por todos os 3 frameworks
├── tests/
│   ├── unit/          # Step definitions Pytest-BDD (Python)
│   └── acceptance/    # Step definitions Cucumber-js (JS) + SpecFlow (.NET)
```

---

## Seção A — Pytest-BDD (Python)

### Pré-requisitos

- Python ≥ 3.9
- pip

### Instalar dependências

```bash
pip install pytest pytest-bdd
```

Ou, se o projeto tiver `requirements.txt`:

```bash
pip install -r requirements.txt
```

### Rodar todos os testes

```bash
pytest tests/unit/
```

### Rodar um teste específico

```bash
pytest tests/unit/rf-001-cadastro-produto_steps.py -v
```

### Estrutura esperada

```
tests/unit/
├── rf-001-<slug>_steps.py
├── rf-002-<slug>_steps.py
└── ...
```

---

## Seção B — Cucumber-js (JavaScript/TypeScript)

### Pré-requisitos

- Node.js ≥ 18
- npm

### Instalar dependências

```bash
npm install
```

Ou instalar diretamente:

```bash
npm install @cucumber/cucumber
```

### Rodar todos os testes

```bash
npx cucumber-js
```

### Rodar um teste específico

```bash
npx cucumber-js spec/rf-001-<slug>.feature
```

### Estrutura esperada

```
tests/acceptance/
├── rf-001-<slug>.steps.js
├── rf-002-<slug>.steps.js
└── ...
```

---

## Seção C — SpecFlow (.NET C#)

### Pré-requisitos

- .NET SDK ≥ 6.0
- NuGet: SpecFlow, SpecFlow.NUnit (ou SpecFlow.xUnit)

### Instalar dependências

```bash
dotnet restore
```

### Rodar todos os testes

```bash
dotnet test
```

### Rodar um teste específico

```bash
dotnet test --filter "FullyQualifiedName~Rf001"
```

### Estrutura esperada

```
tests/acceptance/
├── Rf001<Slug>Steps.cs
├── Rf002<Slug>Steps.cs
└── ...
```

---

## Estado RED — O que esperar

Ao rodar os testes agora, você verá falhas como:

- **Pytest-BDD:** `NotImplementedError: Step RED — implementar antes de rodar`
- **Cucumber-js:** `Error: PENDING: implementar antes de rodar`
- **SpecFlow:** `TechTalk.SpecFlow.PendingStepException`

Isso é esperado. Os testes só passarão após implementação real dos step definitions.
```

---

## Regras

- **Sem interação com o usuário** — skill opera inteiramente sobre artefatos do sistema de arquivos
- **Substituir marcadores `<slug>`** pelos IDs e slugs reais dos RFs do projeto
- **Manter comandos em blocos de código** — nunca texto corrido
- **Declarar claramente o estado RED** no topo do documento e na seção final
- **Usar português** para prosa; manter comandos e termos técnicos em inglês/original
