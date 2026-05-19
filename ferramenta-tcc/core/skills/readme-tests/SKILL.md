---
name: readme-tests
marco: [M3]
description: >-
  Gera o guia de instalação e execução dos testes para os três frameworks gerados — documentando como rodar, o que esperar e por que os testes falham inicialmente.
  Use no Marco 3, após gerar os arquivos de código de teste, para produzir a documentação de execução.
  Generate README-TESTS.md with setup and run instructions for Pytest-BDD, Cucumber-js, and SpecFlow; substitute real slugs from spec/; candidate R5.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de concretude** — instrução sem comando exato é inútil. Cada framework tem: pré-requisitos, instalação, comando para rodar tudo, comando para rodar 1 teste, e estrutura de pastas esperada.
2. **Substituir marcadores pelos slugs reais.** `<slug>` é um marcador do template — o arquivo final deve ter `rf-001-cadastro-produto`, não `<slug>`. Entregar template sem substituição = entregar rascunho como artefato.
3. **Estado RED é documentado explicitamente.** O README deixa claro que os testes falharão e por quê. Ocultar o estado RED confunde o desenvolvedor.

<HARD-GATE>
- NÃO executar antes de `step-defs-red` (Passo 4) concluído
- NÃO executar se `tests/unit/` e `tests/acceptance/` estão vazios (nada para documentar)
- ⛔ STOP se slugs reais não puderem ser derivados de `spec/*.feature` — não entregar README com marcadores não-substituídos
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `tests/unit/`, `tests/acceptance/` existem e têm arquivos
3. Coletar slugs reais de `spec/*.feature` para substituição nos exemplos

## Fase 1 — Montagem do README

Gerar `README-TESTS.md` substituindo todos os marcadores `<slug>` e `<rf-id>` por slugs reais do projeto:

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
- Python ≥ 3.9 · pip

### Instalar dependências
```bash
pip install pytest pytest-bdd
```
Ou: `pip install -r requirements.txt`

### Rodar todos os testes
```bash
pytest tests/unit/
```

### Rodar um teste específico
```bash
pytest tests/unit/[rf-id-real]-[slug-real]_steps.py -v
```

### Estrutura esperada
```
tests/unit/
├── [rf-id-1]-[slug-1]_steps.py
├── [rf-id-2]-[slug-2]_steps.py
└── ...
```

---

## Seção B — Cucumber-js (JavaScript/TypeScript)

### Pré-requisitos
- Node.js ≥ 18 · npm

### Instalar dependências
```bash
npm install @cucumber/cucumber
```

### Rodar todos os testes
```bash
npx cucumber-js
```

### Rodar um teste específico
```bash
npx cucumber-js spec/[rf-id-real]-[slug-real].feature
```

### Estrutura esperada
```
tests/acceptance/
├── [rf-id-1]-[slug-1].steps.js
├── [rf-id-2]-[slug-2].steps.js
└── ...
```

---

## Seção C — SpecFlow (.NET C#)

### Pré-requisitos
- .NET SDK ≥ 6.0 · NuGet: SpecFlow, SpecFlow.NUnit (ou SpecFlow.xUnit)

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
dotnet test --filter "FullyQualifiedName~[RfIdPascalCase]"
```

### Estrutura esperada
```
tests/acceptance/
├── [RfId1Slug1]Steps.cs
├── [RfId2Slug2]Steps.cs
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

## Fase 2 — Substituição de Marcadores

Substituir `[rf-id-real]`, `[slug-real]`, `[RfIdPascalCase]` pelos slugs reais coletados em Fase 0. Usar o 1º RF como exemplo nos comandos de "Rodar um teste específico".

## Fase 3 — Saída

Salvar como `README-TESTS.md` na raiz do projeto.

Sinalizar ao `documenter`: readme-tests concluído → Passos 1-6 do documenter completos → prosseguir para `traducao-gate` (Passo 7, SRS).

<!-- internal -->
## Anti-Padrão: Template Entregue Sem Substituição de Slugs

**Como acontece:** A skill gera o README com os marcadores do template literais: `tests/unit/<rf-id>-<slug>_steps.py`. O desenvolvedor não consegue usar o arquivo sem descobrir os nomes reais dos arquivos gerados.

**Como detectar:** Verificar presença de `<` e `>` no texto final gerado — qualquer marcador não-substituído é erro.

**O que fazer:** Fase 2 é obrigatória: varrer o texto gerado por regex `<[^>]+>` antes de salvar. Se encontrar marcadores: buscar os slugs reais em `spec/*.feature` e substituir. Nunca salvar com marcadores.
<!-- /internal -->
