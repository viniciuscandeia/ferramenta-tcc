# Como usar a ferramenta `ask_user` no Gemini CLI

A ferramenta `ask_user` permite que o agente interaja ativamente com você, fazendo perguntas para coletar preferências, esclarecer requisitos ou tomar decisões. Isso é especialmente útil ao criar Skills.

## Estrutura Básica

Ao instruir o agente (por exemplo, dentro de um arquivo `SKILL.md`) a utilizar a ferramenta, o agente construirá uma lista de **perguntas** (até 4 perguntas por chamada). Cada pergunta precisa ter no mínimo as seguintes propriedades lógicas que você deve especificar na sua instrução:

- **`question`** (Obrigatório): A pergunta completa, clara e específica, terminada com um ponto de interrogação.
- **`header`** (Obrigatório): Um rótulo bem curto, usado como tag/chip na interface (ex: "Nome", "Banco", "Abordagem").
- **`type`** (Obrigatório): O tipo da pergunta. Pode ser:
  - `choice` (padrão): Para múltipla escolha.
  - `text`: Para entrada de texto livre.
  - `yesno`: Para perguntas de Sim ou Não.

## Tipos de Perguntas e Suas Configurações

### 1. Tipo `choice` (Múltipla Escolha com Opções Prontas)
Usado quando você quer oferecer uma lista fechada de opções para o usuário clicar.
- **`options`**: É aqui que você define as opções prontas. Cada opção deve ter:
  - `label`: O nome que aparece no botão (curto).
  - `description`: Uma explicação do que essa opção faz (ajuda o usuário a decidir).
- **`multiSelect`**: Defina como `true` se o usuário puder escolher várias opções da lista, ou `false` para apenas uma.
- **`placeholder`**: Texto que aparece no campo "Other" (Outro), caso o usuário queira digitar algo que não está na lista.

### 2. Tipo `text` (Texto Livre)
Usado para receber informações abertas, como nomes, datas, ou requisitos não estruturados.
- **`placeholder`**: Opcional. Texto de dica mostrado dentro da caixa de texto (ex: "Digite seu nome completo").

### 3. Tipo `yesno` (Sim / Não)
Uma forma rápida de pedir confirmação ou aprovação.
- Não precisa de opções configuráveis. Automaticamente fornece as opções de Sim e Não, além de um campo "Other" para feedback opcional. O `placeholder` pode ser usado para dar uma dica nesse campo extra.

## Exemplos Prontos para Copiar (SKILL.md)

Aqui estão modelos que você pode copiar e adaptar dentro do seu arquivo `SKILL.md`:

### Exemplo 1: Coleta de Dados (Tipo Text)
```md
Use a ferramenta `ask_user` para coletar dados do usuário:
- Header: "Projeto" | Type: "text" | Question: "Qual o nome do projeto?" | Placeholder: "ex: Meu App v1"
- Header: "Versão" | Type: "text" | Question: "Qual a versão inicial?" | Placeholder: "1.0.0"
```

### Exemplo 2: Menu de Opções (Tipo Choice)
```md
Pergunte ao usuário qual tecnologia ele deseja usar:
- Header: "Tech"
- Type: "choice"
- Question: "Qual framework você prefere?"
- Options:
  - Label: "React" | Description: "Biblioteca para interfaces web"
  - Label: "Vue" | Description: "Framework progressivo"
  - Label: "Svelte" | Description: "Compilador de componentes"
```

### Exemplo 3: Confirmação Simples (Tipo YesNo)
```md
Antes de prosseguir com a deleção, peça confirmação:
- Header: "Confirmar"
- Type: "yesno"
- Question: "Você tem certeza que deseja excluir todos os arquivos da pasta temporária?"
```

### Exemplo 4: Múltipla Escolha (MultiSelect)
```md
Peça para o usuário selecionar os módulos que deseja instalar:
- Header: "Módulos"
- Type: "choice"
- MultiSelect: true
- Question: "Quais módulos extras deseja incluir?"
- Options:
  - Label: "Auth" | Description: "Sistema de autenticação"
  - Label: "API" | Description: "Gerador de endpoints"
  - Label: "Tests" | Description: "Boilerplate de testes"
```
