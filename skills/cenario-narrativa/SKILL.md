---
name: cenario-narrativa
marco: [M2]
description: >-
  Pede ao usuário que conte como seria um dia típico de uso do produto e extrai funcionalidades implícitas da narrativa.
  Use após a entrevista inicial do Marco 2, para capturar o que o usuário assume mas não menciona explicitamente.
  Elicit implicit requirements from layperson stakeholder via narrative scenarios; extracts RF candidates silently.
---

## Filosofia desta skill (Regras Absolutas)

1. **Narrativa > pergunta abstrata.** Usuários leigos descrevem funcionalidades muito melhor contando histórias do que respondendo perguntas diretas. A pergunta "o que o sistema deve fazer?" produz lista pobre; "como seria um dia típico?" produz fluxo rico.
2. **Extração é silenciosa.** Nunca dizer ao usuário "estou extraindo requisitos" ou "encontrei uma funcionalidade implícita" — narrar processo interno viola Output Discipline (Z9).
3. **Cenário curto demais = dado insuficiente.** Narrativa < 3 sentenças não tem granularidade para extração. Sondar com "pode contar um pouco mais?" antes de registrar.

<HARD-GATE>
- NÃO executar antes de `entrevista-estruturada` concluída (verificar seção `## Rotina e Necessidades` em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`)
- ⛔ STOP se cenário recebido tem < 3 sentenças — sondar expansão antes de avançar para extração
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## Rotina e Necessidades` existe em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`
3. Identificar perfis distintos de `documentos-tecnicos/01-visao/01-visao-produto.md` → determinar 1 ou 2 cenários (máx 2)

## Fase 1 — Coleta

Adaptar perfis ao projeto (usar nomes/papéis de `documentos-tecnicos/01-visao/01-visao-produto.md`).

**Cenário 1 — Usuário principal (text):**
```
Imagine um dia típico de [nome do perfil principal] usando [nome do produto].

Descreva como seria a experiência desde o começo: o que ele faz primeiro no produto, o que acontece em seguida, como termina a interação. Pode ser informal — como se estivesse contando uma história.
```

**Cenário 2 — Perfil secundário, se perfis distintos com fluxos diferentes (text):**
```
E para [nome do perfil secundário], como seria um uso típico?
```

**Regra de decisão:** 1 cenário se projeto com perfil único; 2 cenários se perfis distintos com fluxos diferentes. Máximo 2 — exceder viola D14.

Invocar `AskUserQuestion` com 1 ou 2 perguntas tipo `text` (1 chamada única).

## Fase 2 — Extração Silenciosa de RFs Candidatos

Sem interação adicional com o usuário, extrair RFs candidatos usando heurísticas:

| Padrão no texto | RF candidato |
|---|---|
| "[usuário] clica em / abre / acessa [X]" | O sistema DEVE exibir [X] |
| "[usuário] cadastra / adiciona / cria [X]" | O sistema DEVE permitir cadastro de [X] |
| "[usuário] vê / consulta / verifica [X]" | O sistema DEVE exibir [X] |
| "[usuário] recebe [notificação/e-mail/mensagem]" | O sistema DEVE enviar [notificação] ao [usuário] quando [condição] |
| "[usuário] aprova / cancela / rejeita [X]" | O sistema DEVE permitir que [usuário] [ação] [X] |
| "[usuário] não consegue / tenta e falha" | Lacuna → flag para `02.6-pautas-reelicitacao` |
| "[usuário] não precisa / não quer" | Candidato a NAO_TERA |

Se ação descrita sem resultado esperado: registrar como lacuna ("Usuário mencionou [ação X] mas não descreveu resultado — possível pauta").

## Fase 3 — Saída

Acrescentar seção em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`:

```markdown
## Cenários Narrativos (cenario-narrativa — Fase A)

### Cenário 1 — [Nome do perfil]
[Texto do cenário exatamente como o usuário relatou]

### RFs candidatos extraídos do Cenário 1
- RF-CAND-001: O sistema DEVE [ação extraída] — fonte: "Cenário 1, [trecho]"
- RF-CAND-002: O sistema DEVERIA [ação extraída] — fonte: "Cenário 1, [trecho]"
```

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("recomendacao-dominio")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Extração Sem Verificar Vagueza

**Como acontece:** O usuário diz "aí eu acesso o sistema e vejo o que precisa". A extração produz "RF: O sistema DEVE exibir o que precisa" — que não é um requisito, é uma frase vaga.

**Como detectar:** RF candidato tem objeto genérico ("o que precisa", "as informações", "os dados") sem especificação. Detectar por ausência de substantivo específico no objeto.

**O que fazer:** Marcar o RF candidato como `[VAGO — especificar objeto]` no elicitacao-raw.md e criar pauta automática para `entrevista-estruturada` Fase B. Nunca registrar RF vago como candidato válido.
<!-- /internal -->
