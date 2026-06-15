---
name: entrevista-estruturada
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M2]
description: >-
  Conduz conversa estruturada para entender como o usuário trabalha hoje, o que incomoda e o que seria ideal.
  Use no início do Marco 2, para coletar rotina, frustrações e restrições percebidas do usuário.
  Structured interview for layperson stakeholder; captures daily routine, pain points, ideal vision, and constraints.
---

## Filosofia desta skill (Regras Absolutas)

1. **Facilitador empático** — o usuário não sabe nomear o que quer, mas sabe descrever o que o incomoda. Começar pelo problema, não pela solução.
2. **Adaptar ao projeto concreto** — nunca usar os templates genéricos literais. Substituir `[produto]`, `[tarefa]`, `[perfil]` pelo contexto real de `documentos-tecnicos/01-visao/01-visao-produto.md` antes de perguntar.
3. **"Não sei" não é vazio — é premissa.** Resposta de incerteza vai para `documentos-tecnicos/02-requisitos/02.4-premissas.md`, não é ignorada.

<HARD-GATE>
- NÃO executar se Gate 1 não foi aprovado (verificar `documentos-para-leigo/01-visao/01-visao-produto.md` + `documentos-tecnicos/01-visao/01-visao-produto.md` existem)
- ⛔ STOP após Fase A se P1 (rotina) ou P2 (frustrações) retornarem resposta ≤ 5 palavras OU sem verbo de ação (sem dados suficientes para derivar RFs — mesmo critério do Anti-Padrão "Resposta Monossilábica Aceita") — re-sondar com exemplo concreto antes de registrar
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar Gate 1 aprovado: `documentos-tecnicos/01-visao/01-visao-produto.md` existe
3. Detectar modo: **Fase A** (Rodada 1 — entrevista completa) ou **Fase B** (pauta específica de `documentos-tecnicos/02-requisitos/02.6-pautas-reelicitacao.md`)
4. Extrair de `documentos-tecnicos/01-visao/01-visao-produto.md`: nome do produto, perfil principal, tarefa principal → personalizar perguntas

## Fase 1 — Coleta (adapta conforme modo)

### Modo Fase A — Rodada 1 (4 perguntas-âncora)

Adaptar ao contexto do projeto (substituir placeholders por dados reais de `documentos-tecnicos/01-visao/01-visao-produto.md`):

Cada pergunta vai via `AskUserQuestion` com **âncoras concretas** (a primitiva exige opções; o campo nativo "Type something" cobre quem quiser detalhar). **Proibido** opção de "descrever livremente" (D14). Adaptar âncoras ao domínio real do projeto.

**Pergunta 1 — Rotina atual (`choice`):**
- `question`: "Como você [ou seus clientes/usuários] faz [tarefa principal] hoje? Escolha o que mais se parece ou descreva o passo a passo."
- Opções: ex. "No papel ou caderno", "Em planilha", "Em outro sistema/app", "De cabeça, sem registrar".

**Pergunta 2 — Frustrações e problemas (`multi-choice`):**
- `question`: "O que mais incomoda ou atrapalha nesse processo hoje? (pode escolher mais de uma ou escrever)"
- Opções: ex. "Demora muito", "Dá erro / tem retrabalho", "Informação espalhada", "Difícil de acompanhar".

**Pergunta 3 — Visão ideal (`multi-choice`):**
- `question`: "Se o [produto] funcionasse do jeito ideal, como seria? (pode escolher mais de uma ou escrever)"
- Opções: ex. "Tudo num lugar só", "Mais rápido / automático", "Acesso pelo celular", "Menos erros".

**Pergunta 4 — Restrições percebidas (`multi-choice`):**
- `question`: "Existe alguma regra ou limite que o produto precisa respeitar? (pode escolher mais de uma ou escrever)"
- Opções: ex. "Precisa funcionar no celular", "Tem prazo para ficar pronto", "Tem lei/norma que se aplica", "Orçamento limitado".

Invocar `AskUserQuestion` com as 4 perguntas adaptadas (1 chamada única — D14).

### Modo Fase B — Foco em pauta

Quando invocada pelo collector para resolver pauta específica de `documentos-tecnicos/02-requisitos/02.6-pautas-reelicitacao.md`:
formular 1–3 perguntas diretas sobre a lacuna. Consolidar múltiplas pautas compatíveis em 1 chamada (D14, máx 4 perguntas).

Exemplos por tipo de pauta:

**RF sem critério de aceitação (`choice`):**
- `question`: "Como você vai saber que [funcionalidade X] funcionou do jeito certo? Escolha o que confirma isso ou escreva."
- Opções: âncoras concretas (ex.: "Aparece uma confirmação na tela", "Recebo um aviso ou e-mail", "O item fica salvo na lista", "Consigo ver/baixar o resultado").

**RNF sem métrica (choice, `multiSelect: false`):**
```
Quando você usa [funcionalidade Y], quanto tempo de espera seria aceitável?
(A) Até 2 segundos  (B) Até 5 segundos  (C) Precisa ser instantâneo
```

**Restrição legal sem detalhe (yesno):**
```
Você mencionou [lei/regra X]. Isso significa que os usuários precisam dar permissão explícita para o uso dos dados?
```

**Premissa não confirmada (yesno):**
```
Nós assumimos que [premissa]. Isso está correto para o seu caso?
```

## Fase 2 — Registro em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`

**Fase A:**
```markdown
## Rotina e Necessidades (entrevista-estruturada — Fase A)

**P1 — Rotina atual:** [resposta]
**P2 — Frustrações:** [resposta]
**P3 — Visão ideal:** [resposta]
**P4 — Restrições percebidas:** [resposta]
```

**Fase B:**
```markdown
## Detalhamentos — iteração N (entrevista-estruturada focada)

**Pauta [ID]:** [resposta que resolve a lacuna]
```

Se usuário responde "não sei" em qualquer pergunta: registrar em `documentos-tecnicos/02-requisitos/02.4-premissas.md` como `[premissa — a confirmar]`.

## Fase 3 — Saída

Seção adicionada a `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`.

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
- Fase A → Invocar imediatamente `Skill("cenario-narrativa")`
- Fase B → Retornar ao orquestrador para avaliação de pautas (sem TextBlock)

**PROIBIDO** qualquer TextBlock antes desta ação.

<!-- internal -->
## Anti-Padrão: Resposta Monossilábica Aceita

**Como acontece:** P1 (rotina) retorna "faço manualmente" e P2 (frustrações) retorna "demora muito". Essas respostas são registradas sem sondagem — o modeler não conseguirá derivar nenhum RF concreto.

**Como detectar:** Resposta P1 ou P2 ≤ 5 palavras OU ausência de verbos de ação.

**O que fazer:** Re-perguntar com exemplo do próprio domínio. "Entendo! Para me ajudar a entender melhor — quando você diz 'faço manualmente', você quer dizer que anota num caderno, usa uma planilha, ou algo diferente?" Não registrar até ter resposta com ≥ 1 ação descrita.
<!-- /internal -->
