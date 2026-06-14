---
name: necessidade-visao
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M1]
description: >-
  Captura a necessidade central e a visão do produto em linguagem de negócio — primeira skill do Marco 1.
  Começa pelo problema (5-Whys/JTBD), depois sintetiza a visão e as metas de sucesso.
  Use quando o usuário descreve o que quer construir pela primeira vez ou ao iniciar o projeto.
  Capture core need, product vision and success goals for a layperson stakeholder; problem-first approach.
---

## Filosofia desta skill (Regras Absolutas)

1. **Problema antes de solução.** A skill abre com UMA pergunta de enquadramento ("o que você quer construir?", Turno 0) e em seguida mergulha no problema/dor real. O **agente** nunca propõe soluções, features ou funcionalidades — mas a frase de produto que o usuário dá é capturada como âncora. A visão emerge do problema entendido.
2. **Uma pergunta adaptativa por vez na fase de descoberta.** Na Fase 1 (5-Whys), cada pergunta depende da resposta anterior. Não há lote rígido — o agente sonda até chegar na dor raiz (máximo 3 turnos de sondagem).
3. **Síntese confirmada, não pergunta a frio.** Visão (frase Moore), benefício e diferencial são SINTETIZADOS pelo agente com base no que o usuário disse — então CONFIRMADOS em choice/yesno. Nunca perguntar "qual o benefício?" diretamente.
4. **Ancoragem estrita.** Toda pergunta preenche um campo do template `content/templates/01-documento-visao.md`. Se não preenche um campo, a pergunta não é feita.
5. **Zero jargão.** Nunca mencionar "requisito", "visão", "produto mínimo viável", "escopo", "stakeholder" ou qualquer jargão de produto/ER (blacklist D1).

<HARD-GATE>
- NÃO executar se seções `## 1. Visão` e `## 2. Problema & Necessidade` já existem em `documentos-tecnicos/01-visao/01-visao-produto.md` (idempotência)
- ⛔ STOP e registrar em `_pendencias.md` se o usuário não fornecer nome do produto E nem descrição alguma do problema (campos mínimos para síntese)
- PROIBIDO: **o agente** propor solução, listar features ou funcionalidades — qualquer menção do agente a "o produto vai fazer X" é barrada. (Capturar a descrição de produto que o USUÁRIO fornece no Turno 0 é permitido e esperado.)
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `estado-projeto.yaml`; se ausente: inicializar com `marco_corrente: M1`
3. Checar idempotência: se seções `## 1. Visão` e `## 2. Problema & Necessidade` já existem → pular para Fase 4 (síntese) ou Fase 5 (sinalização)
4. **Pré-extração:** se o usuário forneceu texto inicial com `/iniciar-produto`, extrair:
   - Nome candidato do produto (se mencionado)
   - Dor/problema central (se descrito)
   - Pessoas mencionadas
   - Restrições mencionadas
   Usar tudo que foi extraído para personalizar as perguntas (não re-perguntar o que o usuário já disse).
5. **Inferência preliminar de domínio:** com base nas palavras do texto inicial (se houver), identificar o domínio mais provável dentre: `ecommerce`, `educacao`, `saude`, `mobile`, `dashboard`. Usar para selecionar dores do catálogo no Turno 1. Se nenhum domínio identificável: usar lista **Genérico**. Não é necessário confirmar com o usuário aqui — a confirmação ocorre em `recomendacao-dominio` no M2.

## Fase 1 — Descoberta do Problema (5-Whys/JTBD, adaptativo)

**Objetivo:** chegar na dor raiz. Máximo 3 turnos de sondagem. Turno 1 = 1 `AskUserQuestion` multi-choice + 1 adicional `text` se "Outro" marcado; Turnos 2 e 3 = 1 `AskUserQuestion` com 1 pergunta (`text`) cada.

**Turno 0 — Enquadramento do produto (1 `AskUserQuestion`, `text`):**

Antes de mergulhar no problema, entender O QUE será construído:
```
Em poucas palavras, o que você quer construir? (que produto ou ferramenta é esse?)
```
- **Pular** se o texto inicial de `/iniciar-produto` já descreveu o produto (usar o que foi dito — não re-perguntar).
- Guardar como **âncora de produto**: alimenta a pré-extração, a síntese (Fase 4) e a seção `## 1. Visão`. Não pedir features nem detalhar — é só o enquadramento de uma frase.
- O agente não comenta nem propõe nada sobre o produto; em seguida segue para o Turno 1 (problema).

