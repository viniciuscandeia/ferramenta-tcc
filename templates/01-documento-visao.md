# Template — Documento de Visão (Marco 1)

**Padrão:** ISO/IEC/IEEE 29148 — Stakeholder Needs and Requirements Definition (StRS / Documento de Visão)  
**Gerado por:** skill `necessidade-visao` + `stakeholder-mapping` + `contexto-e-limite` → compilado por `traducao-gate` (Fase 1, M1)  
**Artefato:** `documentos-tecnicos/01-visao/01-visao-produto.md`  
**Tamanho esperado:** 350–700 palavras  

> **Nota de escopo:** Este documento captura NECESSIDADES e VISÃO — não requisitos. Requisitos funcionais e de qualidade são artefatos do Marco 2. Não usar EARS / RFC 2119 aqui.

---

## 1. Visão

> **Frase-síntese** no formato Geoffrey Moore (sintetizada pelo agente, confirmada pelo usuário):
>
> "Para **[público-alvo]** que **[necessidade ou dor central]**, o **[nome do produto]** é um **[categoria — app, plataforma, sistema, serviço]** que **[benefício principal]**. Diferente de **[como resolvem hoje — ex: planilha, processo manual, sistema legado]**, ele **[diferencial]**."

---

## 2. Problema & Necessidade

> O que está errado hoje — a dor real chegada via 5-Whys/JTBD, sem propor solução ou listar features.

**A dor:**  
[Descrição do problema raiz — o que acontece e por quê importa]

**Quem sofre:**  
[Grupos de pessoas diretamente impactadas pelo problema]

**Impacto concreto:**  
[Consequências observáveis — tempo perdido, erros, custo, risco, frustração, etc.]

**Necessidade central (JTBD):**  
[Em linguagem Jobs-to-be-Done: "Quando [situação], eu preciso [resultado desejado], para que [motivação/consequência positiva]."]

---

## 3. Objetivos e Metas de Sucesso

> Como saberemos que o produto deu certo? Formulado como objetivos mensuráveis (KPIs / metas de negócio).

| Objetivo | Indicador de sucesso | Prazo / horizonte |
|---|---|---|
| [Objetivo de negócio 1] | [Como medir — ex: reduzir X em Y%, atingir Z usuários] | [Quando esperamos ver] |
| [Objetivo de negócio 2] | ... | ... |

*Se o usuário não souber: registrar como `[a definir]` e adicionar à seção 6 (Premissas e Itens em Aberto).*

---

## 4. Pessoas Envolvidas

> Mapeamento Stakeholder Onion — trabalhado da camada interna para a externa.

| Papel | Camada | Interesse principal | Influência | Decisor |
|---|---|---|---|---|
| [Nome do papel] | Usa diretamente / Decide-paga / Mantém-suporta / Afetado / Regula / Adversário | [O que precisa ou espera do produto] | Alta / Média / Baixa | Sim / Não |

**Regras de preenchimento:**
- Cada camada do onion deve ter pelo menos uma entrada ou justificativa de por que não se aplica.
- Campo "Decisor: Sim" obrigatório para pelo menos um papel antes do Gate 1.
- Papéis marcados `[a identificar]` → adicionar à seção 6 e a `pautas_abertas` no `estado-projeto.yaml`.

**Camadas do Stakeholder Onion:**
1. **Usa diretamente** — opera o produto no dia a dia
2. **Decide-paga** — aprova, financia ou define prioridades
3. **Mantém-suporta** — cuida da operação após entrega (suporte, infra, manutenção)
4. **Afetado** — impactado pelos resultados sem usar diretamente
5. **Regula** — entidade que impõe regras externas (legal, compliance, órgão regulador)
6. **Adversário** — quem pode tentar abusar, atacar ou contornar o sistema (não tem acesso)

---

## 5. Contexto e Limites

> O que está dentro e fora do produto — define a fronteira do sistema.

### O que o produto faz

[Bullet list de atividades principais — inferidas/confirmadas das fases anteriores. Objetivo: 3-7 itens.]

### O que o produto NÃO faz

[Bullet list de exclusões explícitas — ao menos 1 item obrigatório.]

### Integrações com outros sistemas

[Bullet list de sistemas externos com os quais o produto se conecta — ex: sistema de pagamento, WhatsApp, ERP. Se nenhum: "Nenhuma integração identificada nesta fase."]

### Restrições conhecidas

| Tipo | Descrição |
|---|---|
| [Prazo / Orçamento / Técnica / Legal / Organizacional] | [Detalhe — sondado proativamente para domínios regulados] |

*Se nenhuma: "Nenhuma restrição identificada nesta fase."*

---

## 6. Premissas e Itens em Aberto

> Suposições que o produto assume como verdadeiras — a serem validadas no Marco 2 ou além.

**Premissas:**
- [Ex: Usuários têm acesso à internet. Legislação X se aplica ao domínio. O decisor aprovará orçamento até data Y.]

**Itens em aberto (pautas_abertas):**
- [Papéis ou restrições marcados como `[a identificar]` neste documento]
- [Metas de sucesso marcadas `[a definir]`]
- [Qualquer ponto que exige elicitação adicional no Marco 2]

---

*Documento de Visão — Versão normativa. Para aprovação do usuário, ver versão em `documentos-para-leigo/01-visao/01-visao-produto.md`.*
