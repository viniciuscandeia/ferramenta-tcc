---
name: entrevista-estruturada
description: Conduz entrevista estruturada com o usuário leigo usando 4 perguntas-âncora adaptadas do material Dani (ERS n10) e IREB §4.2. Coleta rotina, frustrações, visão ideal e restrições percebidas. Saída: seção de elicitacao-raw.md.
when_to_use: Invocada pelo collector na Ronda 1 da Fase A (sempre) ou na Fase B quando skill-alvo de uma pauta. Única chamada AskUserQuestion com exatamente 4 perguntas (ou menos se foco em pauta específica).
---

# Skill: entrevista-estruturada

**Referências:** IREB §4.2 (técnicas de elicitação) · Material Dani n10 (4 perguntas-âncora)
**Marco:** M2 — Consenso de Escopo (Fase A, Ronda 1 — ou Fase B focada)
**Invocada por:** `collector`

---

## OBJETIVO

Capturar o contexto operacional real do usuário — como ele trabalha hoje, o que o incomoda, como imagina que deveria ser, e quais limitações ele percebe. Estas 4 dimensões são as âncoras da elicitação de Dani e cobrem o essencial para derivar RFs, RNFs e restrições.

---

## MODO FASE A (Ronda 1 — entrevista completa)

### As 4 perguntas-âncora

Adaptar ao contexto do projeto (substituir `[produto]`, `[perfil]`, `[tarefa]` pelos dados de `visao-produto-normativo.md`):

**Pergunta 1 — Rotina atual (atividades cotidianas)**
```
Como você [ou seus clientes/usuários] realiza [tarefa principal do produto] hoje?
Descreva o passo a passo — pode ser informal.
```

**Pergunta 2 — Frustrações e problemas**
```
O que mais incomoda ou atrapalha nesse processo hoje?
O que você gostaria que fosse diferente?
```

**Pergunta 3 — Visão ideal**
```
Se o [produto] funcionasse do jeito ideal para você, como seria?
O que ele precisaria fazer que hoje não é possível?
```

**Pergunta 4 — Restrições percebidas**
```
Existe alguma regra, limitação de tempo ou orçamento, ou tecnologia que o produto precisa respeitar?
(Ex: precisa funcionar no celular, precisa estar pronto até uma data específica, tem alguma lei que se aplica?)
```

### Execução Fase A

1. Invocar `AskUserQuestion` com as 4 perguntas adaptadas ao contexto do projeto
2. Tipo de pergunta: `text` para todas (respostas livres)
3. Registrar respostas em `elicitacao-raw.md`, seção "Rotina e Necessidades":
   ```markdown
   ## Rotina e Necessidades (entrevista-estruturada — Fase A)
   
   **P1 — Rotina atual:** [resposta]
   **P2 — Frustrações:** [resposta]
   **P3 — Visão ideal:** [resposta]
   **P4 — Restrições percebidas:** [resposta]
   ```

---

## MODO FASE B (focado em pauta)

Quando invocada pelo collector em modo Fase B (pauta específica de `pautas-reelicitacao.md`):

### Adaptação das perguntas

Formular 1–3 perguntas diretas sobre a lacuna específica da pauta. Exemplos:

**Pauta: "RF sem critério de aceitação"**
```
Como você vai saber que [funcionalidade X] funcionou do jeito certo?
O que precisa aparecer na tela ou acontecer para você confirmar que deu certo?
```

**Pauta: "RNF sem métrica de tempo de resposta"**
```
Quando você usa [funcionalidade Y], quanto tempo de espera seria aceitável para você?
(Ex: "até 2 segundos é ok", "tem que ser instantâneo")
```

**Pauta: "Restrição legal sem detalhe"**
```
Você mencionou que o produto precisa seguir [lei/regra X].
Isso significa que os usuários precisam dar permissão explícita para usar os dados deles?
Ou existe alguma regra mais específica que você sabe que se aplica?
```

**Pauta: "Premissa não confirmada"**
```
Nós assumimos que [premissa]. Isso está correto para o seu caso?
```

### Execução Fase B

1. Invocar `AskUserQuestion` com 1–3 perguntas (choice ou yesno para pautas binárias, text para abertos)
2. Máximo 4 perguntas por chamada (batching D14) — consolidar múltiplas pautas numa chamada se compatíveis
3. Registrar respostas em `elicitacao-raw.md`, seção "Detalhamentos (iteração N)":
   ```markdown
   ## Detalhamentos — iteração 1 (entrevista-estruturada focada)
   
   **Pauta CONF-001:** [resposta que resolve a lacuna]
   **Pauta RNF-002 métrica:** [resposta com valor concreto]
   ```

---

## REGRAS DE APLICAÇÃO (D14 + D19)

- Perguntas em linguagem de negócio — nunca mencionar "requisito", "elicitação", "RNF", "critério de aceitação" ao usuário
- Todas as 4 perguntas da Fase A em um único `AskUserQuestion` (1 chamada só)
- Fase B: consolidar perguntas de pautas compatíveis numa única chamada quando possível
- Se usuário responde "não sei" ou "depende": registrar a incerteza como premissa em `03.4-premissas.md`

---

## SAÍDA

Seção adicionada a `elicitacao-raw.md` com as respostas estruturadas. Não gerar artefatos finais — o `modeler` processa `elicitacao-raw.md` nos Passos 1–5 da Fase B.