**Turno 1 — O que está errado hoje (multi-choice):**

Se o problema NÃO foi descrito no texto inicial:
1. Ler `{PLUGIN_ROOT}/content/catalogos-seed/dores-tipicas.md` → seção do domínio inferido na Fase 0. Se domínio não identificado: usar seção **Genérico**.
2. Selecionar 3–4 dores mais prováveis para o contexto (limite de 4 opções na array).
3. Invocar 1 `AskUserQuestion`:
   - `question`: "O que mais te incomoda na situação atual? (pode marcar mais de uma)"
   - `header`: "Hoje"
   - `multiSelect`: true
   - Opções: [as 3–4 dores do catálogo]
   *(O Claude Code adiciona automaticamente uma opção "Other" de texto livre — não incluir "Outro" manual.)*
4. Se o usuário usar a opção **"Other" nativa** para descrever uma dor própria: usar o texto digitado como base do Turno 2 — não re-perguntar.

Se o problema JÁ foi descrito no texto inicial: pular para Turno 2 usando o que foi descrito.

**Turno 2 — Sondagem de impacto (5-Whys):**
Com base nas dores marcadas no Turno 1 (e/ou no texto livre de "Outro"), perguntar:
```
O que acontece por causa disso? Qual é a consequência mais concreta — tempo perdido, erros, dinheiro, frustração?
```
*(Adaptar à resposta anterior — se o impacto já foi mencionado, confirmar em vez de re-perguntar.)*

**Turno 3 — JTBD (Job-to-be-Done) — condicional:**
Usar SOMENTE se o "progresso desejado" não ficou claro nas respostas anteriores:
```
Quando você imagina que esse problema foi resolvido, o que muda na prática? O que você (ou as pessoas afetadas) conseguem fazer que hoje não conseguem?
```

**Regras da Fase 1:**
- Após o Turno 0 (enquadramento), o **agente** não propõe produto/solução/features — os Turnos 1–3 são só sobre o problema
- Se a resposta for vaga (ex: "quero melhorar as coisas"), sondar com: "Pode me dar um exemplo concreto de quando isso deu errado?"
- Parar em 3 turnos de sondagem — mesmo se o problema ainda tiver pontos obscuros (lacunas vão para Fase Condicional ou M2)

## Fase 2 — Identificação do Produto e Público

**Lote compacto (1 `AskUserQuestion`, 2 perguntas):**

1. **Nome do produto** (text):
   ```
   Como você chamaria esse produto? Pode ser um nome temporário mesmo.
   ```
   *(Se o usuário já mencionou um nome no texto inicial: apresentar como sugestão via choice — "Pode ser [nome mencionado]?" — não re-perguntar aberto.)*

2. **Público principal** (text — só se não ficou claro na Fase 1):
   ```
   Pensando nas pessoas que mais vão se beneficiar: quem são elas? (pode descrever informalmente)
   ```
   *(Se o público já ficou claro na Fase 1, inferir e pular esta pergunta.)*

## Fase 3 — Indicadores de Sucesso

**1 `AskUserQuestion`, 1 pergunta (text):**

```
Como você vai saber que esse produto resolveu o problema? O que precisa acontecer ou melhorar para você dizer "funcionou"?
```

*(Exemplos de resposta esperada: "menos de X reclamações por mês", "economizar Y horas por semana", "atender Z pedidos a mais". Se o usuário não souber: registrar `[a definir]` e adicionar aos Itens em Aberto. Esta informação é incorporada à seção §2 do documento de visão — não gera seção separada.)*

## Fase 4 — Síntese e Confirmação

### 4a — Síntese do Agente

Com base em TUDO coletado (Fases 1–3 + texto inicial), sintetizar:

**Frase-síntese (Geoffrey Moore):**
```
"Para [público-alvo inferido] que [necessidade/dor central], o [nome do produto] é um [categoria inferida — app, plataforma, sistema] que [benefício principal inferido]. Diferente de [como resolvem hoje — inferido da Fase 1 ou 'processo manual/planilha' como fallback], ele [diferencial inferido]."
```

