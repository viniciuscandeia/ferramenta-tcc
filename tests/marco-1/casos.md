# Casos de Teste — Marco 1: Definição da Necessidade (v0.7.0)

Três casos canônicos para verificação do workflow M1 (`stakeholder-identifier`).
Cada caso parte do zero — simula a primeira interação do usuário com `/iniciar-produto`.

**Sequência esperada em todos os casos:** `necessidade-visao` → `stakeholder-mapping` → `contexto-e-limite` → [`clarificacao-pos-visao`] → `traducao-gate` → Gate 1

---

## Caso 1 — Frase Curta (entrada mínima)

**Descritor:** `caso-1-frase-curta`
**Domínio:** controle interno / varejo
**Complexidade:** baixa — input vago, `clarificacao-pos-visao` deve ser ativada

### Entrada inicial do usuário

```
Quero um sistema para controlar o estoque da minha lojinha.
```

### Comportamento esperado — sequência de skills

1. **`necessidade-visao`**:
   - Fase 1 (5-Whys): 2–3 perguntas adaptativas sobre o problema atual (ex: "O que está difícil com o controle de estoque hoje?", "O que acontece quando você não sabe o que tem no estoque?")
   - Fase 2: confirma nome (sugerido "sistema de estoque" ou similar) e público (dono da loja + funcionário se houver)
   - Fase 3: meta de sucesso ("Como você vai saber que funcionou?")
   - Fase 4: sintetiza frase Moore (ex: "Para donos de lojas pequenas que perdem o controle das mercadorias, o [nome] é um sistema que...") — confirma em choice
   - **NÃO** pergunta funcionalidades nem solução durante Fase 1

2. **`stakeholder-mapping`**:
   - Pré-extração: "dono da lojinha" capturado
   - Checklist de camadas: adiciona Decide-paga (o próprio dono), Mantém (dono ou funcionário), pergunta se tem funcionário operando
   - Domínio: varejo → sem regulação obrigatória

3. **`contexto-e-limite`**:
   - Pré-inferência: "controlar estoque" inferido como "dentro"
   - Confirmação do dentro via choice
   - Pergunta: o que NÃO vai fazer? (ex: financeiro/caixa, nota fiscal, folha de pagamento)
   - Resultado: `lacunas_m1.contagem` deve ser ≥ 2 (frase muito curta → escopo funcional e metas provavelmente insuficientes)

4. **`clarificacao-pos-visao`**: **ativada** — `lacunas_m1.contagem ≥ 2`
   - ≤3 perguntas fechadas sobre escopo (ex: "O sistema vai registrar entradas e saídas, ou só consultar?") e/ou restrições/metas

5. **`traducao-gate`**: gera ambas as versões com as 6 seções do Documento de Visão

### Artefatos esperados ao final

| Arquivo | Obrigatório? |
|---|---|
| `documentos-tecnicos/01-visao/01-visao-produto.md` | Sim |
| `documentos-para-leigo/01-visao/01-visao-produto.md` | Sim |

### Critério de aceitação

- Seção 2 (Problema) descreve dor de controle manual — sem lista de funcionalidades
- `clarificacao-pos-visao` ativada (input inicial vago)
- Total de perguntas ≤ 13
- Versão leigo sem termos da blacklist

---

## Caso 2 — Texto Livre Longo (entrada rica)

**Descritor:** `caso-2-texto-longo`
**Domínio:** saúde
**Complexidade:** média — múltiplos stakeholders, restrições regulatórias (LGPD + CFM), clarificação provavelmente não ativada

### Entrada inicial do usuário

```
Sou médica e trabalho numa clínica pequena com mais dois médicos e uma recepcionista.
Hoje o problema é que a recepcionista anota os pacientes num caderno, os médicos precisam
gritar de uma sala para a outra para saber quem é o próximo, e às vezes um paciente
espera 2 horas sem saber quanto tempo falta. Quero um sistema de triagem onde a
recepcionista coloca o paciente na fila, cada médico vê sua própria fila no celular
e pode chamar o próximo com um botão. Os pacientes também receberiam uma senha e
poderiam ver no TV da sala de espera qual senha está sendo chamada. Precisa ser simples
porque a recepcionista não tem muita experiência com tecnologia. Ah, e tem que guardar
o histórico de atendimentos porque o plano de saúde exige.
```

### Comportamento esperado — sequência de skills

1. **`necessidade-visao`**:
   - Fase 0 pré-extração: identifica "fila manual em caderno", "médicos e recepcionista", "plano de saúde", meta candidata "paciente sabe quanto tempo falta"
   - Fase 1: 1–2 perguntas de sondagem máximo (texto já fornece muito — pode pular Turno 2 se impacto claro)
   - Fase 2: confirma nome candidato (pode sugerir "sistema de triagem" ou usar o que o usuário disse) + público já claro (recepcionista + médicos + pacientes)
   - Fase 4: síntese Moore confirma em choice (sem nova pergunta aberta)
   - **Máximo 5 turnos** (texto rico já cobre a maior parte)

