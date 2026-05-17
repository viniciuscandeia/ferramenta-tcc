# Conceitos: Tipos de Requisitos, Restrições e Premissas

Este guia define a taxonomia de informações que a ferramenta deve coletar e classificar durante o processo de Engenharia de Requisitos (ER).

---

## 1. Níveis de Requisitos (Hierarquia)
Para uma elicitação completa, a IA deve identificar requisitos em três níveis:
- **Requisitos de Negócio (Business Requirements):** Objetivos de alto nível da organização (Por que o projeto existe?). Devem ser **SMART** (Específicos, Mensuráveis, Atingíveis, Relevantes e Temporais).
- **Requisitos de Stakeholder (User Requirements):** Necessidades das pessoas envolvidas (O que eles precisam fazer?). Geralmente expressos em linguagem natural ou User Stories.
- **Requisitos de Solução:** Detalhamento técnico do que será construído (RFs e RNFs).

## 2. Requisito Funcional (RF)
**Definição:** Descreve o comportamento esperado do software, ou seja, as funções que o sistema deve executar para atender aos objetivos do usuário.
- **Foco:** "O que" o sistema faz.
- **Exemplo Técnico:** "O sistema deve permitir o cadastro de pacientes."
- **Linguagem p/ Usuário (D1):** "O que o produto precisa fazer para te ajudar."

## 3. Requisito Não-Funcional (RNF) / Requisito de Qualidade
**Definição:** Descreve qualidades, características ou níveis de serviço que o sistema deve possuir. Baseado na **ISO/IEC 25010**.
- **Categorias Principais (FURPS+):** Funcionalidade, Usabilidade, Confiabilidade (Reliability), Desempenho (Performance), Suportabilidade.
- **Dica de Elicitação:** RNFs são frequentemente "requisitos de prateleira" (catálogos) que o usuário esquece de mencionar.
- **Linguagem p/ Usuário (D1):** "Como você espera que o produto funcione (rapidez, segurança, facilidade)."

## 4. Restrição
**Definição:** Limitações impostas ao espaço de solução. Diferente do RNF (que é uma qualidade), a restrição impõe uma escolha técnica, legal ou organizacional inegociável.
- **Exemplo:** "Deve rodar em servidores on-premise", "Conformidade com LGPD".
- **Linguagem p/ Usuário (D1):** "Regras ou limites que não podemos mudar (leis, tecnologias que você já usa)."

## 5. Premissa
**Definição:** Suposições acreditadas como verdadeiras para que o projeto avance.
- **Dica:** Toda premissa é um risco em potencial se for provada falsa.
- **Linguagem p/ Usuário (D1):** "O que estamos imaginando que já existe ou que vai acontecer para o projeto dar certo."

---

### Tabela Comparativa

| Tipo | Pergunta Principal | Foco | Característica |
|---|---|---|---|
| **Negócio** | Por que construir? | Valor/Objetivo | Estratégico |
| **RF** | O que o sistema faz? | Ação/Função | Comportamental |
| **RNF** | Como o sistema faz? | Atributo/Qualidade | Operacional |
| **Restrição** | O que limita o sistema? | Limite Externo | Inegociável |
| **Premissa** | O que supomos? | Suposição | Hipótese |
