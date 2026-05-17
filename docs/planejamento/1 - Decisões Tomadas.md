# Decisões de Design — Ferramenta de Elicitação de Requisitos

**Data:** 2026-05-06 | **Atualizado:** 2026-05-17 com D12-D19 ([5 - Revisão D12-D19.md](5%20-%20Revisão%20D12-D19.md)) e D20-D24 ([6 - Deliberação-D20-D24.md](6%20-%20Deliberação-D20-D24.md))
**Método:** brainstorming guiado com Claude Code (D1-D11) + revisão de mercado estruturada (D12-D19) + deliberação sobre extensão SDD/TDD (D20-D24)
**Referência completa:** `docs/arquitetura-agentes-skills.md`

---

## Decisões fundadoras

| # | Decisão | Opção escolhida | Alternativas consideradas | Justificativa |
|---|---------|-----------------|---------------------------|---------------|
| D1 | **Usuário-alvo** | Stakeholder/cliente leigo | Desenvolvedor solo; Analista júnior; Estudante | Maior impacto: a ferramenta substitui integralmente o analista. Exige linguagem sem jargão e mitigação ativa do "óbvio não-dito" (Livro SON §4.4) |
| D2 | **Escopo de etapas** | 5 etapas + Gerência transversal | Pipeline reduzido (3); Foco em elicitação+SRS | Cobre o que o material da professora descreve como processo completo de ER |
| D3 | **Fluxo entre agentes** | Marcos com gates de aprovação | Linear com loops; Orquestrador central; Sequencial rígido | Pedagogicamente claro para o leigo; alinhado ao Livro SON §6.2-§6.4 (Marco 1, 2, 3) |
| D4 | **Template de SRS** | IREB §3.3.3 (ISO/IEC/IEEE 29148) | IEEE 830 alinhado à professora; Template Livro 1; Híbrido | Padrão internacional defensável academicamente |
| D5 | **Formatos de entrada** | Aceitar frase / situação-problema / texto livre | Apenas frase curta; Apenas situação-problema; Apenas texto longo | Flexibilidade para o leigo que não sabe qual formato usar |
| D6 | **Funções transversais** | Sub-agentes invocáveis | Skills compartilhadas; Embutidas em cada agente; Mix | Maior isolamento e defensabilidade como "arquitetura multi-agente" |
| D7 | **Granularidade interna** | Abordagem híbrida (agente-etapa + skills por técnica) | Lean (só agentes-etapa); Hierárquico denso (sub-agentes por técnica) | Reuso máximo com prompts focados; sem explosão de agentes como na opção hierárquica |
| D8 | **Sintaxe de requisitos** | EARS + slots estruturados + RFC 2119 | Apenas EARS; Apenas slots; Apenas RFC 2119 | Combina legibilidade EARS, disciplina linguística (slots sujeito/verbo/objeto/condição) e rigor normativo; inspirado no Problem-Based-SRS (Gorski & Stadzisz, RESI 2016) |
| D9 | **Skill de priorização** | Skill única `priorizacao` com sub-rotinas | 3 skills separadas (MoSCoW, Kano, IEEE) | Reduz superfície de manutenção sem perder técnicas; MoSCoW executado sempre (MVP); Kano e IEEE como sub-rotinas stretch acessíveis pela mesma skill |
| D10 | **Recuperação de estado** | Detection-based (Gerência infere marco lendo artefatos) | Sessão persistente; arquivo dedicado de estado | Habilita interrupção e retomada transparentes; nenhum agente depende de sessão persistente; essencial para reprodutibilidade do estudo de caso |
| D11 | **Empacotamento e porte** | Gemini CLI extension + Claude Code plugin desde Semana 1; porte CC como objetivo MVP | Só Gemini CLI; porte CC como stretch condicional | Garante artefato distribuível; elimina risco de prazo do porte ao iniciar empacotamento desde o início |
| D12 | **Engine canônico vs. adapter por IDE** | Lógica de prompt/agentes em diretório agnóstico de plataforma; adapters (`.gemini/`, `.claude/`) mapeiam primitivas sem redefinir comportamento | Engine por IDE (duplicação de conteúdo); adapter pesado (lógica duplicada) | Torna porte Claude Code (D11) adaptação de interface, não reescrita; inspirado no Spec-Flow |
| D13 | **Estado do workflow** | `estado-projeto.yaml` como SoT primário; detection-based (D10) como fallback quando yaml ausente ou ilegível | Só detection-based (D10 puro); Só yaml sem fallback | Recovery determinístico sem eliminar a resiliência do D10; yaml vence em conflito; detection-based ativado apenas quando yaml ausente |
| D14 | **Question batching** | Agentes coletam todas as perguntas antes de invocar `ask_user`, em lotes de até 4 | Perguntas individuais conforme surgirem; sem limite formalizado | Formaliza restrição da primitiva como regra de design; previne fragmentação da experiência do leigo em micro-turnos |
| D15 | **Guardrails em runtime** | `constitution.md` por projeto codificando D1-D11 como filtro carregado por todos os agentes em runtime | Guardrails só em CLAUDE.md (fora do contexto de execução); checklist manual por agente | Garante que novas versões de agentes não produzam artefatos incompatíveis com as premissas fundadoras |
| D16 | **Sub-fase de clarificação pré-elicitação** | Micro-fase após Agente Visão detecta lacunas críticas e resolve via `ask_user` (máx. 3 perguntas; só ativada se ≥ 2 lacunas críticas em escopo/terminologia/restrições) | Sem sub-fase (Ag. Elicitação cobre tudo); sub-fase sem limite de perguntas | Resolve ambiguidades estruturais antes da elicitação profunda sem sobrecarregar o leigo |
| D17 | **Validação cross-artifact pré-gate M3** | Agente Validação checa consistência Visão↔Elicitação↔SRS com severidades CRITICAL/HIGH/MEDIUM/LOW; CRITICAL bloqueia gate M3 | Gate M3 sem checagem prévia; validação só por rubrica IREB §3.8 | Contradições entre artefatos detectadas antes da apresentação ao leigo; evita retrabalho de toda a elicitação |
| D18 | **Versões leigo + normativa por artefato-gate** | Cada artefato-gate gera versão normativa (IREB §3.3.3 + RFC 2119) e versão leigo; leigo aprova versão leigo; equipe técnica recebe versão normativa | Só versão normativa (leigo revisa com auxílio); versão leigo informal sem skill dedicada | Gate com artefato IREB direto é gate cosmético para o leigo; D18 torna os gates M1/M2/M3 funcionalmente reais |
| D19 | **Enforcement de jargão em runtime** | Skill `tradução-leigo` transversal invocável por qualquer agente antes de apresentar texto ao usuário; generaliza `retraducao-leiga` do Ag. Validação | Blacklist só em CLAUDE.md sem verificação em runtime; skill só no Ag. Validação | Garante que a regra D1 (sem jargão) seja verificável em runtime por qualquer agente, não apenas pelo Validação |
| D20 | **Escopo de geração de specs** | Gerar cenários Gherkin apenas para RFs marcados `DEVE` (RFC 2119); RFs `DEVERIA` e `PODE` ficam sem spec automática | Cobertura completa (todos os RFs); completa com classificação CORE/EXTENDED/EDGE | Critério objetivo já presente no SRS; RFs menos críticos gerariam ruído no repositório de saída |
| D21 | **Tratamento de RNFs na spec** | `TESTING-STRATEGY.md` por RNF: categoria, ferramenta sugerida, métrica, sinalização quando automação é inviável | Omitir RNFs da fase de spec; gerar checks automatizados para RNFs mensuráveis | RNFs subjetivos resistem à spec executável; documento de estratégia é honesto e educativo sem gerar specs quebradas |
| D22 | **Formato único de specs** | Gherkin como único formato de spec executável; OpenAPI documentado como evolução v2.0 não comprometida | OpenAPI + Gherkin por tipo de domínio; Gherkin + YAML inline | Um formato, uma ferramenta; agnóstico de plataforma (alinha com D12); OpenAPI requer toolchain específico que excede o prazo 2026-07-01 |
| D23 | **Toolchain de testes** | `README-TESTS.md` dedicado no repositório de saída com instruções para 3 frameworks (Pytest-BDD, Cucumber-js, SpecFlow) | Instruções inline no SRS em seção Anexos; detectar linguagem via nova pergunta ao leigo | Mantém SRS com separação de responsabilidades; template genérico suficiente para MVP; leigo não sabe responder sobre linguagem |
| D24 | **Gate M4 — revisão técnica** | Gate M3 inalterado (só SRS para leigo) + Gate M4 novo opcional: desenvolvedor/tech lead revisa `spec/`, `tests/`, `TESTING-STRATEGY.md` e aprova `aprovacao-tecnica.md` | M3 inalterado sem M4; M3 estendido com resumo de exemplos traduzidos | Separação de persona correta: M3 valida intenção (leigo), M4 valida verificabilidade (técnico); M4 opcional preserva viabilidade no prazo |

