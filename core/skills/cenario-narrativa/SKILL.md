---
name: cenario-narrativa
description: Solicita ao usuário 1–2 cenários narrativos "um dia normal de [perfil]" e extrai RFs candidatos implícitos do texto. Baseado no material Dani n08 (cenários como técnica de elicitação). Saída: cenários + RFs candidatos em elicitacao-raw.md.
when_to_use: Invocada pelo collector na Ronda 2 da Fase A. Sempre executar após entrevista-estruturada. Única chamada AskUserQuestion com 1–2 perguntas de texto livre.
---

# Skill: cenario-narrativa

**Referência:** Material Dani n08 (cenários e narrativas em ER)
**Marco:** M2 — Consenso de Escopo (Fase A, Ronda 2)
**Invocada por:** `collector`

---

## OBJETIVO

Capturar fluxos de uso reais através da narrativa do próprio usuário. Usuários leigos descrevem funcionalidades muito melhor quando contam histórias do que quando respondem perguntas abstratas. O cenário narrativo revela RFs implícitos que as perguntas diretas da Ronda 1 não capturaram.

---

## PERGUNTAS

Adaptar os perfis ao projeto (usar nomes/papéis de `visao-produto-normativo.md`):

**Cenário 1 — Usuário principal**
```
Imagine um dia típico de [nome do perfil principal] usando [nome do produto].

Descreva como seria a experiência desde o começo: o que ele faz primeiro no produto, o que acontece em seguida, como termina a interação. Pode ser informal — como se estivesse contando uma história.
```

**Cenário 2 — Perfil secundário (se houver decisor/afetado distinto)**
```
E para [nome do perfil secundário], como seria um uso típico?
```

### Quando usar 1 vs 2 cenários

- 1 cenário: projeto com perfil de usuário único (ex: artesão vendendo produtos)
- 2 cenários: projeto com perfis distintos com fluxos diferentes (ex: criança e pai no app educacional)
- Máximo 2 cenários — mais que isso gera lotes além do limite D14

### Execução

1. Invocar `AskUserQuestion` com 1 ou 2 perguntas do tipo `text`
2. Registrar os cenários em `elicitacao-raw.md`

---

## EXTRAÇÃO DE RFs CANDIDATOS

Após receber os cenários, **sem perguntar nada ao usuário**, extrair RFs candidatos:

### Heurísticas de extração

Para cada ação descrita no cenário, verificar:

| Padrão no texto | RF candidato |
|---|---|
| "[usuário] clica em / abre / acessa [X]" | O sistema DEVE exibir [X] |
| "[usuário] cadastra / adiciona / cria [X]" | O sistema DEVE permitir cadastro de [X] |
| "[usuário] vê / consulta / verifica [X]" | O sistema DEVE exibir [X] |
| "[usuário] recebe [notificação/e-mail/mensagem]" | O sistema DEVE enviar [notificação] ao [usuário] quando [condição] |
| "[usuário] aprova / cancela / rejeita [X]" | O sistema DEVE permitir que [usuário] [ação] [X] |
| "[usuário] não consegue / tenta e falha" | O sistema DEVE [comportamento correto] — lacuna → pauta |
| "[usuário] não precisa / não quer" | Item a avaliar como NAO_TERA |

### Formato de extração

```markdown
## Cenários Narrativos (cenario-narrativa — Fase A)

### Cenário 1 — [Nome do perfil]
[Texto do cenário exatamente como o usuário relatou]

### RFs candidatos extraídos do Cenário 1
- RF-CAND-001: O sistema DEVE [ação extraída] — fonte: "Cenário 1, [trecho]"
- RF-CAND-002: O sistema DEVERIA [ação extraída] — fonte: "Cenário 1, [trecho]"

### Cenário 2 — [Nome do segundo perfil] (se aplicável)
[Texto]

### RFs candidatos extraídos do Cenário 2
- RF-CAND-003: ...
```

---

## NOTAS SOBRE LACUNAS

Se o usuário descreve uma ação mas não explica o resultado esperado:
- Registrar como lacuna: "Usuário mencionou [ação X] mas não descreveu o resultado — possível pauta para `entrevista-estruturada` na Fase B"
- Não interromper o fluxo da Ronda 2 — a lacuna será tratada pelo `modeler` em `pautas-reelicitacao`

---

## REGRAS (D14 + D19)

- Máximo 2 perguntas nesta skill (tipo `text`)
- Não usar termos da blacklist D1 nas perguntas
- A extração de RFs é silenciosa (não exibir ao usuário "extraindo requisitos" ou similar)
- RFs candidatos são rascunhos: o modeler classifica e consolida no Passo 1 da Fase B

---

## SAÍDA

Seção adicionada a `elicitacao-raw.md` com cenários + RFs candidatos extraídos.
