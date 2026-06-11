---
name: glossario
marco: [M2]
description: >-
  Identifica termos do projeto que podem gerar confusão e cria definições claras para cada um — evitando que a mesma palavra signifique coisas diferentes para pessoas diferentes.
  Use no Marco 2, após classificar e priorizar os itens, operando sobre o texto já coletado.
  Build project glossary from collected artifacts; detects domain terms, acronyms, and polysemous words; no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de ambiguidade** — "cliente" pode significar quem compra, quem usa, ou quem contratou o software. Ambiguidade silenciosa em M2 vira bug de requisito em M3. Cada termo polissêmico entra no glossário.
2. **Sem interação com usuário.** O glossário é construído do material já coletado. Perguntar sobre termos gera jargão desnecessário — o texto do usuário já contém a definição implícita.
3. **Termo com definição incerta não é silenciado.** Flag `[DEFINIÇÃO INCERTA]` + pauta em `pautas-reelicitacao` — melhor uma lacuna visível do que uma definição errada.

<HARD-GATE>
- NÃO executar antes de `priorizacao` concluída (verificar que `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` tem campo Modal preenchido)
- NÃO executar com `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` ausente
- ⛔ STOP se resultado tem 0 termos candidatos — revisar critérios (frequência mínima pode ser muito alta para projeto pequeno) e reexecutar com critério relaxado
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/01-visao/01-visao-produto.md` acessíveis
3. Concatenar textos de entrada (exceto metadados/cabeçalhos)

## Fase 1 — Detecção de Candidatos

**Critérios de inclusão (≥ 1 para entrar):**

| Critério | Exemplos |
|---|---|
| Substantivo do domínio com freq ≥ 2 | "pedido", "catálogo", "sessão", "perfil", "relatório" |
| Acrônimo não-expandido | "SKU", "LGPD", "CPF", "API", "SLA" |
| Termo com múltiplos sentidos no contexto | "cliente" (comprador? empresa contratante?), "usuário" (admin ou consumidor?) |
| Termo técnico do negócio sem equivalente óbvio | "frete grátis a partir de X", "controle parental", "nível de progressão" |
| Termo que gerou pergunta de clarificação | qualquer item de `clarificacao-pos-visao` ou pauta existente |

**Exclusões:**
- Termos do português corrente sem ambiguidade ("nome", "senha", "botão")
- Termos da blacklist D1 (nunca aparecem ao usuário)
- Termos de ER internos ao modeler

**Algoritmo:**
1. Extrair todos os substantivos e substantivos compostos dos textos concatenados
2. Contar frequência de cada termo
3. Termos freq ≥ 2: verificar se têm definição explícita → sem definição = candidato
4. Termos freq < 2: verificar outros critérios (acrônimo, polissemia, domínio)
5. Para definições incertas: marcar `[DEFINIÇÃO INCERTA]`

## Fase 2 — Construção das Entradas

Para cada termo candidato, construir entrada com 3 campos obrigatórios:

```markdown
**[Termo]**
Definição: [explicação em linguagem de negócio, sem jargão técnico]
Exemplos: [1–2 exemplos concretos do contexto do projeto]
Sinônimos usados no projeto: [outros termos para a mesma coisa, ou "nenhum"]
```

**Exemplo preenchido:**
```markdown
**Pedido**
Definição: Solicitação formal de compra feita por um cliente após escolher produtos. Um pedido tem número único, data, lista de itens, valor total e status (aguardando, em preparo, enviado, entregue).
Exemplos: "Pedido #1042 — 3 itens — R$ 89,90 — status: enviado"
Sinônimos usados no projeto: "compra" (nas respostas do usuário), "solicitação" (no e-mail de confirmação)

**LGPD**
Definição: Lei Geral de Proteção de Dados (Lei 13.709/2018). Regula como dados pessoais de usuários brasileiros devem ser coletados, armazenados e usados. Implica: consentimento explícito, direito de exclusão e política de privacidade.
Exemplos: "O usuário deve poder solicitar exclusão de sua conta e dados associados."
Sinônimos usados no projeto: "proteção de dados", "lei de dados"
```

Mínimo 5 termos para qualquer projeto. Se menos: relaxar critério de frequência para 1 ocorrência.

## Fase 3 — Saída

Criar `documentos-tecnicos/02-requisitos/02.5-glossario.md`:

```markdown
# Glossário do Produto

> Termos específicos do domínio usados neste produto.

---

[entradas por ordem alfabética]
```

Criar pauta em `documentos-tecnicos/02-requisitos/02.6-pautas-reelicitacao.md` para cada termo marcado `[DEFINIÇÃO INCERTA]`.

Sinalizar ao `modeler`: glossário concluído → prosseguir para `conflitos-detect` (Passo 4).

<!-- internal -->
## Anti-Padrão: Termo Polissêmico com Uma Só Definição

**Como acontece:** "cliente" aparece 8 vezes em elicitacao-raw.md. O glossário registra apenas a definição de "quem compra" porque foi a mais frequente. Mas em 2 ocorrências, "cliente" significava "empresa que contratou o software". O checker M3 não detecta a ambiguidade porque o glossário parece completo.

**Como detectar:** Após construir a definição, reler as ocorrências no texto com a definição em mente. Se 1+ ocorrência parece inconsistente com a definição construída → adicionar variante ao campo "Sinônimos" ou dividir em 2 entradas ("cliente (comprador)" e "cliente (contratante)").

**O que fazer:** Dividir o termo em 2 entradas distintas com nomes específicos. Ambiguidade de domínio vai para 2 verbetes — nunca para 1 verbete com nota de rodapé.
<!-- /internal -->
