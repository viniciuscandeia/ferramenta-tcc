# Elicitação Assistida por Agentes de IA em Linha de Comando: uma abordagem dirigida por perguntas para a Engenharia de Requisitos

**Autor:** Vinicius Candeia  
**Data:** Maio de 2026

---

## 1. Contextualização

A Engenharia de Requisitos (ER) é reconhecida como uma das etapas mais críticas do desenvolvimento de software. Segundo o IREB CPRE Foundation Level Handbook, requisitos mal definidos são uma das causas mais recorrentes de falhas em projetos de software, gerando retrabalho, estouro de cronograma e insatisfação dos stakeholders. Wiegers e Beatty (2013) corroboram essa perspectiva ao afirmar que problemas de comunicação entre desenvolvedores e usuários — frequentemente originados em uma elicitação deficiente — representam a principal fonte de defeitos ao longo do ciclo de vida do software.

Nos últimos anos, Modelos de Linguagem de Grande Escala (LLMs, do inglês *Large Language Models*) e ferramentas de agentes de IA em linha de comando (como Gemini CLI e Claude Code) emergiram como uma nova superfície tecnológica para apoiar atividades de desenvolvimento. Contudo, a aplicação dessas ferramentas à ER — especialmente à fase de elicitação — permanece pouco explorada de forma estruturada e metodicamente fundamentada.

---

## 2. Problema de Pesquisa

As ferramentas baseadas em LLM disponíveis hoje (ChatGPT, GitHub Copilot, Gemini, entre outras) operam em **modo chat reativo**: o usuário conduz a conversa, formula as perguntas e decide o que explorar. Esse modelo pressupõe que o interlocutor humano já possua maturidade em Engenharia de Requisitos — o que frequentemente não ocorre, sobretudo em equipes de startups, pequenas e médias empresas, ou em estudantes em fase inicial de formação.

Por outro lado, as ferramentas tradicionais de gestão de requisitos (Jira, IBM DOORS, Azure DevOps) destinam-se ao **gerenciamento** de requisitos já existentes, e não à sua elicitação e descoberta.

Existe, portanto, uma lacuna: **não há ferramenta amplamente adotada que conduza ativamente o processo de elicitação de requisitos, guiando o usuário por meio de perguntas estruturadas fundamentadas em técnicas validadas de ER.** A questão que motiva este trabalho é: é possível preencher essa lacuna por meio de agentes de IA em linha de comando, invertendo o protocolo de interação — de modo que a IA dirija a entrevista e o usuário apenas responda?

---

## 3. Justificativa

Agentes de IA em linha de comando, como o Gemini CLI, já disponibilizam primitivas técnicas que viabilizam a inversão do protocolo de interação: subagentes especializados, skills configuráveis e ferramentas de interação estruturada com o usuário (como a ferramenta `ask_user`, que oferece perguntas de texto livre, múltipla escolha e confirmação). Essas primitivas permitem modelar o processo de elicitação como um fluxo guiado, no qual cada etapa corresponde a uma técnica de ER mapeada em um componente da ferramenta.

Adicionalmente, existe um corpo de conhecimento consolidado em ER — sistematizado em referências como o IREB CPRE Handbook, Wiegers (2013), Cohn (2004) e obras nacionais em Engenharia de Requisitos — que pode ser destilado em prompts e instruções estruturadas para agentes de IA. A combinação desse conhecimento teórico com as capacidades técnicas das plataformas modernas representa uma oportunidade concreta de desenvolver uma ferramenta com respaldo científico e utilidade prática.

Por fim, do ponto de vista acadêmico, este trabalho oferece ao autor experiência aplicada com plataformas de IA de ponta, além de produzir um artefato tangível e avaliável: uma ferramenta funcional validada em estudo de caso.

---

## 4. Objetivos

### 4.1 Objetivo Geral

Desenvolver e avaliar uma ferramenta baseada em agentes de IA em linha de comando que conduza a elicitação e a documentação de requisitos de software por meio de perguntas estruturadas ao usuário, fundamentadas em técnicas validadas de Engenharia de Requisitos.

### 4.2 Objetivos Específicos

1. Sistematizar, a partir da literatura especializada, as técnicas de elicitação de requisitos e a estrutura canônica de um documento de especificação de requisitos de software (SRS).
2. Projetar a arquitetura da ferramenta em termos de subagentes e skills do Gemini CLI, mapeando cada técnica de elicitação a um componente da ferramenta.
3. Implementar uma versão funcional da ferramenta no Gemini CLI, capaz de gerar um SRS a partir de uma descrição inicial fornecida pelo usuário.
4. Avaliar a abordagem por meio de um estudo de caso com um projeto real, comparando o documento gerado pela ferramenta a um documento de referência produzido por método tradicional.
5. *(Extensão, condicionada ao tempo disponível)* Portar a ferramenta para o Claude Code, demonstrando a portabilidade da abordagem entre plataformas de agentes de IA.

---

## 5. Perguntas de Pesquisa

- **PP1:** Uma ferramenta dirigida por perguntas, fundamentada em técnicas validadas de ER, é capaz de gerar documentos de requisitos com qualidade comparável à elicitação conduzida pelo método tradicional?
- **PP2:** Quais técnicas de elicitação de requisitos se traduzem adequadamente para um formato automatizado baseado em agentes, e quais demandam presença e julgamento humano para serem efetivas?
- **PP3:** O modelo de subagentes e skills, disponível em plataformas de IA em linha de comando, é adequado para estruturar o processo de elicitação de requisitos, ou impõe limitações relevantes à qualidade do resultado?

