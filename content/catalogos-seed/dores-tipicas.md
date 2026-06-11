# Catálogo: Dores Típicas

Usado por **`necessidade-visao`** (Turno 1 da Fase 1) para oferecer ao usuário uma lista de dores/problemas prováveis como checklist multi-seleção com escape de texto livre.

**Como usar:**
1. Identificar o domínio inferido na Fase 0 de `necessidade-visao`.
2. Abrir a seção correspondente abaixo. Se domínio não identificado: usar **Genérico**.
3. Selecionar as 3 dores mais prováveis para o contexto do projeto.
4. Apresentar as 3–4 dores selecionadas. O Claude Code já adiciona automaticamente uma opção "Other" (texto livre) — **não** incluir `"Outro (escrever)"` manual.
5. Invocar `AskUserQuestion` com `header: "Hoje"`, `multiSelect: true`.

Fonte: derivado das seções de Requisitos Funcionais, Não-Funcionais e Restrições dos catálogos de domínio em `content/catalogos-seed/dominios/` + padrões recorrentes em projetos de software documentados em Vazquez & Simões (2016) cap. 6 e Wiegers & Beatty (2013) cap. 5.

---

## Genérico (fallback — domínio não identificado)

Usar quando o texto inicial não permite inferir o domínio com confiança.

| # | Label da opção (≤ 5 palavras) | Descrição para `AskUserQuestion` |
|---|---|---|
| 1 | Processo manual ou lento | Tarefas feitas à mão que consomem muito tempo |
| 2 | Erros e retrabalho frequentes | Informações incorretas que precisam ser corrigidas repetidamente |
| 3 | Falta de controle e visibilidade | Difícil saber o que está acontecendo no negócio em tempo real |
| 4 | Custo alto de operação | Forma atual de trabalhar é cara demais para escalar |
| 5 | Demora no atendimento | Clientes ou usuários esperam muito para ser atendidos |
| 6 | Informação espalhada e perdida | Dados em vários lugares, difícil centralizar e encontrar |

**Seleção padrão para Turno 1 (se nenhum critério de relevância se aplica):** itens 1, 2 e 3.

---

## E-commerce / Marketplace (`dominios/ecommerce.md`)

| # | Label da opção | Descrição |
|---|---|---|
| 1 | Estoque desatualizado ou perdido | Difícil saber quais produtos estão disponíveis sem contar manualmente |
| 2 | Pedidos perdidos ou atrasados | Pedidos se perdem no processo e clientes reclamam sem resposta |
| 3 | Cliente sem retorno após a compra | Comprador fica sem saber o status depois de pagar |
| 4 | Gestão de fornecedores manual | Difícil rastrear o que foi entregue e o que foi pago |

---

## Educação (`dominios/educacao.md`)

| # | Label da opção | Descrição |
|---|---|---|
| 1 | Difícil acompanhar o progresso | Não saber quem está indo bem e quem precisa de ajuda |
| 2 | Comunicação fragmentada | Difícil manter contato entre professores, alunos e responsáveis |
| 3 | Conteúdo espalhado em vários lugares | Materiais em e-mail, drive e pastas — sem organização centralizada |
| 4 | Avaliação manual e demorada | Muito tempo para corrigir provas e dar feedback para os alunos |

---

## Saúde (`dominios/saude.md`)

| # | Label da opção | Descrição |
|---|---|---|
| 1 | Agenda de consultas bagunçada | Conflitos de horário, marcação em papel ou planilha sem controle |
| 2 | Histórico do paciente difícil de acessar | Prontuário espalhado, em papel ou em sistemas diferentes |
| 3 | Demora e desorganização no atendimento | Fila longa, fluxo confuso, paciente sem orientação clara |
| 4 | Faturamento com planos complicado | Guias e cobranças manuais com muitos erros e rejeições |

---

## Aplicativo Mobile (`dominios/mobile.md`)

| # | Label da opção | Descrição |
|---|---|---|
| 1 | App não funciona sem internet | Usuário trava completamente quando perde o sinal |
| 2 | Avisos importantes não chegam | Notificações essenciais não aparecem na hora certa |
| 3 | Interface difícil de usar no celular | Tela pequena, navegação confusa, botões inacessíveis |
| 4 | Dados diferentes no celular e computador | Sincronização não funciona — cada dispositivo mostra algo diferente |

---

## Dashboard / BI / Analytics (`dominios/dashboard.md`)

| # | Label da opção | Descrição |
|---|---|---|
| 1 | Relatórios feitos manualmente em planilha | Processo lento, sujeito a erros e difícil de compartilhar |
| 2 | Difícil entender os números do negócio | Dados espalhados, sem visão consolidada em um só lugar |
| 3 | Decisões tomadas com dados atrasados | Informações de ontem ou da semana passada como se fossem de hoje |
| 4 | Difícil filtrar e comparar o que importa | Visão muito geral ou muito específica — sem controle fácil |