---

## Consequências de cada decisão

### D1 — Usuário leigo
- Todas as perguntas geradas pela ferramenta devem ser em linguagem natural, sem termos técnicos de ER
- A skill `retraducao-leiga` é obrigatória (MVP) no Agente Validação
- O sub-agente Implícitos é especialmente crítico — o leigo não sabe o que não sabe

### D3 — Marcos com gates
- Loops são permitidos *dentro* de cada marco; proibidos entre marcos sem gate aprovado
- Gate 2 tem condição de bloqueio explícita: só abre se `pautas-reelicitacao.md` estiver vazio
- Gerência cria um baseline (snapshot + tag git) após cada gate aprovado
- Gerência infere marco corrente lendo artefatos no disco — não depende de sessão persistente (ver D10)

### D4 — IREB §3.3.3
- A estrutura de saída do Agente SRS tem 6 seções de requisitos (funcionais, qualidade, restrições, interfaces, glossário, pressupostos)
- Os critérios de validação vêm do IREB §3.8 (6 por requisito + 6 por SRS)
- Distância dos exemplos da professora: mitigação = manter `checklist-livro-1.md` em paralelo
- RFC 2119/BCP 14 sobreposta ao EARS para linguagem normativa MUST/SHOULD/MAY (ver D8)

### D6 — Sub-agentes invocáveis (vs. skills)
- Sub-agentes têm ciclo de vida próprio; recebem contexto, processam, retornam resultado
- Nenhum sub-agente transversal tem estado próprio entre invocações
- Diferença de granularidade: sub-agente = capacidade de processamento; skill = técnica/roteiro específico