---

## 6. Fundamentação Teórica

O referencial teórico deste trabalho compreende as seguintes áreas e obras-âncora:

- **Engenharia de Requisitos:** IREB CPRE Foundation Level Handbook v1.2 (2023); Wiegers e Beatty, *Software Requirements* (3ª ed., 2013); Bezerra, *Engenharia de Requisitos: Da demanda ao gerenciamento*; Carvalho e Chiossi, *Engenharia de Requisitos: Software Orientado ao Negócio*; Vazquez e Simões, *Engenharia de Requisitos: como levantar, documentar e validar*.
- **Histórias de usuário e especificação ágil:** Cohn, *User Stories Applied* (2004).
- **Agentes de IA em linha de comando:** documentação oficial do Gemini CLI (Google) e do Claude Code (Anthropic); literatura sobre agentes baseados em LLM e arquiteturas multi-agente.

---

## 7. Metodologia

A pesquisa é de natureza **aplicada**, caráter **exploratório** e abordagem predominantemente **qualitativa**, conduzida por meio de um **estudo de caso único** (YIN, 2014).

O desenvolvimento seguirá as seguintes etapas:

1. **Revisão bibliográfica dirigida:** leitura analítica da literatura de ER para extrair (a) a estrutura canônica de um SRS, (b) um catálogo de técnicas de elicitação aplicáveis ao formato agente e (c) critérios de qualidade de requisitos (verificabilidade, não-ambiguidade, completude, rastreabilidade).

2. **Modelagem da arquitetura:** definição do conjunto de subagentes (ex.: agente entrevistador, agente classificador, agente revisor) e skills (ex.: skill de elicitação por entrevista estruturada, skill de identificação de ambiguidades), com o mapeamento do fluxo de execução.

3. **Implementação no Gemini CLI:** desenvolvimento iterativo da ferramenta, com reuso das primitivas `ask_user` e do sistema de skills já explorados em protótipos anteriores.

4. **Execução do estudo de caso:** seleção de um projeto de software real (a definir com o orientador), aplicação da ferramenta com o(s) stakeholder(s) do projeto e geração do SRS resultante.

5. **Análise comparativa:** avaliação do SRS gerado com base em rubrica de qualidade derivada da etapa 1, comparando-o a um documento de referência (produzido pelo método tradicional ou avaliado por critérios IREB).

---

## 8. Resultados Esperados

- Ferramenta funcional executável via Gemini CLI para elicitação e geração de SRS.
- Catálogo de técnicas de elicitação mapeadas em componentes de agente.
- Documento de requisitos produzido durante o estudo de caso.
- Análise comparativa documentada entre a abordagem proposta e o método tradicional.
- Conjunto de skills e subagentes reutilizáveis, publicados como artefato do trabalho.

---

## 9. Cronograma

**Prazo total:** 06/05/2026 a 01/07/2026 (≈ 8 semanas)

| Semana | Período | Atividade principal |
|--------|---------|---------------------|
| 1 | 06–12/mai | Finalização do pré-projeto; alinhamento com orientador; início da revisão bibliográfica |
| 2 | 13–19/mai | Conclusão da revisão bibliográfica; consolidação do catálogo de técnicas e estrutura do SRS |
| 3 | 20–26/mai | Modelagem da arquitetura; desenvolvimento do protótipo mínimo (uma skill ponta a ponta) |
| 4 | 27/mai–02/jun | Implementação completa da ferramenta no Gemini CLI |
| 5 | 03–09/jun | Seleção e preparação do caso de estudo; testes internos da ferramenta |
| 6 | 10–16/jun | Execução do estudo de caso |
| 7 | 17–23/jun | Análise comparativa dos resultados; redação do TCC |
| 8 | 24/jun–01/jul | Revisão final e entrega |

**Risco principal:** o cronograma é comprimido e oferece pouca folga para imprevistos. A mitigação adotada é tratar o objetivo de porte para o Claude Code como extensão opcional, que será executada apenas se o desenvolvimento principal concluir dentro do prazo previsto.

---

## 10. Referências Bibliográficas

BEZERRA, E. *Engenharia de Requisitos: Da demanda ao gerenciamento*. Rio de Janeiro: Elsevier.

CARVALHO, A. M. B. R.; CHIOSSI, T. C. S. *Engenharia de Requisitos: Software Orientado ao Negócio*. São Paulo: Érica.

COHN, M. *User Stories Applied: For Agile Software Development*. Boston: Addison-Wesley, 2004.

IREB. *CPRE Foundation Level Handbook*. v1.2. International Requirements Engineering Board, 2023.

VAZQUEZ, C. E.; SIMÕES, G. S. *Engenharia de Requisitos: como levantar, documentar e validar*. São Paulo: Brasport.

WIEGERS, K.; BEATTY, J. *Software Requirements*. 3. ed. Redmond: Microsoft Press, 2013.

YIN, R. K. *Estudo de caso: planejamento e métodos*. 5. ed. Porto Alegre: Bookman, 2014.

GOOGLE. *Gemini CLI Documentation*. Disponível em: <https://github.com/google-gemini/gemini-cli>. Acesso em: maio 2026.

ANTHROPIC. *Claude Code Documentation*. Disponível em: <https://docs.anthropic.com/claude/docs/claude-code>. Acesso em: maio 2026.
