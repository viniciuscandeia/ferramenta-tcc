# Casos de Teste — Marco 1: Definição da Necessidade

Três casos canônicos para verificação do workflow M1 (`stakeholder-identifier`).
Cada caso parte do zero — simula a primeira interação do usuário com `/iniciar-projeto`.

---

## Caso 1 — Frase Curta (entrada mínima)

**Descritor:** `caso-1-frase-curta`
**Domínio:** controle interno / varejo
**Complexidade:** baixa — input vago activa `clarificacao-pos-visao` (D16)

### Entrada inicial do usuário

```
Quero um sistema para controlar o estoque da minha lojinha.
```

### Comportamento esperado — sequência de skills

1. **`vision-box`**: com input vago, faz 1 lote de 4 perguntas (nome do produto, quem vai usar, benefício principal, o que o diferencia de uma planilha/caderno). Preenche 4 campos da Visão do Produto.
2. **`situacao-problema`**: 2 lotes (4 + 2 perguntas). Extrai: problema principal (descontrole de estoque), afetados (dono da loja, possível funcionário), impacto, solução esperada, usuários e funcionalidades-chave.
3. **`stakeholder-mapping`**: 1 lote de 4. Identifica: dono da loja (usuário direto + decisor), funcionário (usuário operacional), fornecedor (afetado indireto).
4. **`contexto-e-limite`**: 1 lote de 4. Define: o sistema controla produtos e movimentações; **não** controla financeiro/caixa; integração com leitor de código de barras questionada.
5. **`clarificacao-pos-visao`**: **ativada** (input vago → lacunas críticas em ≥ 2 categorias: público-alvo e funcionalidades). ≤ 3 perguntas (choice/yesno). Esclarece: quem acessa além do dono? sistema web ou só celular? alertas de estoque mínimo necessários?
6. **`traducao-gate`**: gera `visao-produto-normativo.md` + `visao-produto-leigo.md`.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `visao-produto-normativo.md` | Sim | Sim |
| `visao-produto-leigo.md` | Sim | Sim |

### Critério de aceitação

- Vision Box com os 4 campos preenchidos (produto, público, benefício, diferencial)
- `clarificacao-pos-visao` ativada (input inicial vago)
- Versão leigo sem termos da blacklist

---

## Caso 2 — Texto Livre Longo (entrada rica)

**Descritor:** `caso-2-texto-longo`
**Domínio:** saúde
**Complexidade:** média — múltiplos stakeholders, restrições regulatórias (LGPD + CFM), `clarificacao-pos-visao` pode não ser ativada se input já suficiente

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

1. **`vision-box`**: extrai do texto: produto (sistema de triagem), público (recepcionista + médicos + pacientes), benefício (eliminar caos na fila de espera), diferencial (visibilidade para todos — médico no celular, paciente na TV). Pode fazer 1–2 perguntas de confirmação, não o lote completo se o texto já preenche os campos.
2. **`situacao-problema`**: extrai: problema (anotação em caderno + comunicação vocal + espera sem previsão), afetados (pacientes, recepcionista, médicos), impacto (demora, frustração, retrabalho), solução (fila digital com painel), usuários (3 tipos), funcionalidades-chave (fila por médico, chamada por botão, painel TV, histórico).
3. **`stakeholder-mapping`**: identifica ≥ 3 stakeholders com papéis distintos: recepcionista (usuária operacional), médico × 3 (usuários técnicos + decisores), paciente (afetado direto), plano de saúde (afetado regulatório). Reconhece que "plano de saúde exige histórico" = restrição regulatória.
4. **`contexto-e-limite`**: define escopo: dentro (fila, chamada, painel, histórico); fora (prontuário eletrônico completo, cobrança, agendamento de consultas futuras). Detecta integração com TV (painel display).
5. **`clarificacao-pos-visao`**: **provavelmente não ativada** — texto rico cobre a maioria das categorias. Se ativada, ≤ 3 perguntas sobre detalhes técnicos do painel de TV ou acesso remoto dos médicos.
6. **`traducao-gate`**: gera ambas as versões.

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `visao-produto-normativo.md` | Sim | Sim |
| `visao-produto-leigo.md` | Sim | Sim |

### Critério de aceitação

- ≥ 3 stakeholders mapeados com papéis distintos
- Restrição regulatória (histórico para plano de saúde) registrada no contexto/limite
- `clarificacao-pos-visao` não-ativada (ou ativada com ≤ 3 perguntas mínimas)
- Versão leigo usa "ficha de espera" / "ordem de atendimento" (nunca "escopo", "stakeholder", "RF")

---

## Caso 3 — Revisão no Gate 1 (fluxo NÃO → revisão → SIM)

**Descritor:** `caso-3-revisao-gate1`
**Complexidade:** baixa/média — testa o ciclo de reprovação do Gate 1 e retomada

### Cenário

Input M1 simulado: aplicativo de delivery para restaurante familiar.

```
Quero um app de delivery para o meu restaurante. Os clientes fazem o pedido pelo celular
e a cozinha recebe. A gente entrega ou o cliente retira. Tenho dois funcionários na cozinha
e um no caixa.
```

### Sequência até o Gate 1

1. Skills M1 executam normalmente (vision-box → situacao-problema → stakeholder-mapping → contexto-e-limite → traducao-gate).
2. Orquestrador apresenta `visao-produto-leigo.md` ao usuário com AskUserQuestion (yesno): "Esse texto descreve bem o que você imagina para o projeto? ..."
3. **Usuário responde "Não"** com feedback: "Faltou mencionar que os pedidos vêm só pelo WhatsApp, não por app próprio. E eu quero acompanhar o estoque de ingredientes também."

### Comportamento esperado após "Não"

1. Orquestrador registra `gate_status.gate_1: pendente` (não avança para M2).
2. `stakeholder-identifier` retoma a partir do feedback — detecta 2 lacunas: (a) canal de pedido errado (WhatsApp, não app próprio); (b) funcionalidade nova (controle de estoque de ingredientes).
3. Clarificação focada: ≤ 3 perguntas para confirmar detalhes das lacunas (ex: "O WhatsApp será o único canal ou haverá também site?").
4. `traducao-gate` regenera as duas versões com as correções.
5. Orquestrador apresenta versão leigo revisada (segunda rodada do Gate 1).
6. **Usuário responde "Sim"** → `gate_1: aprovado` em `estado-projeto.yaml` + avançar para M2.

### Artefatos esperados ao final

| Arquivo | Versão | Conteúdo esperado |
|---|---|---|
| `visao-produto-normativo.md` | Normativa (final) | Canal = WhatsApp; escopo inclui controle de ingredientes |
| `visao-produto-leigo.md` | Leigo (final) | Idem, em linguagem de negócio |

### Critério de aceitação

- Gate 1 com input "Não" **não avança** para M2 (gate não abre)
- Feedback do usuário é incorporado nas versões finais (canal WhatsApp + estoque ingredientes)
- Segunda apresentação do Gate 1 com versão revisada
- Usuário aprova na segunda tentativa → `gate_1: aprovado` registrado em `estado-projeto.yaml`
- `estado-projeto.yaml` reflete `gate_1: aprovado` apenas após "Sim"
