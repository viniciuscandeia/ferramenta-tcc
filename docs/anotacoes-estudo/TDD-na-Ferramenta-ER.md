# Test-Driven Development (TDD) e sua Aplicação na Ferramenta de Elicitação de Requisitos

**Autor:** Gemini CLI  
**Data:** Maio de 2026  
**Contexto:** Projeto de TCC - Elicitação Assistida por Agentes de IA

---

## 1. O que é Test-Driven Development (TDD)?

O **Test-Driven Development (Desenvolvimento Dirigido por Testes)** é uma técnica de desenvolvimento de software que inverte o fluxo tradicional de codificação. Em vez de escrever o código e depois testá-lo, o desenvolvedor escreve o teste *antes* do código funcional.

### 1.1 O Ciclo Red-Green-Refactor

O TDD baseia-se em um ciclo iterativo curto e rigoroso:

1.  **🔴 Red (Vermelho):** Escreva um teste pequeno para uma funcionalidade que ainda não existe. Execute o teste e certifique-se de que ele falha (isso prova que o teste é válido e que a funcionalidade realmente falta).
2.  **🟢 Green (Verde):** Escreva o código mínimo necessário para fazer o teste passar. O foco aqui é a funcionalidade, não a perfeição.
3.  **🔵 Refactor (Refatorar):** Melhore o código escrito (limpeza, organização, performance) mantendo os testes passando.

### 1.2 Benefícios do TDD

*   **Qualidade de Código:** Garante que 100% do código escrito tenha um propósito claro (passar no teste).
*   **Documentação Viva:** Os testes descrevem exatamente como o sistema deve se comportar, servindo como uma especificação técnica sempre atualizada.
*   **Design Modular:** Como é preciso testar partes pequenas isoladamente, o TDD naturalmente induz a uma arquitetura mais desacoplada e modular.
*   **Confiança para Refatorar:** Com uma bateria de testes sólida, mudanças no sistema podem ser feitas com a segurança de que erros (regressões) serão detectados imediatamente.

---

## 2. Como o TDD agrega à Ferramenta de ER?

No contexto de uma ferramenta de Engenharia de Requisitos (ER) baseada em agentes de IA, o TDD não se aplica apenas ao código (scripts de automação), mas principalmente ao **comportamento dos agentes** e à **qualidade dos artefatos gerados**.

### 2.1 TDD para Agentes (AI Evals)

Diferente de sistemas determinísticos, agentes de IA podem ter saídas variadas. O TDD aqui assume o papel de **Avaliação de IA (Evals)**. 

*   **Red:** Definimos um cenário de entrada (ex: uma frase ambígua sobre um app de barbearia) e o que esperamos que o agente faça (ex: identificar o stakeholder "Barbeiro" e perguntar sobre o "horário de funcionamento"). Se o agente atual ignora isso, o teste "falhou".
*   **Green:** Ajustamos o prompt (instruções do agente) ou adicionamos um catálogo seed (ex: `stakeholders-tipicos.md`) para que o agente passe a detectar esses elementos corretamente.
*   **Refactor:** Otimizamos o prompt para ser mais conciso ou econômico em tokens, garantindo que ele continue passando no teste.

### 2.2 Garantia de Qualidade dos Requisitos (IREB/ISO)

A ferramenta visa gerar um SRS (Software Requirements Specification) seguindo padrões internacionais. O TDD permite "codificar" esses padrões como testes:

*   **Teste de Verificabilidade:** Todo requisito funcional deve ter um critério de aceitação.
*   **Teste de Não-Ambiguidade:** O agente NLP deve sinalizar termos vagos (ex: "rápido", "fácil", "amigável").
*   **Teste de Completude:** O SRS não pode ser finalizado se houver pautas de re-elicitação pendentes.

Ao aplicar TDD, transformamos os checklists de qualidade (como o `checklist.md` do Marco 1) em **requisitos de teste** que guiam o desenvolvimento de cada skill.

---

## 3. Estratégia de Implementação no TCC

Atualmente, o projeto já possui uma estrutura embrionária de TDD em `ferramenta-tcc/tests/marco-1/`, com casos de uso e checklists manuais. Para agregar valor real, propõe-se a seguinte evolução:

### 3.1 Automatização da Validação
Criar um **Agente Avaliador** cuja única função é ler os arquivos gerados em uma sessão (ex: `marco-1/stakeholders.md`) e validar contra o `checklist.md` de forma automática. Isso acelera o ciclo de desenvolvimento das skills.

### 3.2 TDD de Prompt
Antes de implementar uma nova skill (ex: `requisito-ears`), deve-se:
1.  Criar o arquivo de teste (ex: `tests/marco-3/srs-quality.md`) com exemplos de entradas ruins e as correções esperadas.
2.  Implementar o prompt da skill.
3.  Rodar o teste para validar se o agente aplica corretamente a sintaxe EARS.

### 3.3 Rastreabilidade de Testes
Vincular cada critério do `checklist-ireb.md` a um caso de teste específico. Se o TCC mudar uma instrução para ser mais "amigável", os testes garantem que essa mudança não quebrou a conformidade com as normas técnicas da ER.

---

## 4. Conclusão

O TDD não é apenas uma prática de programação, mas uma **filosofia de garantia de qualidade**. Para uma ferramenta que automatiza o papel de um Analista de Requisitos, a confiabilidade é o ativo mais importante. Utilizar TDD garante que o sistema não apenas "funciona", mas que ele produz requisitos robustos, verificáveis e úteis para o desenvolvimento de software real, reduzindo o risco de falhas nos projetos dos usuários.
