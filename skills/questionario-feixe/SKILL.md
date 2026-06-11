---
name: questionario-feixe
marco: [M2]
description: >-
  Faz perguntas temáticas em grupos para cobrir áreas do produto que ainda ficaram sem informação suficiente — ativa apenas quando há lacunas em 3 ou mais áreas.
  Use na Rodada 5 do Marco 2, somente se as rodadas anteriores deixaram ≥ 3 áreas sem detalhamento.
  Conditional thematic questionnaire for layperson stakeholder; covers uncovered system areas with structured question bundles.
---

## Filosofia desta skill (Regras Absolutas)

1. **Condicional rigorosa — padrão é não executar.** < 3 áreas sem cobertura = o modeler pode inferir ou criar pautas. Executar por precaução desperdiça turnos do usuário.
2. **Máximo 2 feixes, 2 chamadas.** Um feixe = 1 tema = 1 chamada `AskUserQuestion`. Dois feixes é o limite. Mais que isso = nova iteração de elicitação, não Rodada 5.
3. **Choice, multi-choice e yesno — nunca text nesta rodada.** Respostas abertas aqui produzem dados não-estruturados que o modeler não consegue classificar diretamente. Para perguntas onde múltiplas respostas se aplicam ao mesmo tempo (ex: tipos de login aceitos, formas de comunicar eventos), usar `multi-choice` com `multiSelect: true`.

<HARD-GATE>
- NÃO executar antes de `recomendacao-implicitos` concluída (verificar seção `## Implícitos Confirmados` em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`)
- NÃO executar se `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` tem < 3 áreas com cobertura insuficiente (contar áreas conforme tabela na Fase 1)
- ⛔ STOP se houver tentativa de 3ª chamada `AskUserQuestion` — 2 feixes é o máximo absoluto; excesso vai para `pautas-reelicitacao`
</HARD-GATE>

## Fase 0 — Inicialização e Verificação da Condição

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## Implícitos Confirmados` existe em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`
3. Avaliar cobertura de `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` por área:

| Área | Sinal de cobertura insuficiente |
|---|---|
| Autenticação/acesso | Nada sobre login, perfis ou permissões |
| Notificações/comunicação | Nada sobre como o sistema comunica eventos |
| Dados/histórico | Nada sobre o que armazenar ou consultar |
| Integrações externas | Nada sobre APIs ou importação/exportação |
| Administração/configuração | Nada sobre como gestores configuram o sistema |
| Relatórios/consultas | Nada sobre como usuários consultam histórico ou geram relatórios |

4. Contar áreas com cobertura insuficiente. Se < 3: retornar ao `collector` com `skill_skipped: true, motivo: "< 3 áreas sem cobertura"`.


## Fase 1 — Seleção dos Feixes

Selecionar as 2 áreas com maior lacuna de cobertura. Para cada uma, montar 1 feixe de 3–4 perguntas (choice, multi-choice ou yesno). Aplicar o teste da combinação por pergunta antes de definir o tipo. Declarar `multiSelect: true` ou `multiSelect: false` explicitamente em cada pergunta. Usar `header` de 1 palavra ≤ 12 chars por feixe (ex: `"Acesso"`, `"Histórico"`).

**Exemplo — Feixe "Acesso e perfis":**
```
Algumas perguntas rápidas sobre quem vai usar o sistema:

1. Como cada pessoa vai entrar no produto?
   (A) Com e-mail e senha  (B) Com conta do Google/redes sociais  (C) Sem login — qualquer pessoa acessa

2. Existem perfis diferentes com permissões diferentes?
   (A) Sim — ex: administrador vê mais coisas que o usuário comum  (B) Não — todo mundo tem acesso igual

3. Se alguém esquecer a senha, como vai recuperar o acesso?
   (A) Por e-mail  (B) Por SMS  (C) Vai usar login social — não precisa

4. Precisa deslogar automaticamente após inatividade?
   (A) Sim, por segurança  (B) Não, pode ficar sempre conectado
```

**Exemplo — Feixe "Histórico e relatórios":**
```
Sobre consultas e histórico no produto:

1. Os usuários precisam ver histórico das ações que fizeram?
   (A) Sim — ex: histórico de compras, aulas concluídas  (B) Não é necessário

2. Algum perfil precisa de relatórios ou resumos?
   (A) Sim — ex: gerente quer relatório de vendas  (B) Não

3. As informações do histórico precisam ser exportadas?
   (A) Sim — ex: Excel, PDF  (B) Não é necessário

4. Por quanto tempo guardar o histórico?
   (A) Para sempre  (B) Por período específico (ex: 1 ano)  (C) Não sei ainda
```

## Fase 2 — Coleta

1 chamada `AskUserQuestion` por feixe (máximo 2 chamadas). Nunca juntar 2 feixes em 1 chamada (mistura temas, confunde usuário).

## Fase 3 — Saída

Acrescentar seção em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`:

```markdown
## Detalhamentos Adicionais (questionario-feixe — Fase A)

### Feixe 1 — [Tema]
**P1:** [resposta]  **P2:** [resposta]  **P3:** [resposta]  **P4:** [resposta]

### Feixe 2 — [Tema] (se aplicável)
...
```

Sinalizar ao `collector`: questionario-feixe concluído → Fase A encerrada → passar `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` para `modeler`.

<!-- internal -->
## Anti-Padrão: Ativação com < 3 Áreas

**Como acontece:** O collector ativa questionario-feixe após Rodada 4 por precaução ("pode ser que falte algo"). Apenas 2 áreas têm lacuna real. A skill executa 2 feixes extras — 8 perguntas adicionais que o modeler teria coberto com 2 pautas simples de reelicitação.

**Como detectar:** Verificar contagem de áreas com cobertura insuficiente antes de qualquer execução. Se < 3: rejeitar ativação imediatamente.

**O que fazer:** Retornar ao `collector` com `skill_skipped: true`. Registrar no log: "questionario-feixe: não ativado (N áreas com lacuna — mínimo é 3)". O modeler cria pautas específicas para o que faltar.
<!-- /internal -->