### D7 — Abordagem híbrida
- Cada agente-etapa é dono do fluxo da sua etapa, mas delega técnicas específicas a skills
- Skills são SKILL.md auto-detectáveis pelo Gemini CLI via match de descrição
- Risco: colisão de descrições entre skills similares → mitigação: nomes e descrições distintos por skill

### D8 — Sintaxe estruturada + RFC 2119
- Requisitos gerados seguem template fixo com slots (sujeito/verbo/objeto/condição) sobreposto ao EARS
- Modificadores RFC 2119 (MUST/SHOULD/MAY) obrigatórios em RNFs; opcionais em RFs
- Implementação: skill `requisito-ears` (Semana 4) incorpora os slots e os modificadores na geração
- Benefício: habilita validação programática da completude e do rigor normativo da saída

### D9 — Skill de priorização consolidada
- Skill `priorizacao` substitui as anteriores `priorizacao-moscow`, `priorizacao-kano` e `priorizacao-ieee`
- Sub-rotina MoSCoW é executada sempre (MVP); Kano e IEEE são sub-rotinas stretch ativadas conforme necessidade
- Cronograma da Semana 3 atualizado: implementar `priorizacao/SKILL.md` em vez de três arquivos separados

### D10 — Detection-based recovery
- Nova skill MVP do Agente Gerência: `detection-based-recovery`
- Lê artefatos existentes no disco para inferir em qual marco o projeto está; não depende de variável de sessão
- Elimina dependência de sessão contínua — essencial para o estudo de caso com stakeholder real (sessões podem ser interrompidas e retomadas)

