# Metodologia e Planejamento para Construção de Plugins com Agentes de IA

A construção de plugins e extensões baseadas em agentes (como para o Gemini CLI ou Claude Code) exige uma mudança de paradigma. Em vez de focar apenas em código determinístico (software tradicional), o planejamento deve seguir o **Agent Development Lifecycle (ADLC)**, focado em modularidade, contratos formais e avaliação contínua.

---

## 1. O Ciclo de Vida do Desenvolvimento de Agentes (ADLC)

A construção não é linear; ela é iterativa e baseada em ciclos ("flywheel"):

### Fase 1: Descoberta e Enquadramento (Discovery & Framing)
- **Não crie um "Assistente Geral":** O erro mais comum no planejamento é criar um plugin sem escopo definido. Defina um limite estreito e de alto valor (ex: em vez de "Assistente de Requisitos", crie agentes especialistas como "Auditor de Catálogo de Requisitos" ou "Entrevistador de Stakeholders").
- **Identifique as "Skills" (Habilidades):** Divida o problema maior em habilidades isoladas. Cada habilidade se tornará um arquivo `SKILL.md` focado em um único passo do fluxo.

### Fase 2: Experimentação ("The Vibes Phase")
- Antes de codificar o plugin, teste suas hipóteses conversando com o LLM puro. Veja como o modelo reage a casos extremos do seu domínio (usando dados e cenários reais, não sintéticos).
- Identifique onde o modelo falha de forma consistente ou alucina. Estas falhas ditarão exatamente quais ferramentas determinísticas (tools/scripts) você precisará construir e anexar à sua Skill para ancorar o agente na realidade.

### Fase 3: Arquitetura e Orquestração (Build)
- **Contratos Formais:** Defina rigorosamente os inputs e outputs que as ferramentas do seu plugin aceitam (usando JSON Schema, por exemplo). O LLM precisa saber exatamente *como* chamar a sua ferramenta.
- **Operações Atômicas:** Projete ferramentas que façam apenas uma coisa (ex: `read_catalog`, `validate_srs`). Ferramentas complexas (que tentam fazer tudo de uma vez) confundem o agente.
- **Escolha o Padrão de Orquestração:**
  - *Supervisor:* Um agente central entende o pedido e delega para sub-agentes especialistas (ideal para tarefas longas e ramificadas).
  - *Pipeline Sequencial:* O Agente A processa um dado e passa o resultado para o Agente B (ideal para fluxos de conversão ou processamento de dados em etapas).

### Fase 4: Avaliação (EvalOps)
- Esta é a etapa mais crítica. O planejamento deve prever a construção de "Golden Datasets" (conjuntos de testes com respostas perfeitas esperadas).
- Avalie o plugin continuamente em três eixos: **Precisão** (ele acerta a tarefa?), **Latência** (demora muito por entrar em loops?) e **Custo** (quantos tokens ele gasta desnecessariamente em cada passo?).

---

## 2. Princípios de Design de Plugins para IA

### A. Separação entre Raciocínio (Agent) e Execução (Plugin)
O plugin deve atuar como a fronteira entre a "mente" da IA e as ações no mundo real. O agente não deve precisar saber os detalhes técnicos de *como* o plugin busca uma informação no banco de dados; ele deve apenas saber que existe uma ferramenta/interface chamada `query_db` que ele pode usar.

### B. Divulgação Progressiva (Progressive Disclosure)
Planeje a arquitetura de informação do seu plugin para não afogar a Janela de Contexto (Context Window) do agente:
- **Gatilhos claros:** O agente só descobre que uma habilidade existe através do seu registro inicial (nome e descrição curta).
- **Carga Lazy (On-Demand):** Regras de negócio profundas, referências e catálogos só devem ser injetados no contexto quando o agente decide ativamente acionar aquela habilidade.

### C. Segurança e Governança
- **Isolamento de Execução:** Ferramentas que executam código devem rodar preferencialmente em ambientes isolados (sandboxes).
- **Human-in-the-Loop (HITL):** No seu planejamento, mapeie explicitamente "ações de alto impacto" (ex: apagar arquivos, gerar documentos finais). O plugin deve prever um portão de aprovação onde o humano confirma a ação proposta pelo agente antes da execução.

---

## 3. Extração de Conhecimento para Skills

A melhor forma de planejar o conteúdo de uma `SKILL.md` (o manual de instruções do agente) vem da **Observação de Falhas**:
1. Peça ao agente para fazer a tarefa usando apenas os seus conhecimentos gerais pré-treinados.
2. Observe onde ele erra e corrija-o: *"Não use a estrutura X, nós usamos a estrutura Y no nosso padrão IREB."* ou *"Você esqueceu de classificar este requisito como Não-Funcional."*
3. **Essas correções são o rascunho de ouro do seu `SKILL.md`.** Transcreva essas correções manuais em instruções processuais mandatórias dentro do arquivo da Skill.

---

## Resumo da Aplicação para o seu TCC
Ao planejar a **Ferramenta de Elicitação de Requisitos assistida por IA**, aplique esta metodologia da seguinte forma:
1.  **Enquadramento:** Não construa um agente "Engenheiro de Requisitos". Divida o processo IREB em "Skills" separadas (ex: `skill-visao-produto`, `skill-regras-negocio`, `skill-atores`).
2.  **Tools Atômicas:** Crie scripts/ferramentas simples que leiam seus catálogos (*seeds*) de forma direcionada, como por exemplo uma ferramenta `read_stakeholders_tipicos`.
3.  **Orquestração:** Utilize um padrão de **Agente Supervisor**. Ele conduz a interação principal com o usuário leigo e aciona "Agentes Especialistas" (Personas) silenciosamente no background (para analisar respostas ou validar a completude segundo a norma) apenas quando necessário.
