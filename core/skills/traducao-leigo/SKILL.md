---
name: traducao-leigo
description: Verifica e reescreve texto para remover jargão técnico de ER, garantindo que o usuário leigo não receba termos da blacklist D1. Invocada por qualquer agente antes de apresentar texto ao usuário.
when_to_use: Antes de qualquer exibição de texto ao usuário — perguntas, resumos, artefatos, confirmações.
---

# Skill: traducao-leigo

**Decisão:** D19 — Enforcement de jargão em runtime
**Tipo:** Transversal — disponível para todos os sub-agentes
**Estado:** apátrida — sem memória entre invocações

---

## ENTRADA

Receber um trecho de texto (string) que será apresentado ao usuário.

---

## PROCESSO

### 1. Verificar presença de termos proibidos

Checar se o texto contém qualquer termo da blacklist:

**Termos proibidos e substituições:**

| Termo proibido (e variantes) | Substituição |
|---|---|
| requisito funcional, RF, requisitos funcionais | o que o produto precisa fazer |
| requisito não-funcional, RNF, requisito de qualidade | como o produto precisa se comportar |
| elicitar, elicitação, levantar requisitos | descobrir, entender, levantar |
| rastreabilidade, rastrear | saber de onde veio cada decisão |
| stakeholder, partes interessadas (no sentido técnico) | pessoas envolvidas, quem tem interesse no projeto |
| escopo (no sentido técnico de ER) | o que está dentro e fora do projeto |
| iteração, sprint | etapa, rodada de trabalho |
| backlog | lista de coisas a fazer |
| caso de uso | situação de uso, como a pessoa vai usar |
| SRS, ERS, documento de requisitos (sigla) | documento do projeto |
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

### 2. Reescrever

Se algum termo proibido foi encontrado:
- Substituir pelo equivalente leigo
- Manter o sentido original completo
- Manter tom conversacional e natural em português brasileiro

Se nenhum termo proibido foi encontrado:
- Retornar o texto original sem alteração

### 3. Verificação pós-reescrita

Após a substituição, passar o texto reescrito pela verificação novamente para garantir que não sobraram termos da blacklist (substituições em cascata podem introduzir novos termos problemáticos).

---

## SAÍDA

Texto reescrito em linguagem de negócio, sem jargão de ER, pronto para exibição ao usuário.

---

## EXEMPLO

**Entrada (com jargão):**
```
Identificamos os seguintes stakeholders para o projeto:
- Usuário final (persona: comprador)
- Administrador do sistema

Os requisitos funcionais levantados na elicitação incluem...
```

**Saída (sem jargão):**
```
Identificamos as seguintes pessoas envolvidas no projeto:
- A pessoa que vai usar o produto (perfil: comprador)
- O administrador do sistema

O que o produto precisa fazer, com base no que entendemos até agora, inclui...
```

---

## REGRA DE OURO

Em caso de dúvida sobre um termo: se um dono de negócio sem formação em TI pode não entender o termo, reescrever.