### D11 — Empacotamento e porte Claude Code
- `gemini-extension.json` e `.claude-plugin/plugin.json` criados na Semana 1, em paralelo ao setup do repositório
- Porte Claude Code deixa de ser stretch condicional — é objetivo MVP confirmado
- Risco mitigado: o porte é majorariamente trabalho de manifesto e adaptação de frontmatter, não reescrita de lógica
- Mitigação anterior ("cortado se Semana 5 atrasar") removida do cronograma e das mitigações de risco

### D12 — Engine canônico vs. adapter por IDE
- Toda a lógica de prompt e de orquestração de agentes reside em diretório agnóstico de plataforma (ex: `ferramenta-tcc/core/`)
- Adapters `.gemini/` e `.claude/` contêm apenas mapeamento de primitivas e manifestos de instalação — sem lógica de negócio
- Consequência direta: porte Claude Code (D11) é adaptação de interface, não reescrita; adicionar futuro porte Gemini CLI → Copilot CLI segue o mesmo padrão

### D13 — Estado do workflow
- O Agente Gerência cria e mantém `estado-projeto.yaml` ao final de cada sub-fase com: marco corrente, sub-fase, artefatos produzidos, pautas abertas
- Recovery padrão: ler `estado-projeto.yaml`; se ausente ou ilegível, ativar detection-based (D10)
- `estado-projeto.yaml` vence em conflito com artefatos no disco
- Formato e campos do yaml a definir antes da implementação do Agente Gerência

### D14 — Question batching
- Todo agente-etapa e sub-agente transversal deve coletar todas as perguntas necessárias antes de invocar `ask_user`
- Perguntas são agrupadas em lotes de até 4 (limite da primitiva)
- Proibido invocar `ask_user` individualmente por gap detectado — cada invocação individual é uma violação do batching
- Sub-agentes apátridas: batching deve ocorrer dentro da invocação única (sem múltiplas chamadas de `ask_user` pela mesma invocação)

### D15 — Guardrails em runtime
- `constitution.md` é criado pelo Agente Gerência no início de cada projeto, a partir de template fixo derivado de D1-D19
- Todos os agentes-etapa e sub-agentes transversais carregam `constitution.md` no início de cada invocação
- `constitution.md` não é editável pelo usuário durante o projeto — é artefato de sistema, não de negócio
- Versão do `constitution.md` é versionada junto com os outros artefatos do projeto no git

### D16 — Sub-fase de clarificação pré-elicitação
- Implementada como skill ou micro-rotina executada pelo Agente Visão após gerar `visao-produto.md`
- Condição de ativação: detectar lacunas em ≥ 2 das 3 categorias críticas (escopo funcional, terminologia do domínio, restrições de negócio)
- Se condição não atendida: handoff direto para Agente Elicitação sem perguntas adicionais
- Quando ativada: exatamente 1 chamada `ask_user` com no máximo 3 perguntas (choice/yesno — sem prosa livre)
- Respostas do leigo são incorporadas a `visao-produto.md` antes do handoff

### D17 — Validação cross-artifact pré-gate M3
- Agente Validação executa checagem de consistência entre `visao-produto.md`, artefatos de elicitação e SRS antes de apresentar ao leigo
- Severidades: CRITICAL (bloqueia gate M3), HIGH (exibido com destaque no resumo leigo), MEDIUM/LOW (nota informativa)
- Gate M3 só é apresentado ao leigo após ausência de issues CRITICAL
- Issues HIGH e MEDIUM não bloqueiam o gate, mas aparecem na versão leigo (D18) com linguagem acessível
- Checklist IREB §3.8 pode ser integrada como camada adicional desta fase

