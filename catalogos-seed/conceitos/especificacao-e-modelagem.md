# Conceitos: Especificação e Modelagem

Este guia define os padrões de escrita e organização dos artefatos gerados pela ferramenta.

---

## 1. Padrões de Escrita (Linguagem Natural Estruturada)
Para evitar ambiguidades, a ferramenta deve utilizar padrões estruturados de escrita:

### Sintaxe EARS (Easy Approach to Requirements Syntax)
Mavin et al., 2009. Ideal para requisitos de sistema. Estruturas recomendadas:
- **Ubíquo (Sempre):** *"O sistema deve [ação]..."*
- **Evento:** *"Quando [evento ocorrer], o sistema deve [ação]..."*
- **Estado:** *"Enquanto [estado], o sistema deve [ação]..."*
- **Opcional:** *"Onde [recurso disponível], o sistema deve [ação]..."*
- **Indesejado (Exceção):** *"Se [falha/erro], o sistema deve [ação]..."*

### Histórias de Usuário (User Stories)
Padrão recomendado para a visão do usuário.
- **Estrutura:** *"Eu, como [Quem], quero [O que], para que [Por que]."*.
- **Critérios de Aceite:** Devem seguir o padrão BDD (Gherkin): *"Dado [Contexto], Quando [Ação], Então [Resultado]"*.

## 2. Modelagem Recomendada
Além do texto, a ferramenta pode sugerir ou gerar descrições para:
- **Diagrama de Contexto:** Identificar as fronteiras do sistema e as entidades externas (quem envia e recebe dados).
- **Máquina de Estados:** Descrever o ciclo de vida de entidades complexas (ex: Status de um Pedido: Pendente -> Pago -> Enviado -> Entregue).

## 3. Estrutura da SRS (ISO/IEC/IEEE 29148)
A Especificação de Requisitos de Software deve ser organizada em:
1. **Introdução:** Objetivo e Definições.
2. **Descrição Geral:** Atores, Restrições e Premissas.
3. **Requisitos de Solução:**
   - **Funcionais:** Organizados por módulos ou processos.
   - **De Qualidade (RNF):** Organizados por categorias (Performance, Segurança, etc).
   - **Interfaces:** Descrição de telas ou APIs.
4. **Matriz de Rastreabilidade:** Mapa vinculando requisitos a objetivos de negócio.

## 4. Dicas de Redação Técnica
- **Sentenças Curtas:** Um objetivo por sentença.
- **Terminologia Consistente:** Usar sempre o mesmo nome para o mesmo conceito (ex: não misturar "Cliente" e "Usuário" se forem a mesma coisa).
- **Verificabilidade:** Cada requisito deve ser escrito de forma que um teste possa confirmar sua execução.
