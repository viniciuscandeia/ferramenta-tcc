---
name: stakeholder-mapping
description: >-
  Identifica e mapeia todas as pessoas envolvidas no projeto — quem usa, quem decide, quem é afetado.
  Use após documentar o problema, quando é preciso saber quem tem interesse no produto.
  Map stakeholders for a layperson project; produces a roles table with type of involvement.
---

## Filosofia desta skill (Regras Absolutas)

1. **Extrair antes de perguntar** — sempre ler skills anteriores e pré-popular a tabela com pessoas já mencionadas. Nunca repetir pergunta sobre quem já foi nomeado.
2. **Decisor explícito é obrigatório** — sem decisor identificado, o Gate 1 não pode ser aprovado. Se o usuário não souber, registrar como "a identificar" e marcar como pendência aberta.
3. **Afetado indireto é frequentemente omitido** — sondar proativamente: clientes dos clientes, equipes de suporte, parceiros externos. O usuário raramente os menciona sem estímulo.

<HARD-GATE>
- NÃO executar antes de `situacao-problema` concluído (verificar que `## Situação-Problema` existe em `visao-produto.md`)
- ⛔ STOP se pré-processamento extrai 0 pessoas das skills anteriores (indica que M1 está corrompido ou vazio) — registrar em `_pendencias.md`
</HARD-GATE>

## Fase 0 — Inicialização e Pré-Processamento

1. Carregar `core/constitution.md` (guardrail D1 + Output Discipline)
2. Verificar pré-condição: `## Situação-Problema` deve existir em `visao-produto.md`
3. **Pré-processamento:** extrair pessoas já mencionadas em Vision Box (público-alvo) e Situação-Problema (usuários, afetados). Usá-las como ponto de partida — não repetir nas perguntas.

## Fase 1 — Coleta

**Lote único (≤ 4 perguntas), personalizando com pessoas já extraídas:**

1. **Usuários diretos** (text):
   ```
   Além de [pessoas mencionadas antes], quem mais vai usar o produto no dia a dia?
   ```
   *(Se ninguém foi mencionado antes: "Quem vai usar o produto no dia a dia?")*

2. **Decisores** (text):
   ```
   Quem precisa aprovar ou pagar pelo produto? Pode ser uma pessoa, um cargo ou um departamento.
   ```

3. **Afetados indiretamente** (text):
   ```
   Tem alguém que vai ser afetado pelo produto, mesmo sem usá-lo diretamente? (ex: equipe de suporte, clientes dos seus clientes)
   ```

4. **Quem não deve ter acesso** (text):
   ```
   Tem algum grupo de pessoas que NÃO deve ter acesso ou não deve ser impactado pelo produto?
   ```

## Fase 2 — Síntese

Montar tabela de pessoas envolvidas, fazendo merge dos extraídos no pré-processamento com as respostas do Lote 1:

```markdown
## Pessoas Envolvidas

| Papel | Descrição | Tipo de envolvimento | Necessidade principal |
|---|---|---|---|
| [Nome do papel] | [Quem é] | Usuário direto / Decisor / Afetado / Restrito | [O que precisa do projeto] |
```

**Tipos de envolvimento:**
- **Usuário direto** — usa o produto ativamente
- **Decisor** — aprova, financia ou define prioridades
- **Afetado** — impactado pelos resultados, mas não usa diretamente
- **Restrito** — não deve ter acesso

**Regras de síntese:**

- Cada grupo mencionado (pré-processamento + Lote 1) vira uma linha na tabela
- Inferir "necessidade principal" com base no contexto — marcar como `[inferido]` se incerto
- Se usuário não souber responder: registrar papel como "a identificar" na tabela e adicionar à `pautas_abertas` em `estado-projeto.yaml`
- Verificar consistência com Vision Box (público-alvo) e Situação-Problema (usuários principais)
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

## Fase 3 — Saída

1. Append seção `## Pessoas Envolvidas` em `visao-produto.md`
2. Atualizar `estado-projeto.yaml` — se houver "a identificar": adicionar à lista `pautas_abertas`
3. Sinalizar ao `stakeholder-identifier`: mapeamento concluído → prosseguir para `contexto-e-limite`

<!-- internal -->
## Anti-Padrão: Pré-Processamento Perde Pessoa de Texto Longo

**Como acontece:** Em inputs ricos como o Caso 2 M1 (texto longo da médica), o pré-processamento lê só o Vision Box e perde pessoas mencionadas na narrativa longa de Situação-Problema (ex: "plano de saúde" mencionado como exigência regulatória no corpo do texto).

**Como detectar:** Checar se cada pessoa/entidade nomeada em `## Situação-Problema` aparece como linha na tabela final. Varredura simples: tokenizar nomes próprios e substantivos de papel (médico, recepcionista, plano, fornecedor) e cruzar com a tabela.

**O que fazer:** Fail-safe — adicionar qualquer pessoa/entidade não capturada como linha extra com papel `[a confirmar]`. Melhor uma linha a mais para revisar do que uma omissão silenciosa.
<!-- /internal -->
