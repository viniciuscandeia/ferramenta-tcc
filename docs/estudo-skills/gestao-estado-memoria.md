# Gestão de Estado e Memória para Agentes CLI

Em fluxos de trabalho longos, como a Engenharia de Requisitos, o usuário raramente completa todo o processo em uma única sessão. Ele pode fazer a visão do produto num dia, fechar o terminal e voltar para elicitar requisitos na semana seguinte.

Agentes como o Claude Code e o Gemini CLI são *stateless* (sem estado) por padrão. O contexto vive apenas na sessão atual. Para resolver isso sem estourar o limite de tokens da janela de contexto, utilizamos o padrão de **Arquitetura Híbrida de Persistência**.

---

## 1. O Desafio da Janela de Contexto

Se tentarmos passar todo o histórico de conversação anterior para a nova sessão, duas coisas acontecem:
1.  **Custo:** O consumo de tokens dispara.
2.  **Atenção:** O modelo sofre de *Lost in the Middle* (esquece instruções importantes soterradas no meio de logs antigos).

A solução é salvar o estado no disco local e instruir o agente a fazer o "Handoff" (passagem de bastão) ao iniciar ou finalizar um marco.

---

## 2. A Arquitetura Híbrida: Markdown + JSON

A melhor prática de 2026 para persistência de agentes é separar a camada "humana/narrativa" da camada "técnica/execução".

### A. Camada de Memória (Markdown)
Usada para o "diário" do agente e armazenamento de fatos aprendidos. O Markdown é 30% a 40% mais eficiente em tokens do que o JSON para textos longos (pois não gasta tokens com chaves, aspas e formatação estrita).

*   **Arquivos típicos:** `MEMORY.md`, `contexto-projeto.md`.
*   **Como funciona:** O agente usa uma ferramenta de `write_file` ou `replace` para anotar fatos. 
*   *Exemplo:* "A equipe de vendas não usa o sistema antigo. O stakeholder principal é a Maria da contabilidade."
*   **Vantagem:** O usuário humano pode abrir o arquivo `MEMORY.md` e corrigir algo facilmente. Se o agente aprendeu errado, basta deletar a linha.

### B. Camada de Execução (JSON)
Usada para rastrear o progresso da máquina e estados exatos.

*   **Arquivos típicos:** `estado-marco-1.json`, `.agent-state.json`.
*   **Como funciona:** Guarda bandeiras e IDs precisos.
*   *Exemplo:*
    ```json
    {
      "marco_atual": 2,
      "etapa_ireb": "elicitação",
      "stakeholders_entrevistados": ["Maria", "João"],
      "status": "aguardando_validacao_regras_negocio"
    }
    ```
*   **Vantagem:** Scripts de orquestração podem ler o JSON e decidir qual Sub-Agente invocar sem precisar passar pelo LLM.

---

## 3. Protocolo de Persistência (Handoff)

Para garantir uma transição suave entre as sessões, implemente o seguinte protocolo nas suas Skills:

### No final da sessão (Checkpointing):
O agente deve gravar um resumo executivo narrativo no Markdown:
> "Sessão finalizada. Concluímos a identificação dos stakeholders. O usuário pausou porque precisa confirmar a tabela de restrições de segurança com a TI. Próximo passo: iniciar a elicitação com a tabela atualizada."

### No início da nova sessão (Bootstrapping):
1.  A primeira instrução (`SKILL.md` ou prompt principal) força o agente a usar a ferramenta `read_file` para ler o `.agent-state.json` e o `MEMORY.md` (ou o arquivo do marco atual).
2.  O agente entende exatamente onde parou e retoma a conversa de forma natural:
> "Olá! Na última sessão nós paramos na tabela de restrições de segurança. Você conseguiu confirmar os dados com a TI?"

---

## 4. Estratégias Avançadas: RAG vs Baseado em Arquivo

| Abordagem | Descrição | Quando Usar no TCC |
| :--- | :--- | :--- |
| **Bancos Vetoriais / RAG** | Busca semântica em milhares de documentos. | *Não recomendado* para o seu escopo atual. Adiciona complexidade (requer rodar um banco de dados) e o volume de texto da ferramenta não justifica. |
| **File-Based (Arquivos Locais)** | Salvar estado em pastas organizadas (ex: `marco-1/visao.md`). O agente usa `grep_search` ou lê os arquivos inteiros sob demanda. | **Recomendado.** Alinha-se com a filosofia "Unix" de agentes CLI. É versionável pelo Git e auditável pelo usuário. |

---

## 5. Aplicação Prática no TCC

Para a sua **Ferramenta de Requisitos**:

1.  Crie uma pasta oculta (ou explícita) no repositório do projeto, ex: `.ferramenta-ers/`.
2.  Dentro dela, gerencie o estado por marcos:
    *   `.ferramenta-ers/estado.json` (Progresso técnico: onde estamos na norma IREB).
    *   `.ferramenta-ers/memoria_entrevistas.md` (Fatos e regras de negócio coletadas de forma livre).
3.  As suas Skills (ex: `elicitation-coach`) sempre devem ter como "Core Mandate" o dever de **ler o `estado.json` antes de fazer a primeira pergunta** e **salvar as anotações no `.md` após cada resposta longa**.
