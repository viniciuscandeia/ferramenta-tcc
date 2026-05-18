---
name: questionario-feixe
description: Skill condicional — agrupa perguntas de detalhamento por tema (feixes) para cobrir áreas do sistema sem cobertura após as Rondas 1–4. Ativa apenas se ≥ 3 áreas com lacunas de detalhamento. Máximo 2 feixes (2 chamadas AskUserQuestion de 4 perguntas cada).
when_to_use: Invocada pelo collector na Ronda 5 da Fase A SOMENTE SE ≥ 3 áreas do sistema ainda não têm detalhamento claro após entrevista-estruturada + cenario-narrativa + recomendacao-dominio + recomendacao-implicitos.
---

# Skill: questionario-feixe

**Marco:** M2 — Consenso de Escopo (Fase A, Ronda 5 — condicional)
**Invocada por:** `collector`

---

## CONDIÇÃO DE ATIVAÇÃO

**Ativar se e somente se:** após completar as Rondas 1–4, verificar o `elicitacao-raw.md` acumulado e constatar que ≥ 3 das seguintes áreas ainda não têm informação suficiente para classificação pelo modeler:

| Área | Sinal de cobertura insuficiente |
|---|---|
| Autenticação/acesso | Nada sobre login, perfis de usuário ou permissões |
| Notificações/comunicação | Nada sobre como o sistema comunica eventos ao usuário |
| Dados/histórico | Nada sobre o que o sistema precisa armazenar ou consultar |
| Integrações externas | Nada sobre APIs, serviços externos ou importação/exportação |
| Administração/configuração | Nada sobre como gestores configuram ou administram o sistema |
| Relatórios/consultas | Nada sobre como usuários consultam o histórico ou geram relatórios |

**Não ativar se:** ≤ 2 áreas com lacunas (o modeler pode inferir ou criar pautas específicas em `pautas-reelicitacao.md`).

---

## ESTRUTURA DE FEIXE

Cada feixe é um lote temático de 3–4 perguntas. Máximo de 2 feixes por execução (1 chamada por feixe, D14).

### Exemplo — Feixe "Acesso e perfis"

```
Algumas perguntas rápidas sobre quem vai usar o sistema:

1. Como cada pessoa vai entrar no produto? 
   (A) Com e-mail e senha  
   (B) Com conta do Google / redes sociais  
   (C) Sem login — qualquer pessoa acessa

2. Existem perfis diferentes de usuário com permissões diferentes?
   (A) Sim — ex: administrador vê mais coisas que o usuário comum
   (B) Não — todo mundo tem acesso igual

3. Se alguém esquecer a senha, como vai recuperar o acesso?
   (A) Por e-mail  
   (B) Por SMS  
   (C) Não precisa — o sistema vai usar login social

4. Existe necessidade de controle de sessão?
   (Ex: deslogar automaticamente após X minutos de inatividade)
   (A) Sim, por segurança  
   (B) Não, pode ficar sempre conectado
```

### Exemplo — Feixe "Histórico e relatórios"

```
Sobre consultas e histórico no produto:

1. Os usuários precisam ver um histórico das ações que fizeram?
   (A) Sim — ex: histórico de compras, histórico de aulas concluídas
   (B) Não é necessário

2. Algum perfil de usuário precisa de relatórios ou resumos?
   (A) Sim — ex: gerente quer ver relatório de vendas, pai quer ver progresso do filho
   (B) Não

3. As informações do histórico precisam ser exportadas?
   (A) Sim — ex: exportar para Excel, PDF
   (B) Não é necessário

4. Por quanto tempo o sistema precisa guardar o histórico?
   (A) Para sempre  
   (B) Por um período específico (ex: 1 ano, 2 anos)  
   (C) Não sei ainda
```

---

## PROCESSO

1. Verificar condição de ativação (≥ 3 áreas sem cobertura)
2. Selecionar as 2 áreas com maior lacuna de cobertura
3. Para cada área selecionada, montar 1 feixe (3–4 perguntas choice/yesno)
4. Invocar `AskUserQuestion` para cada feixe (1 chamada por feixe, máximo 2 chamadas)
5. Registrar respostas em `elicitacao-raw.md`, seção "Detalhamentos Adicionais (questionario-feixe)"

---

## SAÍDA

```markdown
## Detalhamentos Adicionais (questionario-feixe — Fase A)

### Feixe 1 — [Tema]
**P1:** [resposta]
**P2:** [resposta]
**P3:** [resposta]
**P4:** [resposta]

### Feixe 2 — [Tema] (se aplicável)
...
```

---

## REGRAS (D14 + D19)

- Perguntas: apenas choice ou yesno (não text) — respostas estruturadas facilitam classificação pelo modeler
- Máximo 2 feixes / 2 chamadas AskUserQuestion nesta skill
- Proibido mencionar "feixe", "questionário", "domínio" ao usuário — usar "algumas perguntas rápidas sobre [tema]"
- Se condição não atendida: não executar; registrar no log do collector "questionario-feixe: não ativado (< 3 áreas com lacuna)"