### D18 — Versões leigo + normativa por artefato-gate
- Cada artefato de gate tem dois outputs: versão normativa (IREB §3.3.3 + EARS + RFC 2119) e versão leigo
- Versão leigo usa linguagem de dono de negócio, sem jargão ER (verificada pela skill D19)
- O leigo recebe e aprova apenas a versão leigo no gate; a versão normativa é gerada em paralelo para a equipe técnica
- Implementação: skill `traducao-gate` invocada pelo agente responsável pelo gate antes de apresentar ao usuário
- Ambas as versões são artefatos versionados no git

### D19 — Enforcement de jargão em runtime
- Skill `tradução-leigo` recebe um trecho de texto, verifica presença de termos da blacklist (D1), e retorna versão reescrita em linguagem de negócio
- Blacklist operacional: lista extraída de D1 (proibidos: "requisito funcional", "elicitação", "stakeholder", "escopo", "backlog", etc.)
- Invocação obrigatória: qualquer agente que apresente texto ao usuário deve invocar `tradução-leigo` antes de exibir
- Generaliza a skill `retraducao-leiga` prevista no Agente Validação — a versão genérica substitui a versão específica
- Skill apátrida: sem estado entre invocações; contexto = apenas o trecho de texto recebido

### D20 — Escopo de geração de specs
- Skill `sdd-spec-generator` (Agente SRS) lê RFs com modal `DEVE` do `03.1-funcionais.md` e gera cenários Gherkin em `marco-3/spec/*.feature`
- RFs com `DEVERIA` e `PODE` não recebem spec automática — ficam documentados apenas no SRS
- Tensão T6: se o SRS tiver campo de prioridade separado além do modal, a skill usa o campo como critério primário; a ser resolvida na implementação da skill

### D21 — Tratamento de RNFs na spec
- Skill `testing-strategy-generator` (Agente Validação) lê `03.2-qualidade.md` e gera `marco-3/TESTING-STRATEGY.md`
- Cada RNF recebe: categoria (desempenho / segurança / usabilidade / disponibilidade), ferramenta sugerida (k6, OWASP ZAP, Lighthouse, teste manual), métrica de referência quando disponível, sinalização explícita quando automação é inviável
- Evolução natural: D21-v2 pode gerar checks automatizados para RNFs mensuráveis em versão futura

### D22 — Formato único de specs
- `spec/*.feature` usa Gherkin puro; compatível com Cucumber, Pytest-BDD e SpecFlow sem adaptação
- OpenAPI documentado como "evolução prevista, não comprometida" — não implementado no MVP 2026-07-01
- Coerência com D12: Gherkin funciona nos adapters Gemini CLI e Claude Code sem adaptação de formato

### D23 — Toolchain de testes
- Skill `readme-tests-generator` (Agente Gerência) invocada após Gate 3; gera `marco-3/README-TESTS.md`
- Template cobre: o que foi gerado, por que está em estado RED, como instalar/rodar em Python (Pytest-BDD), JavaScript (Cucumber-js) e .NET (SpecFlow)
- Mantém `SRS-completo.md` com responsabilidade única — documento de requisitos, não guia de ambiente

### D24 — Gate M4 — revisão técnica
- Marco M4 é opcional no MVP: a ferramenta entrega o repositório após Gate 3 mesmo sem M4; Agente Gerência sinaliza M4 como próxima etapa recomendada
- Artefatos: `marco-4/revisao-tecnica.md` (checklist) + `marco-4/aprovacao-tecnica.md` (baseline aceito pelo técnico)
- Agente Gerência é mediador — gera checklist e registra aprovação quando conduzido
- Tensão T5: novo marco amplia escopo do TCC; impacto no ROADMAP semana 5

