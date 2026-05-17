# Estudo: Spec-Driven Development e Test-Driven Development

**Natureza:** notas de pesquisa — destilação de conhecimento bibliográfico e de ecossistema  
**Mantido por:** pesquisa de suporte ao TCC  
**Relação com a arquitetura:** fundamentação, não decisão

---

## Por que este estudo existe

O documento [`docs/planejamento/4 - Evolucao-SDD-TDD.md`](../planejamento/4%20-%20Evolucao-SDD-TDD.md) registra a visão de estender a ferramenta para produzir "Requisitos Executáveis" ao integrar **Spec-Driven Development (SDD)** e **Test-Driven Development (TDD)** ao fluxo existente. A revisão D12–D19 ([`5 - Revisão D12-D19.md`](../planejamento/5%20-%20Revisão%20D12-D19.md)) classifica essa proposta como candidata a ciclo futuro de deliberação — não formalizada.

Este estudo é a **camada de fundamentação** que sustentará essa deliberação futura. Ele responde:

> *O que são SDD e TDD no sentido moderno/executável? Quais são seus princípios, ferramentas, pontos fortes e fracos? Como eles se relacionam com o IREB §3.3.3 / ISO 29148 já adotado?*

O estudo **não**:

- Propõe extensão da arquitetura da ferramenta
- Cria ou modifica decisões (D1–D19)
- Altera `ferramenta-tcc/` ou qualquer agente/skill existente

---

## Interpretação adotada das siglas

As siglas são usadas aqui no sentido **moderno/executável**:

| Sigla | Interpretação **adotada** neste estudo |
|---|---|
| **SDD** | Spec-Driven Development — especificação como contrato executável |
| **TDD** | Test-Driven Development — ciclo RED-GREEN-REFACTOR (Kent Beck, 2002) |

A interpretação clássica (SDD = Software Design Description IEEE 1016; TDD = Test Documentation IEEE 829 / ISO 29119) fica fora do escopo deste material.

---

## Glossário rápido

| Termo | Significado resumido |
|---|---|
| **Spec-Driven Development (SDD)** | Paradigma em que a especificação executável (não o documento estático) é o artefato central do desenvolvimento |
| **Test-Driven Development (TDD)** | Prática em que os testes são escritos antes do código de produção, no ciclo RED-GREEN-REFACTOR |
| **BDD** | Behavior-Driven Development — extensão do TDD com linguagem de domínio compartilhada entre técnicos e stakeholders |
| **ATDD** | Acceptance Test-Driven Development — testes de aceitação (do ponto de vista do usuário) guiam o desenvolvimento |
| **Gherkin** | Linguagem de notação estruturada (Given/When/Then) usada pelo Cucumber para descrever comportamentos em linguagem natural |
| **Spec executável** | Especificação que pode ser automaticamente verificada; um cenário Gherkin rodável é uma spec executável |
| **Contrato de API** | Descrição formal e verificável de como um endpoint deve se comportar (OpenAPI/AsyncAPI) |
| **Contract testing** | Técnica de verificar que produtor e consumidor de uma API obedecem ao mesmo contrato (Pact) |
| **Ciclo RED-GREEN-REFACTOR** | Escrever teste que falha (RED) → fazer o mínimo para passar (GREEN) → melhorar o código sem quebrar (REFACTOR) |
| **EARS** | Easy Approach to Requirements Syntax — sintaxe estruturada para requisitos textuais (Mavin et al., 2009) |

---

## Ordem de leitura sugerida

```
01-Spec-Driven-Development.md    ← O que é spec executável, ferramentas, princípios
02-Test-Driven-Development.md    ← O que é TDD, variantes (Detroit/London/ATDD)
03-BDD-Convergencia-SDD-TDD.md  ← Gherkin como ponte entre spec e teste
04-Integracao-com-IREB.md        ← Mapeamento EARS ↔ Gherkin, implicações para o TCC
```

Leitura não-linear possível: se o objetivo é só entender BDD, comece em `03` e volte ao `01`–`02` se precisar de contexto.

---

## Referências deste estudo (visão geral)

- Kent Beck — *Test-Driven Development by Example* (2002)
- Dan North — *Introducing BDD* (2006, Better Software Magazine)
- Steve Freeman & Nat Pryce — *Growing Object-Oriented Software, Guided by Tests* (2009)
- Gojko Adzic — *Specification by Example* (2011)
- Mike Cohn — *User Stories Applied* (2004) — em `referencias/`
- IREB — *CPRE Foundation Level Handbook v1.2* — em `referencias/`
- GitHub Spec Kit (`github/spec-kit`) — repositório open-source; já citado em D15–D17
- marcusgoll/Spec-Flow — repositório open-source; já citado em D12
