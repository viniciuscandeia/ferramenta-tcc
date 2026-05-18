# Análise dos Plugins Oficiais da Anthropic (Claude)

## Introdução
O repositório `anthropics/claude-plugins-official` estabelece o padrão ouro para a extensão de capacidades do Claude. Enquanto outros frameworks focam em rigor metodológico, a abordagem oficial foca em **escalabilidade de contexto**, **modularidade** e **transparência de intenção**.

## Conceitos Chave e Convenções

### 1. Divulgação Progressiva (Progressive Disclosure)
Diferente de sistemas que carregam todas as instruções no início da sessão, o ecossistema Claude utiliza um sistema de carregamento sob demanda:
- **Metadados:** Apenas o nome e a descrição da skill ficam permanentemente no contexto.
- **Triggering:** Quando o contexto da conversa coincide com a descrição, o corpo completo do `SKILL.md` é carregado.
- **Vantagem:** Permite que o agente tenha acesso a centenas de ferramentas sem degradar o desempenho ou estourar a janela de contexto.

### 2. Hierarquia Plugin vs. Skill
- **Plugin:** É a unidade de distribuição (ex: `google-drive`). Ele agrupa permissões, configurações MCP e múltiplas capacidades.
- **Skill:** É uma capacidade procedural específica dentro de um plugin (ex: `drive-search`).
- **Estrutura de Diretórios:**
    ```text
    plugin-name/
    ├── .claude-plugin/plugin.json (Manifesto)
    ├── skills/
    │   └── skill-name/
    │       ├── SKILL.md (Instruções + Metadados)
    │       ├── scripts/ (Automação determinística)
    │       └── references/ (Documentação volumosa)
    ```

### 3. Teoria da Mente e "Porquê"
As instruções oficiais evitam ser apenas uma lista de "FAÇA" e "NÃO FAÇA".
- **Explicação de Intento:** Elas frequentemente explicam o **objetivo (intent)** por trás de uma regra.
- **Raciocínio Adaptativo:** Ao entender o "porquê", o agente consegue adaptar seu comportamento em situações ambíguas onde uma instrução rígida poderia ser contraproducente.

### 4. Ecossistema de Avaliação (Evals)
A Anthropic enfatiza que uma skill é "código" e deve ser testada como tal.
- **Testes A/B de Prompt:** O framework inclui ferramentas para rodar o mesmo prompt com e sem a skill (baseline), comparando resultados.
- **Benchmarking:** Uso de scripts para medir latência, consumo de tokens e taxa de sucesso em tarefas específicas.
- **Human-in-the-loop:** Geração de relatórios HTML (Eval Viewers) para revisão humana da qualidade das respostas.

### 5. Descrições Proativas ("Pushy")
As descrições no YAML frontmatter são otimizadas para serem gatilhos ativos. Em vez de "Esta skill pesquisa arquivos", usa-se "Use whenever the user wants to find documents, spreadsheets, or presentations in their storage...".

## Comparação: Superpowers vs. Oficial

| Característica | Superpowers | Anthropic Official |
|---|---|---|
| **Foco** | Disciplina e Rigor (TDD) | Modularidade e UX do Agente |
| **Estilo de Prompt** | Imperativo e Restritivo | Assistivo e Baseado em Intento |
| **Contexto** | Carregamento Total/Manual | Divulgação Progressiva |
| **Garantia de Qualidade** | "Lei de Ferro" e Racionalização | Evals e Benchmarking |

## Aplicação no TCC
Para a ferramenta de elicitação de requisitos, a abordagem **Oficial** é ideal para o gerenciamento de múltiplas técnicas de elicitação (skills separadas que carregam apenas quando necessário). Já a abordagem **Superpowers** é mais adequada para garantir que o agente não pule etapas cruciais da norma IREB durante a geração do documento final.
