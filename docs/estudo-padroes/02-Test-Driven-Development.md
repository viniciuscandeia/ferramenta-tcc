# Test-Driven Development (TDD)

**Referência principal:** Kent Beck — *Test-Driven Development by Example* (2002)  
**Ver também:** [`03-BDD-Convergencia-SDD-TDD.md`](03-BDD-Convergencia-SDD-TDD.md) (variante ATDD/BDD), [`06-TDD-Avancado-e-IA.md`](06-TDD-Avancado-e-IA.md) (TDD avançado e IA)

---

## 1. Origem e contexto histórico

Test-Driven Development foi sistematizado por **Kent Beck** como parte do *eXtreme Programming* (XP) em fins dos anos 1990 e formalizado no livro *Test-Driven Development by Example* (2002). A ideia central é inverter a ordem natural: escrever o teste *antes* do código de produção.

Beck não inventou a ideia do zero — ele a recuperou de uma prática descrita em manuais da IBM dos anos 1960 (*program testing*) e a reconfigurou como disciplina de design orientada a feedback rápido. O que muda em TDD não é apenas *quando* o teste é escrito — é que o teste passa a ser uma ferramenta de **design**, não apenas de verificação.

---

## 2. O ciclo RED-GREEN-REFACTOR

O núcleo do TDD é um ciclo curto e repetível de três fases:

```
RED     → Escrever um teste que falha
           (o comportamento esperado ainda não existe)

GREEN   → Escrever o código mínimo para o teste passar
           (sem otimização, sem generalização prematura)

REFACTOR → Melhorar o código sem quebrar os testes
           (remover duplicação, clarear intenção, aplicar padrões)
```

A fase REFACTOR é protegida pela suite de testes: o desenvolvedor pode reorganizar o código com confiança porque sabe que qualquer regressão será detectada imediatamente.

**Importante:** "mínimo para passar" (GREEN) significa literalmente o mínimo. Se o único jeito de passar é `return 42;`, essa é a implementação correta por agora. O próximo teste forçará a generalização.

---

## 3. Por que TDD funciona como ferramenta de design

Escrever o teste antes força o desenvolvedor a responder:

> *Como vou usar esse código antes de existir?*

Isso expõe problemas de interface (API confusa, acoplamento excessivo, dependências difíceis de injetar) antes que o código exista — quando o custo de mudança é zero. TDD é, portanto, uma técnica de design que usa testes como artefatos de feedback.

Beck: *"TDD não é sobre testes, é sobre design — os testes são o subproduto."*

---

## 4. Variantes

### 4.1 Classical / Detroit TDD (Kent Beck)

A escola original. Ênfase em:
- Testes de **estado** — verificam o valor de retorno ou o estado do objeto após uma operação
- Mocks e stubs usados com parcimônia — apenas quando necessário isolar dependências lentas (banco, rede)
- Refactoring guiado por heurísticas simples (DRY, nomes expressivos)

Resultado: testes acoplados à implementação interna são evitados; o teste importa apenas para o comportamento observável.

### 4.2 London / Mockist TDD (Freeman & Pryce)

Sistematizada em *Growing Object-Oriented Software, Guided by Tests* (Steve Freeman & Nat Pryce, 2009). Ênfase em:
- Testes de **interação** — verificam que os objetos colaboradores foram chamados corretamente
- Mocks pesados — quase toda dependência é substituída por um mock
- Design emergente de fora para dentro (*outside-in*): começa pelo teste de aceitação (nivel de sistema), desce até unidades

Vantagem: design de interfaces emergente, altamente desacoplado.  
Desvantagem: testes frágeis — qualquer mudança na estrutura interna quebra o mock.

### 4.3 ATDD — Acceptance Test-Driven Development

Extensão de TDD para o nível de aceitação: os testes são escritos do ponto de vista do usuário final, não do desenvolvedor. Tipicamente:

1. Stakeholder, analista e desenvolvedor definem juntos os **critérios de aceitação** (o que o sistema precisa fazer para ser considerado completo)
2. Esses critérios viram testes automatizados
3. O desenvolvimento começa e termina quando os testes de aceitação passam

ATDD é a ponte direta para BDD. A diferença é que BDD acrescenta uma **linguagem compartilhada** (Gherkin) para que stakeholders não-técnicos possam ler e validar os testes. (Ver `03-BDD-Convergencia-SDD-TDD.md`.)

---

## 5. O que significa "requisito executável" nesse contexto

Em TDD clássico, o teste é a especificação da unidade. Em ATDD, o teste de aceitação é a especificação do comportamento do sistema do ponto de vista do usuário. Nos dois casos:

- Se o teste passa, o comportamento está correto
- Se o requisito muda, o teste muda primeiro — e a implementação segue

Isso cria uma equivalência entre **requisito** e **teste de aceitação**: um requisito bem escrito pode ser transformado em teste; um requisito que não pode ser transformado em teste é ambíguo ou não-testável — e deve ser revisado.

É essa equivalência que o doc [`4 - Evolucao-SDD-TDD.md`](../planejamento/4%20-%20Evolucao-SDD-TDD.md) chama de "Ambiguidade Zero": *se não é possível gerar um teste para o requisito, o requisito está mal definido.*

---

## 6. Ferramentas representativas

| Linguagem | Framework de teste | Suporte a BDD/ATDD |
|---|---|---|
| Python | **Pytest** | Pytest-BDD, behave |
| JavaScript / TypeScript | **Jest**, Vitest, Mocha | Jest + Cucumber-js |
| Java | **JUnit 5** | JBehave, Cucumber-JVM |
| Ruby | **RSpec** | Cucumber |
| Go | `testing` (stdlib) | godog |
| C# / .NET | **NUnit**, xUnit | SpecFlow |

Para o contexto do TCC (saída da ferramenta voltada a projetos do usuário final), as ferramentas relevantes dependem do domínio do usuário — o catálogo seed em `ferramenta-tcc/catalogos-seed/dominios/` segmenta por tipo de projeto (mobile, saúde, educação, e-commerce, dashboard).

---

## 7. Pontos fortes

**Feedback rápido.** O ciclo RED-GREEN-REFACTOR fecha em minutos, não horas. Bugs emergem antes de se propagarem.

**Design emergente.** A interface de cada módulo é validada antes da implementação existir.

**Suite de regressão como subproduto.** Todo código escrito com TDD vem com cobertura automática. Refactoring é seguro.

**Documentação viva.** Os testes documentam o comportamento esperado de forma mais confiável do que comentários ou documentos externos — porque eles rodam.

---

## 8. Pontos fracos e limitações

**Curva de aprendizado alta.** Desenvolvedores sem prática em TDD frequentemente escrevem testes que verificam implementação (frágeis) em vez de comportamento (robustos). A disciplina do ciclo RED-GREEN-REFACTOR demora a se consolidar.

**Nem toda área do sistema é facilmente testável.** UIs, integrações externas, código de infraestrutura e comportamentos emergentes são difíceis de cobrir com TDD puro.

**Overhead percebido no curto prazo.** Escrever teste antes parece mais lento — o retorno se manifesta na manutenção futura, não na primeira entrega.

**Não substitui análise de requisitos.** TDD guia *como* implementar, mas não *o que* implementar. A decisão do que testar ainda depende de requisitos claros — daí a conexão direta com ATDD e BDD (e, no TCC, com a elicitação IREB).