**Regras de síntese:**
- Classificação (app, plataforma, sistema, serviço): inferir do contexto — nunca perguntar diretamente
- Se "como resolvem hoje" não ficou claro: usar "processo manual" como fallback de inferência; marcar como `[inferido]`
- Se diferencial não ficou claro: sintetizar como "resolve isso de forma mais simples e organizada"; marcar como `[inferido — confirmar em M2]`
- Benefício = transformação da dor em ganho (ex: dor = "erros manuais" → benefício = "sem erros, com controle")
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

### 4b — Confirmação da Síntese (1 `AskUserQuestion`, choice)

Apresentar a frase-síntese + as metas de sucesso ao usuário e confirmar:

```
Com base no que você contou, aqui está o resumo:

[Frase-síntese]

E o sucesso seria: [meta(s) de sucesso]

Está correto? Alguma coisa precisa mudar?
```

Opções: `"Está correto"` / `"Quero ajustar"` / `"Quero explicar melhor"`

- Se "Está correto" → Fase 5
- Se "Quero ajustar" ou "Quero explicar melhor" → 1 `AskUserQuestion` text ("O que está errado? O que você mudaria?") → re-sintetizar → re-confirmar (máximo 1 rodada extra)

## Fase 5 — Saída

Preencher as seções do template `content/templates/01-documento-visao.md`:

**Seção `## 1. Visão`:** frase-síntese confirmada pelo usuário

**Seção `## 2. Problema & Necessidade`:**
- A dor: síntese da Fase 1 (5-Whys)
- Quem sofre: pessoas impactadas
- Impacto concreto: consequências da Fase 1 Turno 2
- Necessidade central (JTBD): síntese do Turno 3 ou inferida
- **Indicadores de sucesso:** resposta da Fase 3 — o que precisará acontecer para o produto ser considerado bem-sucedido. Campos não respondidos: `[a definir]` + adicionar a `## 5. Premissas e Itens em Aberto`.
- Campos inferidos marcados como `[inferido]` na versão normativa

**Saída em disco:**
1. Append seções `## 1. Visão`, `## 2. Problema & Necessidade` em `documentos-tecnicos/01-visao/01-visao-produto.md` (criar arquivo com cabeçalho do template se inexistente)
2. Registrar em `estado-projeto.yaml`:
   ```yaml
   nome_projeto: "<nome confirmado na Fase 2 (ou ajustado na Fase 4)>"   # obrigatório — Gate 1 exige ≠ "Ainda não definido"
   artefatos:
     - nome: documentos-tecnicos/01-visao/01-visao-produto.md
       marco: M1
       iteracao: 1
   ```
3. ⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
   Invocar imediatamente `Skill("stakeholder-mapping")` usando a ferramenta Skill.

   **PROIBIDO antes desta chamada:**
   - Produzir qualquer TextBlock ao usuário (ex: "✓ Documentei...", "Próximo passo é...", "Salvei o arquivo...")
   - Escrever qualquer prosa assistente no chat
   - Finalizar o turno sem invocar a próxima Skill

   A chamada `Skill("stakeholder-mapping")` deve ser a próxima ferramenta invocada após os Writes de artefato.

<!-- internal -->
## Anti-Padrão: Solutioning Prematuro

**Como acontece:** O usuário descreve o problema (ex: "agendamento em caderno") e o agente já sugere "um sistema de agendamento digital" antes de entender o problema a fundo. A partir daí toda a elicitação orbita a solução imaginada, não a dor real.

**Como detectar:** Qualquer frase do agente que começa com "O produto vai...", "O sistema vai...", "Poderíamos criar...", "Uma funcionalidade de..." durante a Fase 1.

**O que fazer:** Bloquear completamente. Nos Turnos 1–3 da Fase 1, o agente só faz perguntas sobre o problema — nunca propõe nada. (O Turno 0 apenas CAPTURA a descrição de produto dada pelo usuário, sem o agente propor.) A solução/visão sintetizada só emerge na Fase 4.

---

## Anti-Padrão: Over-asking com Lotes Grandes

**Como acontece:** Usando o limite D14 (4 perguntas por lote) como meta em vez de teto, a skill pergunta 4 coisas de vez mesmo quando 2 já estariam claras da resposta anterior. Resultado: usuário responde de forma superficial a tudo.

**Como detectar:** Mais de 2 perguntas no mesmo lote quando a Fase 1 está em andamento.

**O que fazer:** Na Fase 1, máximo 1 pergunta por turno. Lotes de 2 só na Fase 2 (campos independentes como nome + público). O D14 é teto, não meta.
<!-- /internal -->
