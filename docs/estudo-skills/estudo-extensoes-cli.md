# Dicas para Elaborar e Construir Plugins e Extensões para Agentes CLI (Estudo Completo)

Este documento aprofunda as melhores práticas, estruturas e configurações avançadas para a construção de extensões tanto no **Claude Code** quanto no **Gemini CLI**.

---

## 1. Claude Code

O ecossistema do Claude Code baseia-se em três pilares principais de extensão: **Skills**, **Hooks** e **Servidores MCP (Model Context Protocol)**. 

### 1.1 Servidores MCP (Model Context Protocol)
O MCP é o padrão do Anthropic para fornecer ferramentas e acesso a dados para o Claude.

**Gerenciamento via CLI:**
- Adicionar um servidor: `claude mcp add <nome> -- <comando>`
- As flags de configuração **devem vir antes** do nome do servidor. O `--` separa as flags do Claude do comando de execução do servidor.

**Escopos de Configuração (`--scope`):**
| Escopo | Localização do Arquivo | Visibilidade |
| :--- | :--- | :--- |
| `local` (Padrão) | `.mcp.json` (adicionar ao gitignore) | Apenas você, neste projeto. |
| `project` | `.mcp.json` (commitável) | Equipe inteira no repositório. |
| `user` | `~/.config/claude/mcp.json` | Você, em todos os seus projetos. |

**Exemplo Prático (Brave Search Web):**
```bash
claude mcp add brave-search --env BRAVE_API_KEY=sua_chave -- npx -y @anthropic/mcp-server-brave-search
```

### 1.2 Hooks (Eventos Nativos)
O Claude Code possui um sistema nativo de hooks configurado em `.claude/settings.json`, usando eventos chamados `PreToolUse` e `PostToolUse`. Os hooks recebem o contexto via `stdin` (JSON).

**Exemplo: Hook Pre-Edit para Proteger Arquivos (`.env`)**
No `settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node .claude/hooks/protect-files.js"
          }
        ]
      }
    ]
  }
}
```
No arquivo `.claude/hooks/protect-files.js`:
```javascript
const fs = require('fs');
const input = JSON.parse(fs.readFileSync(0, 'utf8'));
const filePath = input.tool_input.file_path;

if (['.env', 'config/secrets.json'].includes(filePath)) {
  console.error(`Acesso Negado: O arquivo ${filePath} é protegido.`);
  process.exit(2); // Código 2 bloqueia a execução da ferramenta pelo LLM
}
process.exit(0);
```

### 1.3 Plugins Empacotados
Para compartilhar configurações MCP e Skills com a comunidade, você cria um plugin com um arquivo `plugin.json` na pasta `.claude-plugin/`. O plugin agrupa seus hooks personalizados, configurações MCP e arquivos Markdown descritivos para skills.

---

## 2. Gemini CLI

O Gemini CLI diferencia as extensões em **Skills** (micromódulos de conhecimento sob demanda) e **Extensions** (pacotes completos de funcionalidades e integrações MCP).

### 2.1 Extensions (Manifesto e Estrutura)
O ponto de entrada de uma Extension no Gemini CLI é o arquivo `gemini-extension.json`.

**Estrutura de uma Extension:**
```text
my-extension/
├── gemini-extension.json  # O Manifesto principal
├── GEMINI.md              # Instruções globais do agente para a extensão
├── commands/              # Comandos Slash adicionais (.toml)
│   └── deploy.toml        # Exposto como `/deploy` no CLI
├── skills/                # Skills empacotadas juntas
│   └── audit/
│       └── SKILL.md
└── dist/
    └── index.js           # Lógica do servidor MCP
```

**Exemplo de `gemini-extension.json`:**
```json
{
  "name": "minha-extensao",
  "version": "1.0.0",
  "description": "Integra o Gemini a uma base de dados customizada.",
  "mcpServers": {
    "meu-servidor-mcp": {
      "command": "node",
      "args": ["${extensionPath}/dist/index.js"],
      "cwd": "${extensionPath}",
      "env": { "DEBUG": "true" }
    }
  },
  "settings": [
    {
      "name": "Chave da API",
      "description": "Chave secreta para conexão.",
      "envVar": "MINHA_API_KEY",
      "sensitive": true
    }
  ]
}
```
*Dica de Dev Local:* Use o comando `gemini extensions link .` dentro da pasta da extensão para testá-la no seu terminal imediatamente sem precisar fazer o deploy.

### 2.2 Criação Avançada de Skills (Progressive Disclosure)
A criação de skills (via comando `skill-creator`) deve sempre seguir a lei da **Divulgação Progressiva** (*Progressive Disclosure*) para proteger a Janela de Contexto (Context Window). 

1. **Gatilho Preciso:** O Gemini CLI **só lê** o Frontmatter YAML (`name` e `description`) para decidir se precisa usar a skill. Coloque absolutamente todos os cenários de "Quando usar esta skill" no `description`.
2. **Separação de Contexto:** 
   - Arquivo `SKILL.md`: Deve conter **apenas** fluxos procedurais e de decisão de alto nível (menos de 500 linhas).
   - Pasta `references/`: Arquivos como `api_docs.md` ou `schemas.md` que o Gemini lerá *somente se* o usuário pedir algo relacionado àquele tópico.
   - Pasta `scripts/`: Código de integração (ex: Node.js) que o Gemini deve rodar, em vez de pedir para ele escrever do zero todas as vezes.

### 2.3 Integração de Scripts nas Skills
- **Retorno Limpo:** Scripts executados pelas skills devem retornar uma saída (stdout) amigável ao LLM. Suprima stacktraces padrão e forneça retornos paginados ou truncados se os logs forem longos, evitando poluir o contexto.
- **Liberdade Controlada:** Se um fluxo é frágil e determinístico, limite a liberdade do LLM provendo um script fechado na pasta `scripts/`. Se for um fluxo de design ou criativo, use instruções em texto de alto nível.

---

## 3. Distribuição
- **Claude Code Plugins:** Podem ser carregados localmente via `claude --plugin-dir ./caminho`.
- **Gemini CLI Extensions:** Podem ser publicadas no GitHub. O usuário final instala facilmente passando a URL do repositório: `gemini extensions install <github-url>`. Adicione a tag `gemini-cli-extension` no GitHub para descoberta.
