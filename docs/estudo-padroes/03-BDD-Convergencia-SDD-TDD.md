# BDD — Convergência entre SDD e TDD

**Referências principais:**  
- Dan North — *Introducing BDD* (2006, Better Software Magazine)  
- Gojko Adzic — *Specification by Example* (2011)

**Ver também:** [`01-Spec-Driven-Development.md`](01-Spec-Driven-Development.md), [`02-Test-Driven-Development.md`](02-Test-Driven-Development.md)

---

## 1. O problema que BDD resolve

TDD (ver `02`) é uma prática de design de código. O problema: *os testes são escritos por desenvolvedores, para desenvolvedores*. Um stakeholder não-técnico não consegue ler um teste JUnit e dizer se ele captura a intenção de negócio correta.

**Dan North** percebeu isso em 2004 ao tentar ensinar TDD. A pergunta que seus alunos faziam sempre: *"Mas o que exatamente devo testar?"* Isso revelou que o problema não era TDD em si — era a falta de linguagem compartilhada entre quem especifica (analista, stakeholder) e quem implementa (desenvolvedor).

Behavior-Driven Development (BDD), formalizado no ensaio *Introducing BDD* (2006), é a resposta: **use uma linguagem estruturada em linguagem natural** para descrever comportamentos do sistema, de forma que o texto seja simultaneamente entendível por stakeholders e automatizável por ferramentas.

---

## 2. Gherkin: a notação central

**Gherkin** é a linguagem de especificação usada pelo Cucumber e compatíveis. Sua estrutura fundamental:

```gherkin
Feature: <Nome da funcionalidade>
  <Descrição opcional>

  Scenario: <Nome do cenário>
    Given <contexto inicial — o estado do mundo antes da ação>
    When  <ação realizada pelo usuário ou sistema>
    Then  <resultado esperado e observável>
```

Extensões comuns:

```gherkin
  And   <condição adicional, encadeada a Given/When/Then anterior>
  But   <exceção ou condição negativa>

  Background:  <passos que se repetem em todos os cenários de uma Feature>

  Scenario Outline: <template com dados parametrizados>
    Given <contexto com <variável>>
    When  <ação com <variável>>
    Then  <resultado com <resultado>>
    Examples:
      | variável | resultado |
      | valor1   | valor2    |
```

### O que faz de Gherkin uma notação especial

Gherkin não é apenas formato de teste — é **especificação executável**:

- **É legível por não-técnicos.** Um stakeholder consegue ler um cenário Gherkin, identificar se captura sua intenção e apontar erros sem precisar entender código.
- **É automatizável.** Ferramentas como Cucumber executam o Gherkin mapeando cada passo (`Given`, `When`, `Then`) para código de implementação (step definitions).
- **É a ponte entre SDD e TDD.** O mesmo artefato Gherkin serve como spec (para o analista aprovar) e como teste (para o sistema executar automaticamente).

---

## 3. Specification by Example (Adzic, 2011)

Gojko Adzic sistematizou uma prática convergente com BDD no livro *Specification by Example* (2011). A tese central:

> *Exemplos concretos comunicam melhor do que especificações abstratas. Um sistema é mais bem descrito pelo que ele faz em situações específicas do que por declarações gerais sobre seu comportamento.*

A diferença entre spec abstrata e spec por exemplo:

| Spec abstrata (EARS) | Spec por exemplo (Gherkin) |
|---|---|
| `WHEN o usuário clica em "Cancelar pedido" o sistema DEVE exibir confirmação` | `Given que existe um pedido no status "Pendente"` `When o usuário clica em "Cancelar pedido"` `Then o sistema exibe "Confirme o cancelamento"` |

A spec abstrata é mais genérica — mas pode ser interpretada de formas diferentes. A spec por exemplo é mais concreta — mas pode não cobrir todos os casos. As duas são **complementares**, não excludentes. (Ver `04-Integracao-com-IREB.md` para como combiná-las com EARS + IREB.)

Adzic introduz o conceito de **Living Documentation**: a suite de specs por exemplo, por ser automatizável, é sempre verdadeira em relação ao sistema. Diferente de um documento Word, ela falha quando o sistema diverge.

---

## 4. Ferramentas do ecossistema BDD

| Ferramenta | Linguagem-alvo | Formato |
|---|---|---|
| **Cucumber** | Java, Ruby, JS, Go, .NET | Gherkin |
| **Pytest-BDD** | Python | Gherkin |
| **behave** | Python | Gherkin |
| **SpecFlow** | .NET (C#) | Gherkin |
| **JBehave** | Java | Gherkin-like |
| **Robot Framework** | Agnóstico | Keyword-driven (legível) |

O modelo de funcionamento é o mesmo em todas: o arquivo `.feature` (Gherkin) é o artefato principal, e os *step definitions* são o código que mapeia cada passo para lógica de teste real.

---

## 5. Por que BDD é a ponte natural entre SDD e TDD

O cenário Gherkin é o artefato que **pertence aos dois mundos**:

```
SDD: "o que o sistema deve fazer"      ← Feature + Scenario (legível pelo analista)
TDD: "como verificar que o sistema faz" ← Step definitions (executado pelo framework)
```

O mesmo arquivo `.feature`:
1. É revisado pelo stakeholder (SDD) — ele pode aprovar ou corrigir o cenário
2. Guia o desenvolvimento (TDD) — o desenvolvedor implementa até todos os cenários passarem
3. Documenta o comportamento (Living Documentation) — sempre atualizado automaticamente

Esse é o mecanismo concreto pelo qual a ferramenta do TCC poderia gerar "Requisitos Executáveis": após a elicitação IREB produzir o SRS, uma skill `sdd-spec-generator` traduziria requisitos funcionais em cenários Gherkin, e uma skill `test-case-generator` geraria o esqueleto dos step definitions — colocando o repositório do projeto em estado RED.

---

## 6. Limites de BDD

**Nem todo requisito é expressável em Given/When/Then.** Essa é a limitação central de BDD:

| Tipo de requisito | Expressável em Gherkin? |
|---|---|
| Funcional com fluxo claro | Sim (maioria) |
| Funcional com muitas variações | Parcialmente (Scenario Outline ajuda) |
| De desempenho ("responder em < 2s") | Com dificuldade — requer step com medição de tempo |
| De segurança ("dados criptografados em repouso") | Muito difícil — comportamento interno, não observável |
| De usabilidade ("interface intuitiva") | Não — subjetivo, não testável automaticamente |
| De disponibilidade ("99,9% uptime") | Não diretamente — requer testes de carga separados |

Isso é importante para o TCC: os requisitos de **qualidade** (FURPS+ / ISO 25010) que a ferramenta elicita no Marco 2 (seção `rnfs-tipicos.md`) são, em sua maioria, difíceis de expressar em Gherkin. Uma integração SDD+TDD completa precisaria de uma estratégia específica para requisitos não-funcionais — que não é trivial e provavelmente é o motivo pelo qual o doc [`4 - Evolucao-SDD-TDD.md`](../planejamento/4%20-%20Evolucao-SDD-TDD.md) foca apenas em requisitos funcionais.

**Risco de "BDD cosmético".** Times que escrevem Gherkin após a implementação (em vez de antes) ou que não envolvem stakeholders na escrita dos cenários perdem os benefícios centrais do BDD — e ficam com uma camada extra de manutenção de testes sem o retorno esperado.
