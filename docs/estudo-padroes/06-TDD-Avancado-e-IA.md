# Test-Driven Development (TDD) Avançado e IA

Este documento expande os conceitos básicos de TDD (veja `02-Test-Driven-Development.md`), abordando técnicas avançadas de arquitetura guiada por testes e o paradigma emergente do TDD no ecossistema de Agentes de IA (2025-2026).

---

## 1. Técnicas Avançadas de TDD (Arquitetura)

O TDD avançado vai além de "testar se a função retorna o valor certo". Ele usa os testes para forçar o design da arquitetura.

- **Triangulação (Triangulation):** Uma técnica onde, na dúvida sobre como implementar a lógica geral, você escreve testes para casos específicos extremos. Ao tentar fazer todos os casos específicos passarem simultaneamente, a lógica geral "emerge" naturalmente.
- **Premissa de Prioridade de Transformação (TPP):** Desenvolvida por Robert C. Martin (Uncle Bob), é uma lista que dita a ordem de complexidade das refatorações. Ao passar do RED para o GREEN, o desenvolvedor deve aplicar a "transformação mais simples possível" (ex: trocar uma constante por uma variável é mais simples do que adicionar um `if`).
- **Walking Skeleton:** Começar um projeto inteiro escrevendo um único teste E2E (End-to-End) que atravessa toda a stack (UI → API → Banco de Dados). Isso força a resolução dos problemas de infraestrutura ("encanamento") antes da escrita de qualquer regra de negócio.

---

## 2. O Paradigma do Workflow Agêntico (TDD com IA)

A ascensão de agentes de IA mudou radicalmente a economia de escrever testes. Testes deixam de ser apenas um "imposto de segurança" e tornam-se a **interface de comunicação primária** entre o humano e o agente de codificação.

### Testes como Prompts de Alto Sinal
- Fornecer instruções em linguagem natural para um agente (ex: "faça uma função de login") deixa margem para alucinação.
- Fornecer uma suite de testes que falha é a instrução perfeita: é inambígua e o agente sabe exatamente quando terminou (quando os testes ficarem GREEN).

### Test-Driven Generation (TDG)
O fluxo moderno de codificação com agentes funciona em etapas:
1. **Geração de Testes:** O humano (ou um agente de especificação) fornece o requisito. Um agente escreve a suite de testes unitários ou de aceitação.
2. **Revisão:** O humano revisa os testes gerados (muito mais rápido do que revisar código de produção).
3. **Implementação:** O agente é instruído a "escrever o código de produção que faça essa suite passar".

### The "Brute-Force" Loop (Auto-Correção)
Quando um agente escreve um código que falha, o desenvolvedor não precisa depurar. O fluxo é:
1. Rodar os testes.
2. Se falhar, copiar a `stack trace` (mensagem de erro).
3. Devolver a `stack trace` ao agente: *"O teste X falhou com o erro Y. Corrija a implementação."*
O agente utiliza o erro como "dica" de raciocínio para alterar sua abordagem.

---

## 3. Conexão com a Ferramenta de TCC

A ferramenta de Elicitação de Requisitos pode se beneficiar fortemente do conceito de **Test-Driven Generation (TDG)**:

- Uma vez que os requisitos (e regras de negócio) são elicitados e os conflitos resolvidos, a ferramenta pode ter uma skill final que gera as **Especificações Executáveis (Testes de Aceitação)**.
- Isso assegura a diretriz de **"Ambiguidade Zero"**: se o agente não consegue gerar um teste de aceitação para o requisito levantado, o requisito está mal definido e a ferramenta deve fazer mais perguntas ao stakeholder.
