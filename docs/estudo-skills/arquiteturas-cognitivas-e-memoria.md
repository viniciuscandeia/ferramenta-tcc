# Arquiteturas Cognitivas e Gestão de Memória em Agentes

Este documento explora conceitos avançados de arquitetura para agentes de IA, focando em como transformar um "modelo de linguagem" em um "sistema de inteligência" capaz de manter consistência e evoluir ao longo do tempo.

## 1. Arquitetura Cognitiva (Padrão CoALA)

Em vez de tratar o agente como um único prompt, adotamos o framework **CoALA (Cognitive Architectures for LLM Agents)**, que separa o sistema em:

- **Módulo de Percepção:** Observa o estado do projeto (arquivos no disco, respostas do usuário).
- **Módulo de Raciocínio (Reasoning):** O "loop de pensamento" que decide qual a próxima sub-tarefa.
- **Módulo de Planejamento (Planning):** Decompõe objetivos complexos (ex: "Elicitar Requisitos de Segurança") em passos atômicos.
- **Módulo de Ação:** Executa as ferramentas (skills, scripts, comandos CLI).

**Aplicação no TCC:** A ferramenta deve ser capaz de re-planejar se o usuário fornecer uma resposta ambígua, em vez de seguir um script rígido.

## 2. Gestão de Memória Multi-nível

A memória é o que permite ao agente "conhecer" o usuário e o projeto além da conversa atual.

### Memória de Trabalho (Curto Prazo)
- **Função:** Contexto imediato da sessão.
- **Gestão:** Uso de resumos automáticos (summarization) a cada 10 interações para evitar a perda de foco e o estouro de tokens.

### Memória Episódica (Histórico de Experiências)
- **Função:** Lembrar de trajetórias passadas.
- **Aplicação:** "Na última vez que tentamos elicitar requisitos de performance para este módulo, o usuário teve dificuldade com a técnica X; vamos tentar a técnica Y desta vez."

### Memória Semântica (Conhecimento e Preferências)
- **Função:** Armazenar fatos extraídos e preferências globais.
- **Aplicação:** Persistir que o usuário prefere jargão de negócios (ex: "lucratividade") em vez de termos técnicos (ex: "latência de query") em um arquivo `MEMORY.md` dedicado.

## 3. RAG Agêntico (Retrieval-Augmented Generation)

O RAG tradicional é passivo. O RAG Agêntico é ativo e crítico:

- **Query Reformulation:** Se o agente busca no catálogo de requisitos típicos e não encontra nada útil, ele deve reescrever a busca com sinônimos ou conceitos mais amplos.
- **Self-Correction:** O agente deve avaliar a qualidade dos documentos recuperados antes de apresentá-los ao usuário. "Estes requisitos de exemplo não se aplicam a sistemas mobile; vou buscar novamente focando em Android/iOS."

## 4. Avaliação de Trajetória (Evaluation)

A qualidade da ferramenta de TCC não será medida apenas pelo documento final, mas pela **experiência de elicitação**.

- **Trajectory Trace:** Analisaremos se o agente seguiu a lógica do IREB ou se deu saltos lógicos injustificados.
- **Human-in-the-loop Metrics:** Mediremos quantas vezes o usuário precisou corrigir o agente (indicador de falha na memória semântica ou no entendimento de contexto).

## Conclusão para o Projeto
A implementação dessas camadas garantirá que a ferramenta não seja apenas um "gerador de texto", mas um **assistente de engenharia** que aprende com o usuário e mantém o rigor metodológico ao longo de todo o ciclo de vida do desenvolvimento.