---

## Análise comparativa com trabalho correlato (Problem-Based-SRS)

O **Problem-Based-SRS** (Rafael Gorski, github.com/RafaelGorski/Problem-Based-SRS) é um projeto correlato ativo: distribuído como plugin Claude Code e *AgentSkills standard* multi-plataforma, baseado em metodologia *peer-reviewed* (Gorski & Stadzisz, DOI 10.21529/RESI.2016.1502002, RESI 2016), com versões v1.0 a v1.2 publicadas entre jan–mar 2026. Faz elicitação de requisitos guiada por IA, porém com público-alvo **distinto** — equipes técnicas usando assistentes de IA, não stakeholders leigos — o que torna a comparação especialmente relevante para situar as decisões D1-D7.

### Diferenças fundamentais de escopo

| Dimensão | Problem-Based-SRS | Esta ferramenta |
|---|---|---|
| Público-alvo | Equipes técnicas com IA | Stakeholder/cliente **leigo** |
| Plataforma | Claude Code plugin + multi-LLM (*AgentSkills*) | Gemini CLI (Claude Code como porte futuro) |
| Primitiva de interação | Prosa livre via CLI convencional | `ask_user` tipado (choice / text / yesno) |
| Padrão de saída | ISO/IEC/IEEE 29148 + RFC 2119 | IREB §3.3.3 (mesma família ISO 29148) |
| Arquitetura | 1 orquestrador + 9 skills | 11 agentes + ~30 skills |
| Tratamento de implícitos | Não cobre | Sub-agente Implícitos + catálogos seed |
| Tratamento de conflitos | Não cobre | Sub-agente Conflitos (IREB §4.4, 6 tipos) |

### Pontos fortes do Problem-Based-SRS

1. **Algoritmo Zigzag de rastreabilidade bidirecional** — ZAG (CP→CN→FR) e ZIG (FR→CN→CP) com IDs hierárquicos alinhados (CP.1 → CN.1.x → FR.1.x.y), gerando *coverage matrix*, *gap analysis* e detecção automática de órfãos e redundâncias. Abordagem mais algorítmica que conversacional.
2. **Sintaxe estruturada com *slots* obrigatórios** — templates fixos para CP/CN/FR (`[Subject] [must/expects/hopes] [Object] [Penalty]` etc.) que forçam disciplina linguística e habilitam validação programática da saída.
3. **RFC 2119/BCP 14 para linguagem normativa** — uso de MUST/SHOULD/MAY nos requisitos gerados, rigor formal alinhado a padrões internacionais além do IREB.
4. **Detection-based state recovery** — o agente orquestrador infere o marco atual lendo artefatos já gerados no disco; não depende de sessão persistente, permitindo interrupção e retomada transparentes.
5. **Distribuição como plugin multi-plataforma** — desacoplado de LLM via *AgentSkills standard*; instalável com um comando em Copilot, Claude Code e outros CLIs.
6. **Base acadêmica *peer-reviewed*** — metodologia sustentada por paper de 2016, argumento de autoridade direto para a banca.
7. **Arquitetura modular enxuta** — 1 orquestrador + 9 skills (~500 linhas/skill) com manifesto de orquestração explícito; menor superfície de manutenção que 30 skills.

### O que esta proposta pode melhorar

Cada item vem acompanhado de recomendação concreta e classificação de **impacto × esforço** relativo ao cronograma restante.

