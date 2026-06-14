---
name: faq-inicial
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
description: Responde dúvidas comuns do usuário antes de iniciar a documentação do projeto. Invocada quando o usuário escolhe "Tenho dúvidas antes" no início de /iniciar-produto.
marco: [M1]
when_to_use: Quando o usuário sinaliza que tem dúvidas antes de começar. Invocar via orchestrator — não invocar diretamente.
---

# faq-inicial — Esclarece dúvidas antes de começar

## Quando invocar

Esta skill é invocada pelo orquestrador quando o usuário seleciona "Tenho dúvidas antes" na boas-vindas inicial.

## Fase 1 — Apresentar dúvidas comuns

Invocar `AskUserQuestion` com multi-choice:

- `question`: "Quais dessas dúvidas você tem? Pode escolher mais de uma."
- `header`: "Suas dúvidas"
- `multiSelect`: true
- Opção 1: label `"Quanto tempo vai levar?"`, description `"Quero ter uma ideia do tempo necessário"`
- Opção 2: label `"Preciso saber de tecnologia?"`, description `"Vou precisar entender programação ou sistemas?"`
- Opção 3: label `"Posso editar as respostas depois?"`, description `"Não preciso acertar tudo agora?"`
- Opção 4: label `"Quem vai ver o que eu responder?"`, description `"Questões sobre privacidade das informações"`

## Fase 2 — Responder dúvidas selecionadas

Para cada opção marcada, exibir a resposta correspondente **em uma única mensagem**, sem repetir as perguntas:

**"Quanto tempo vai levar?"**
> Normalmente leva entre 30 e 60 minutos de conversa. Você não precisa terminar tudo de uma vez — pode pausar e continuar depois. O progresso fica salvo.

**"Preciso saber de tecnologia?"**
> Não. Você não precisa saber nada de programação, sistemas ou linguagem técnica. Basta descrever o que você quer construir com suas próprias palavras. Eu faço o restante.

**"Posso editar as respostas depois?"**
> Sim. A cada etapa você revisa e aprova o que foi documentado. Se algo não estiver certo, você pode pedir para ajustar antes de seguirmos em frente.

**"Quem vai ver o que eu responder?"**
> As informações que você compartilhar são usadas apenas para criar o documento do seu projeto. Elas ficam salvas nos arquivos do projeto no seu próprio computador e não saem dele.

## Fase 3 — Verificar se há mais dúvidas

Após exibir as respostas, invocar `AskUserQuestion`:

- `question`: "Suas dúvidas foram respondidas?"
- `header`: "Próximo"
- `multiSelect`: false
- Opção 1: label `"Sim, posso começar"`, description `"Iniciar a documentação do projeto"`
- Opção 2: label `"Tenho mais dúvidas"`, description `"Quero esclarecer mais alguma coisa antes"`

## Fase 4 — Roteamento

- **"Sim, posso começar"** → retornar ao orquestrador. Sinalizar: `faq_concluido: true`. Orquestrador prossegue para M1.
- **"Tenho mais dúvidas"** → invocar `AskUserQuestion` com `text` (texto livre): "O que mais você gostaria de entender?" → responder em ≤ 3 linhas → voltar à Fase 3. Após 2 rodadas de texto livre sem resolver, oferecer proativamente: "Posso responder outras dúvidas durante a conversa. Quer começar?" via `AskUserQuestion` yesno → se SIM: prosseguir para M1; se NÃO: manter na Fase 3.

## Anti-padrões proibidos

- NUNCA usar jargão da blacklist D1 nas respostas
- NUNCA demorar mais de 3 linhas por resposta de dúvida
- NUNCA pular a Fase 3 (verificar se há mais dúvidas antes de sair)
