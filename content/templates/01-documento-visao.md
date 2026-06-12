# Template — Documento de Visão (Marco 1)

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

**Indicadores de sucesso:**  
[O que precisa acontecer ou melhorar para o produto ser considerado bem-sucedido — ex: "reduzir conflitos de horário em 90% no primeiro mês". Se não definido: `[a definir]` e registrar na seção 5.]

---

## 3. Pessoas Envolvidas

> Quem usa o produto diretamente no dia a dia.

| Papel | Interesse principal | Influência |
|---|---|---|
| [Nome do papel — usuário direto] | [O que precisa ou espera do produto] | Alta / Média / Baixa |

> *Somente usuários diretos do produto são listados aqui.*  
> *Demais envolvidos (quem decide/paga, mantém, é afetado, regula ou representa risco) são registrados em `estado-projeto.yaml` para rastreamento interno.*

**Regras de preenchimento:**
- Campo "Decisor" registrado em `estado-projeto.yaml` (não exposto neste documento) — obrigatório para Gate 1.
- Papéis marcados `[a identificar]` → adicionar à seção 5 e a `pautas_abertas` no `estado-projeto.yaml`.

---

## 4. Contexto e Limites

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

## 5. Premissas e Itens em Aberto

> Suposições que o produto assume como verdadeiras — a serem validadas no Marco 2 ou além.

**Premissas:**
- [Ex: Usuários têm acesso à internet. Legislação X se aplica ao domínio. O decisor aprovará orçamento até data Y.]

**Itens em aberto (pautas_abertas):**
- [Papéis ou restrições marcados como `[a identificar]` neste documento]
- [Qualquer ponto que exige levantamento adicional no próximo passo]

---

*Documento de Visão — Versão normativa. Para aprovação do usuário, ver versão em `documentos-para-leigo/01-visao/01-visao-produto.md`.*