1. **Sintaxe estruturada para requisitos** *(alto impacto, baixo esforço)* — incorporar *slots* fixos (sujeito/verbo/objeto/condição) na skill `srs-template`, sobreposta à sintaxe EARS já planejada. Não exige redesenho; apenas adiciona template por seção de requisito.
2. **Algoritmo de rastreabilidade bidirecional formal** *(alto impacto, médio esforço)* — a arquitetura prevê `rastreabilidade-master.md` (Marco 3). Recomendação: adotar abordagem ZAG/ZIG do Gorski como skill *stretch* do Agente Gerência, gerando *coverage matrix* com detecção de órfãos e *gaps* executável.
3. **RFC 2119 sobreposta ao EARS** *(médio impacto, baixo esforço)* — adicionar MUST/SHOULD/MAY como modificadores normativos nos requisitos finais; reforça rigor sem retrabalho na sintaxe EARS.
4. **Redução do número de skills MVP** *(médio impacto, alto esforço)* — 19 skills MVP em 8 semanas implica ~2,4 skills/semana; consolidar skills correlatas (ex.: MoSCoW + IEEE + Kano em uma skill `priorizacao` com sub-rotinas) preserva as técnicas e reduz o risco de cronograma.
5. **Detection-based recovery no Agente Gerência** *(médio impacto, baixo esforço)* — capacidade de inferir o marco corrente lendo artefatos no disco; essencial para o estudo de caso (reprodutibilidade entre sessões interrompidas).
6. **Empacotamento como extensão Gemini CLI + plugin Claude Code desde o início** *(médio impacto, médio esforço)* — facilita o porte futuro previsto para a semana 5 e transforma a ferramenta em artefato distribuível além do TCC.
7. **Skill *stretch* de Complexity Analysis** *(baixo impacto, alto esforço)* — inspirada na skill homônima de Gorski (Axiomatic Design); candidate a trabalhos futuros se o cronograma não permitir.

### O que esta proposta faz melhor

1. **Foco no stakeholder leigo via `ask_user` tipado** — Gorski usa prosa livre via CLI, pressupondo público técnico; a primitiva `ask_user` (choice/text/yesno) é a única forma viável de conduzir elicitação com um não-técnico. Sustenta diretamente a decisão D1.
2. **Substituição integral do analista** — postura mais ambiciosa que "metodologia guiada por IA para equipes técnicas"; tem implicações arquiteturais concretas: skill `retraducao-leiga`, sub-agente Implícitos, ausência total de jargão de ER.
3. **Gates com aprovação humana explícita** — Gorski tem "Mandatory Quality Gates" puramente técnicos (validação Zigzag); o Gate 2 desta ferramenta bloqueia até `pautas-reelicitacao.md` esvaziar, exigindo aprovação humana a cada marco — mecanismo alinhado ao Livro SON §6.2-§6.4 e à natureza do usuário leigo.
4. **Catálogos seed para requisitos implícitos** — Gorski não trata o "óbvio não-dito" (Livro SON §4.4); os catálogos curados (`rfs-tipicos.md`, `rnfs-tipicos.md`, `dominios/*.md`) com sub-agente Implícitos endereçam diretamente a maior fragilidade da elicitação com leigos.
5. **Tratamento explícito de conflitos** — sub-agente Conflitos com tipologia IREB §4.4 (6 tipos + 4 estratégias: Acordo/Compromisso/Votação/Análise de alternativas); Gorski não cobre conflitos como componente separado.
6. **Skill `retraducao-leiga` no Gate 3** — Gorski entrega SRS técnico diretamente ao cliente; esta ferramenta traduz o SRS para linguagem leiga antes da aprovação final — etapa ausente em qualquer ferramenta correlata mapeada.
7. **Cobertura ampla de técnicas de elicitação** — ~30 skills abrangendo entrevista estruturada, personas, jornadas, vision-box, protocolo do garçom, Kano, MoSCoW, IEEE, FURPS+, histórias de usuário; Gorski concentra 9 skills no fluxo CP-CN-FR. Maior riqueza pedagógica e maior defensabilidade como contribuição em arquitetura multi-agente.

### Síntese e implicações para as decisões em aberto

As propostas são **complementares, não competidoras**: Gorski entrega rigor algorítmico e formalismo para times técnicos; esta ferramenta entrega abrangência de técnicas e humanização do processo para o stakeholder leigo. As decisões D1, D3, D4, D6 e D7 são reforçadas — não contestadas — pela comparação.

