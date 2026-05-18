# Casos de Teste — Marco 2: Consenso de Escopo

Três casos canônicos para verificação do workflow M2 (`collector` ⇄ `modeler`).
Cada caso pressupõe artefato M1 já aprovado (`visao-produto-normativo.md` simulado).

---

## Caso 1 — E-commerce Pequeno

**Descritor:** `caso-1-ecommerce`
**Domínio detectado:** `ecommerce`
**Complexidade:** baixa (caminho linear — Fase A sem loop B)

### Visão do produto (input simulado M1)

```
Produto: Loja Artesanal Online
Público-alvo: Artesãos que querem vender seus produtos pela internet
Problema: Artesãos perdem vendas por não ter presença online organizada
Solução: Loja virtual simples onde o artesão cadastra produtos e recebe pedidos
Funcionalidades-chave: cadastro de produtos, carrinho de compras, pagamento online
Restrições: orçamento pequeno; precisar cumprir LGPD; funcionar em celular
```

### Comportamento esperado — Fase A (collector)

1. `entrevista-estruturada`: 1 lote de 4 perguntas sobre rotina, frustrações, ideal e restrições
2. `cenario-narrativa`: 1 cenário "um dia de vendas do artesão" extraído
3. `recomendacao-dominio`: domínio `ecommerce` confirmado; 4 perguntas sobre carrinho, pagamento, LGPD, notificações
4. `recomendacao-implicitos`: 5–8 RFs/RNFs candidatos confirmados (ex: cálculo de frete, confirmação por e-mail, backup)
5. `questionario-feixe`: **não ativado** (áreas suficientemente detalhadas após lotes anteriores)

### Comportamento esperado — Fase B (modeler)

1. `classificacao-rf-rnf`: ≥ 8 RFs classificados (mix DEVE/DEVERIA/PODE), ≥ 3 RNFs mensuráveis
2. `priorizacao`: MoSCoW ativo; Kano **não ativado** (Should < 8); IEEE **não ativado** (total < 25)
3. `glossario`: ≥ 5 termos extraídos (artesão, pedido, catálogo, carrinho, LGPD)
4. `conflitos-detect`: 0 conflitos (sem stakeholders contraditórios) — `conflitos-detectados.md` **não gerado**
5. `pautas-reelicitacao`: **vazio** → Gate 2 pode abrir diretamente

### Artefatos esperados ao final

| Arquivo | Obrigatório? | Esperado? |
|---|---|---|
| `elicitacao-raw.md` | Sim (interno) | Sim |
| `03.1-funcionais.md` | Sim | Sim |
| `03.1-funcionais-leigo.md` | Sim | Sim |
| `03.2-qualidade.md` | Sim | Sim |
| `03.2-qualidade-leigo.md` | Sim | Sim |
| `03.3-restricoes.md` | Sim | Sim (LGPD + mobile) |
| `03.3-restricoes-leigo.md` | Sim | Sim |
| `03.4-premissas.md` | Condicional | Não esperado |
| `glossario.md` | Sim | Sim |
| `pautas-reelicitacao.md` | Sim | Sim (vazio) |
| `conflitos-detectados.md` | Condicional | Não esperado |

---

## Caso 2 — App Educação Infantil

**Descritor:** `caso-2-educacao`
**Domínio detectado:** `educacao`
**Complexidade:** média (múltiplos stakeholders, LGPD menores, acessibilidade)

### Visão do produto (input simulado M1)

```
Produto: AprenderBrincando
Público-alvo: Crianças de 4 a 8 anos e seus pais
Problema: Crianças pequenas têm dificuldade para aprender letras e números de forma engajante
Solução: App com jogos educativos para pré-escola com acompanhamento dos pais
Funcionalidades-chave: jogos de letras, jogos de números, relatório para pais, controle parental
Stakeholders: criança (usuário direto), pai/mãe (decisor e afetado), educador (afetado)
Restrições: criança não lê (interface só visual/áudio); LGPD para menores (arts. 14-15); acessibilidade
```

