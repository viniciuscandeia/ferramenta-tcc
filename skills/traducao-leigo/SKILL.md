---
name: traducao-leigo
marco: [M1, M2, M3]
description: Verifica e reescreve texto para remover jargão técnico de ER, garantindo que o usuário leigo não receba termos da blacklist D1. Invocada por qualquer agente antes de apresentar texto ao usuário.
when_to_use: Antes de qualquer exibição de texto ao usuário — perguntas, resumos, artefatos, confirmações.
---

## Filosofia desta skill (Regras Absolutas)

1. **Em dúvida, substituir.** Critério D1: "se um dono de negócio sem formação em TI pode não entender o termo → reescrever". A régua é o usuário final, não o desenvolvedor.
2. **Verificação em cascata obrigatória.** Substituição pode introduzir novo termo proibido ("documentação de requisitos" vira "artefato do projeto" → "artefato" ainda é jargão). Verificar o texto reescrito novamente antes de retornar.
3. **Strip de blocos `<!-- internal -->` antes de exibir.** Conteúdo marcado `<!-- internal -->` nunca chega ao usuário — remover o bloco completo, não só a marcação.

<HARD-GATE>
- NÃO executar sem texto de entrada definido
- ⛔ STOP se texto de entrada vier de bloco `<!-- internal -->` — não reescrever nem exibir; remover integralmente
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar se texto contém blocos `<!-- internal -->...</ internal -->` — remover antes de processar
3. Se após remoção o texto for vazio: retornar vazio (não há nada para exibir)

## Fase 1 — Verificação de Termos Proibidos

Checar presença de qualquer termo da blacklist D1:

| Termo proibido (e variantes) | Substituição |
|---|---|
| requisito funcional, RF, requisitos funcionais | o que o produto precisa fazer |
| requisito não-funcional, RNF, requisito de qualidade | como o produto precisa se comportar |
| elicitar, elicitação, levantar requisitos | descobrir, entender, levantar |
| rastreabilidade, rastrear | saber de onde veio cada decisão |
| stakeholder, partes interessadas (no sentido técnico) | pessoas envolvidas, quem tem interesse no produto |
| escopo (no sentido técnico de ER) | o que está dentro e fora do produto |
| iteração, sprint | etapa, rodada de trabalho |
| backlog | lista de coisas a fazer |
| caso de uso | situação de uso, como a pessoa vai usar |
| SRS, ERS, documento de requisitos (sigla) | documento do produto |
| marco (no sentido de fase ER) | fase, etapa principal |
| sub-agente, agente (ferramenta interna) | [remover — não mencionar ao usuário] |
| skill, técnica de ER | [remover — não mencionar ao usuário] |
| persona | perfil de usuário, tipo de pessoa que usa |
| jornada do usuário | caminho que a pessoa percorre |
| priorização, MoSCoW, Kano, IEEE | o que é mais importante, o que vem primeiro |
| baseline | versão salva, ponto de controle |
| gate, aprovação de gate | confirmação da fase |
| EARS, RFC 2119, MUST, SHALL, SHOULD | [remover da saída ao usuário] |
| Gherkin, BDD, feature file, step definition | [remover — não mencionar ao usuário] |
| artefato | documento, arquivo do projeto |
| fluxo de trabalho, workflow | passo a passo |

## Fase 2 — Reescrita e Verificação em Cascata

**Se termos proibidos encontrados:**
1. Substituir pelo equivalente leigo da tabela
2. Manter sentido original completo
3. Manter tom conversacional e natural em português brasileiro
4. Passar o texto reescrito pela Fase 1 novamente — substituições em cascata podem introduzir novos termos

**Se nenhum termo proibido:**
- Retornar texto original sem alteração

## Fase 3 — Saída

Texto reescrito em linguagem de negócio, sem jargão de ER, pronto para exibição ao usuário.

**Exemplo:**

Entrada (com jargão):
```
Identificamos os seguintes stakeholders para o projeto:
- Usuário final (persona: comprador)
Os requisitos funcionais levantados na elicitação incluem...
```

Saída (sem jargão):
```
Identificamos as seguintes pessoas envolvidas no projeto:
- A pessoa que vai usar o produto (perfil: comprador)
O que o produto precisa fazer, com base no que entendemos até agora, inclui...
```

<!-- internal -->
## Anti-Padrão: Termo Técnico Aprovado Por Parecer Comum

**Como acontece:** "gateway de pagamento" não é substituído porque "gateway" parece comum ao desenvolvedor. "Fluxo de aprovação" passa porque "fluxo" não está literalmente na blacklist. O usuário leigo não reconhece nenhum dos dois como linguagem do seu negócio.

**Como detectar:** Aplicar o critério D1 estritamente — a pergunta é "um dono de negócio sem formação em TI entende este termo?", não "este termo parece técnico para mim?".

**O que fazer:** Se a resposta à pergunta D1 for "talvez não" → substituir ou reformular. O custo de sobrestimar a complexidade é zero; o custo de subestimá-la é confundir o usuário no gate.
<!-- /internal -->