As recomendações de alto impacto e baixo esforço (sintaxe estruturada + RFC 2119) podem entrar no MVP antes da semana 3 sem comprometer o cronograma. A incorporação do Zigzag como skill *stretch* do Agente Gerência e o empacotamento como plugin são pontos a discutir com o orientador antes de iniciar a semana 3.

---

## Decisões em aberto (para definir com o orientador)

| Questão | Opções | Impacto |
|---|---|---|
| Projeto para o estudo de caso | A definir na semana 5 | Determina domínio principal dos catálogos seed |
| Número de sessões de elicitação no caso de estudo | 1 sessão / 2-3 sessões | Afeta profundidade e comparabilidade |
| SRS de referência para comparação | Documento pré-existente / avaliação só por rubrica IREB | Afeta rigor metodológico do estudo de caso |
| Avaliação de qualidade: quem avalia | Orientador / banca / rubrica automatizada | Afeta seção de metodologia do TCC |
| Skills stretch: quais executar se sobrar tempo | `casos-de-uso`, `complexity-analysis`, `historia-de-usuario`, `requisito-smart`, `requisito-qualidade-furps`; Kano e IEEE já como sub-rotinas de `priorizacao` | Afeta profundidade da Análise e completude do SRS |

---

## Mapa de referências por agente/skill

| Componente | Referência principal |
|---|---|
| Vision Box | Material Dani `ers-apoio-marco-01-visao-do-produto.md` |
| Situação-problema | Material Dani `ers-apoio-projeto-situacao-problema.md` |
| Stakeholders (planilha) | Livro 2, cap. 1 |
| Contexto e limite | IREB §3.3.3 Parte II |
| Entrevista estruturada | IREB §4.2, Livro 1, Livro 2 |
| Protocolo do garçom | Livro SON §7.2.4 Fig. 7.1 |
| Cenários narrativos | Material Dani n08 |
| Classificação RF/RNF | IREB §1.1, Livro SON cap. 5 |
| Priorização MoSCoW | Livro 2, Livro SON |
| Priorização Kano | Material Dani (questionário funcional/disfuncional) |
| Priorização IEEE | Material Dani n10 |
| Pautas re-elicitação | Livro SON cap. 8 Fig. 8.3 |
| Template SRS | IREB §3.3.3 |
| Sintaxe EARS | IREB cap. 3 |
| SMART para requisitos | Livro SON cap. 5 |
| História de usuário | Material Dani `Modelando Requisitos...` |
| FURPS+ / ISO 25010 | Livro SON cap. 5 |
| Checklist IREB §3.8 | `docs/cpre_foundationlevel_handbook_BR_v1.2.md` |
| Checklist validação | `docs/Engenharia de Requisitos - como levantar, documentar e validar/CheckListValidacaoDosRequisitos_150925.ods` |
| 3 passos validação cliente | Livro 1, cap. 4 |
| Conflitos (6 tipos) | IREB §4.4 |
| Ouça-Avalie-Negocie | Livro 2, cap. 4 |
| Baselines | IREB cap. 6 |
| Slots estruturados de requisito (D8) | Problem-Based-SRS — Gorski & Stadzisz, RESI 2016, DOI 10.21529/RESI.2016.1502002 |
| Linguagem normativa RFC 2119/BCP 14 (D8) | RFC 2119 (S. Bradner, 1997) + RFC 8174 (B. Leiba, 2017) |
| Algoritmo Zigzag de rastreabilidade | Problem-Based-SRS — Gorski & Stadzisz, RESI 2016, DOI 10.21529/RESI.2016.1502002 |
| Complexity Analysis via Axiomatic Design | Problem-Based-SRS — Gorski & Stadzisz, RESI 2016, DOI 10.21529/RESI.2016.1502002 |
| Detection-based recovery (D10) | Problem-Based-SRS — Gorski & Stadzisz, RESI 2016, DOI 10.21529/RESI.2016.1502002 |