2. **`stakeholder-mapping`**:
   - Pré-extração: recepcionista, médicos (×3), pacientes, plano de saúde → todos já na tabela inicial
   - Checklist de camadas: Decide-paga perguntado (quem aprova?), Mantém perguntado (TI/dono?), Regula → **obrigatório** por domínio saúde → pergunta sobre CFM/LGPD
   - Resultado: ≥4 papéis com camadas distintas

3. **`contexto-e-limite`**:
   - Pré-inferência: fila, chamada, painel TV, histórico → dentro
   - Confirmação do dentro via choice (texto já fornece)
   - Pergunta: o que NÃO vai fazer? (prontuário completo, cobrança, agendamento futuro)
   - Restrições: LGPD + CFM (já mencionados indiretamente pelo "plano de saúde exige")
   - `lacunas_m1.contagem` provavelmente < 2 → clarificação não ativada

4. **`clarificacao-pos-visao`**: **provavelmente não ativada** — texto rico cobre as categorias

5. **`traducao-gate`**: gera ambas as versões

### Artefatos esperados ao final

| Arquivo | Obrigatório? |
|---|---|
| `documentos-tecnicos/01-visao/01-visao-produto.md` | Sim |
| `documentos-para-leigo/01-visao/01-visao-produto.md` | Sim |

### Critério de aceitação

- ≥4 papéis mapeados com camadas Onion distintas
- Camada "Regula" presente (plano de saúde / CFM / LGPD)
- Restrição Legal registrada na Seção 5
- `clarificacao-pos-visao` não ativada (ou ativada com ≤3 perguntas se alguma lacuna existir)
- Versão leigo usa linguagem informal ("ficha de espera", "ordem de chamada") — nunca "stakeholder", "escopo", "RF"
- Total de perguntas ≤ 10 (texto rico = menos turnos necessários)

---

## Caso 3 — Revisão no Gate 1 (fluxo NÃO → revisão → SIM)

**Descritor:** `caso-3-revisao-gate1`
**Complexidade:** baixa/média — testa o ciclo de reprovação do Gate 1 e retomada

### Cenário

Input M1: aplicativo de delivery para restaurante familiar.

```
Quero um app de delivery para o meu restaurante. Os clientes fazem o pedido pelo celular
e a cozinha recebe. A gente entrega ou o cliente retira. Tenho dois funcionários na cozinha
e um no caixa.
```

### Sequência até o Gate 1

1. Skills M1 executam normalmente (necessidade-visao → stakeholder-mapping → contexto-e-limite → traducao-gate)
2. Orquestrador apresenta versão leigo ao usuário com `AskUserQuestion` (yesno)
3. **Usuário responde "Não"** com feedback: "Faltou mencionar que os pedidos vêm só pelo WhatsApp, não por app próprio. E eu quero acompanhar o estoque de ingredientes também."

### Comportamento esperado após "Não"

1. Orquestrador registra `gate_status.gate_1: pendente` (não avança para M2)
2. `stakeholder-identifier` retoma com o feedback — detecta 2 pontos: (a) canal errado (WhatsApp, não app), (b) funcionalidade nova (controle de ingredientes)
3. `clarificacao-pos-visao` invocada para resolver os pontos específicos (sem re-executar fluxo completo):
   - Confirma WhatsApp como único canal (choice)
   - Confirma controle de ingredientes no escopo (yesno)
4. `traducao-gate` regenera ambas as versões com as correções (canal + escopo de ingredientes)
5. Orquestrador apresenta versão leigo revisada (segunda rodada do Gate 1)
6. **Usuário responde "Sim"** → `gate_status.gate_1: aprovado`, `gate_1_aprovado_em`, `marco_corrente: M2` escritos em `estado-projeto.yaml`

### Artefatos esperados ao final

| Arquivo | Conteúdo esperado |
|---|---|
| `documentos-tecnicos/01-visao/01-visao-produto.md` | Canal = WhatsApp na Seção 1 (Visão) e Seção 5 (Contexto); controle de ingredientes em "O que o produto faz" |
| `documentos-para-leigo/01-visao/01-visao-produto.md` | Idem, em linguagem de negócio |

### Critério de aceitação

- Gate 1 com input "Não" **não avança** para M2 (confirmed by `gate_status.gate_1: pendente`)
- Feedback incorporado nas versões finais (canal WhatsApp + ingredientes)
- Segunda apresentação do Gate 1 com versão revisada
- `gate_status.gate_1: aprovado` apenas após "Sim" na segunda rodada
- `gate_guard.sh` bloquearia tentativa de escrever `aprovado` antes dos artefatos finalizados