### Comportamento esperado — Fase A (collector)

1. `entrevista-estruturada`: 1 lote 4 perguntas (rotina com app, frustrações atuais, ideal para pais e crianças, restrições de tempo de tela)
2. `cenario-narrativa`: 1 cenário "uma criança usando o app com o pai" + 1 cenário "pai revisando relatório"
3. `recomendacao-dominio`: domínio `educacao` confirmado; perguntas sobre progressão de nível, gamificação, relatórios
4. `recomendacao-implicitos`: 6–10 RFs/RNFs candidatos (acessibilidade WCAG, modo offline, controle de tempo de tela, backup de progresso)
5. `questionario-feixe`: **condicional** — ativar se ≥ 3 áreas com lacunas após lotes anteriores

### Comportamento esperado — Fase B (modeler)

1. `classificacao-rf-rnf`: ≥ 10 RFs; ≥ 4 RNFs (desempenho em tablet básico, acessibilidade visual/áudio, LGPD, privacidade menores)
2. `priorizacao`: MoSCoW ativo; Kano **ativado** se RFs Should/Could ≥ 8; IEEE **não ativado**
3. `glossario`: ≥ 8 termos (controle parental, progressão de nível, modo de jogo, relatório, LGPD, menores de idade)
4. `conflitos-detect`: possível conflito criança (quer mais jogos) vs. pai (quer limitar tempo) — registrar em `conflitos-detectados.md`
5. `pautas-reelicitacao`: **pode ter 1–2 pautas** (ex: métrica de acessibilidade, detalhe LGPD para menores)

### Critério de aceitação do Gate 2 (Caso 2)

- Se `pautas-reelicitacao.md` não-vazio: loop B deve resolver pautas antes de abrir Gate 2
- `conflitos-detectados.md` deve existir com conflito stakeholder registrado
- Versões leigo sem termos "LGPD" nu (deve aparecer como "proteção de dados de crianças")

---

## Caso 3 — Loop de Reelicitação (teste do loop B) ⚠️ CORTÁVEL

**Descritor:** `caso-3-loop-reelicitacao`
**Complexidade:** alta (testa Fase B com pauta não-vazia → collector focado → modeler resolve pauta)
**Status:** **Cortável** conforme D-S4.8 — adiar se Casos 1 e 2 cobrirem o caminho linear.

### Cenário

Input M1 simulado: sistema de agendamento de salão de beleza.
Após Fase A, modeler detecta:
- RF "o sistema DEVE enviar lembrete" sem critério de aceitação claro (quando? por qual canal?)
- RNF "o sistema DEVE ser rápido" sem métrica (rápido = < X segundos?)

### Pautas geradas (simuladas)

```markdown
- [ ] Detalhar canal e timing do lembrete de agendamento (collector: entrevista-estruturada focada)
- [ ] Definir métrica de desempenho para "rápido" (collector: entrevista-estruturada — pergunta direta)
```

### Comportamento esperado

1. `pautas-reelicitacao.md` não-vazio → Gate 2 **bloqueado**
2. Orquestrador retorna ao `collector` em modo Fase B com as pautas
3. `collector` executa `entrevista-estruturada` com 2 perguntas focadas nas pautas
4. `modeler` reprocessa: atualiza `03.1-funcionais.md` e `03.2-qualidade.md` com critérios
5. `pautas-reelicitacao.md` **zerado** → Gate 2 **abre**

### Critério de aceitação

- `pautas-reelicitacao.md` final com todos os itens `[x]` (ou arquivo vazio)
- RF de lembrete agora tem critério: canal (SMS ou e-mail), timing (24h antes)
- RNF de desempenho agora tem métrica: tempo de resposta < 2s para 95% das requisições
- Loop encerrou em ≤ 2 iterações (mínimo suficiente para este caso)
