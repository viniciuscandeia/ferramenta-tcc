# Evolução da Ferramenta: Requisitos Executáveis com SDD e TDD

**Autor:** Gemini CLI  
**Data:** Maio de 2026  
**Contexto:** Upgrade arquitetural da Ferramenta de TCC

---

## 1. O Conceito: "Elicitação de Ciclo Completo"

A proposta original focava na **Engenharia de Requisitos (ER)** para gerar um SRS (Software Requirements Specification). A nova visão expande isso para o que chamamos de **Requisitos Executáveis**, integrando:

1.  **ER (O "Porquê"):** Elicitação fundamentada (IREB/ISO) para entender o valor de negócio.
2.  **SDD (O "O quê"):** Geração automática de uma especificação técnica (Spec) que serve de contrato para a IA/Desenvolvedor.
3.  **TDD (O "Como validar"):** Geração de casos de teste (Unitários e de Aceitação) que garantem que o código futuro estará correto.

---

## 2. Como funciona no fluxo de Agentes

O segredo é manter a simplicidade para o **usuário leigo** (D1) enquanto os agentes trabalham no "backstage":

### Fase 1: Elicitação Guiada (Interface Humana)
O usuário responde perguntas simples via `ask_user` (ex: "O usuário deve poder cancelar o pedido?").
*   **Agente Elicitador:** Coleta a intenção de negócio.

### Fase 2: Geração da Spec (SDD - O Contrato)
O **Agente SRS** agora possui uma nova skill: `sdd-spec-generator`.
*   Ele traduz a resposta do usuário em um formato **SDD-compliant** (como o padrão do GitHub Spec Kit).
*   **Exemplo:** Transforma "Quero cancelar o pedido" em um cenário `Given/When/Then` e define o contrato da API de cancelamento.

### Fase 3: Geração de Testes (TDD - A Prova)
O **Agente de Validação** invoca uma nova skill: `test-case-generator`.
*   Para cada funcionalidade na Spec, ele gera scripts de teste (ex: em Python/Pytest ou Jest) que testam o sucesso e as falhas (edge cases) daquela spec.
*   Isso cria o estado **RED** do TDD automaticamente.

---

## 3. Benefícios Estratégicos

1.  **Ambiguidade Zero:** Se não é possível gerar um teste para o requisito, o requisito está mal definido. O sistema detecta isso na hora e pede esclarecimento ao usuário.
2.  **Pronto para Implementar:** O desenvolvedor (ou um agente de implementação como o Claude Code) recebe não apenas um PDF de requisitos, mas um repositório com a Spec e os Testes já falhando (esperando o código).
3.  **Rastreabilidade Automática:** O teste aponta diretamente para a spec, que aponta para a resposta do stakeholder. Temos uma linha direta do código até a necessidade do cliente.

---

## 4. Impacto na Estrutura de Arquivos

O repositório de saída do projeto do usuário passará a incluir:

```
projeto-do-usuario/
├── marco-3/
│   ├── srs/
│   │   └── SRS-completo.md
│   ├── spec/ (NOVO - SDD)
│   │   ├── api-contracts.yaml
│   │   └── functional-specs.md (padrão Spec Kit)
│   └── tests/ (NOVO - TDD)
│       ├── unit/
│       └── acceptance/ (Cenários BDD gerados)
```

---

## 5. Conclusão: O "Diferencial do TCC"

Ao unir ER + SDD + TDD, a ferramenta deixa de ser um "gerador de documentos" e passa a ser um **Orquestrador de Intenção de Software**. 

*   **Visão Tradicional:** Elicitar → Documentar → Entregar PDF.
*   **Nossa Visão:** Elicitar → Estruturar (SDD) → Provar (TDD) → Entregar Repositório Executável.

Isso resolve um dos maiores problemas da engenharia de software: a **perda de informação** na transição entre o que o cliente quer e o que o desenvolvedor testa.
