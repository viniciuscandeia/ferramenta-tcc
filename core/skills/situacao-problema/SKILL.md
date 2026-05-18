---
name: situacao-problema
description: Documenta a situação-problema usando tabela estruturada com 6 slots — problema, impactados, impacto, solução esperada, usuários principais e funcionalidades-chave. Produz segundo componente de visao-produto.md.
when_to_use: Segunda skill do Marco 1, após vision-box. Sempre executada antes de stakeholder-mapping.
---

# Skill: situacao-problema

**Referência:** Material Dani `ers-apoio-projeto-situacao-problema.md`
**Marco:** M1 — Definição da Necessidade
**Ordem no workflow:** 2ª skill

---

## OBJETIVO

Documentar o problema que o produto resolve com precisão suficiente para guiar toda a elicitação posterior. A tabela de situação-problema é a âncora do projeto — tudo que será levantado nas fases seguintes deve conectar a esta declaração.

---

## PERGUNTAS AO USUÁRIO

Batching: coletar em 2 lotes de ≤ 4 perguntas.

**Lote 1 — O problema (4 perguntas):**

1. **O problema** (text):
   ```
   O que exatamente está errado hoje? Descreva a dificuldade que seu produto vai resolver.
   ```

2. **Quem sofre o problema** (text):
   ```
   Quem sofre mais com essa dificuldade? Pode ser um tipo de pessoa, uma equipe, um grupo.
   ```

3. **Impacto do problema** (text):
   ```
   O que acontece por causa desse problema? Quais são as consequências ruins de não resolvê-lo?
   ```

4. **Solução esperada** (text):
   ```
   Qual seria a solução ideal? Não precisa ser técnico — só descreva o que você espera que o produto faça.
   ```

**Lote 2 — Usuários e funcionalidades (2 perguntas):**

5. **Usuários principais** (text):
   ```
   Quem vai usar o produto no dia a dia? Liste os tipos de pessoas (ex: cliente, gerente, atendente).
   ```

6. **O que o produto precisa fazer** (text):
   ```
   Cite as 3 ou 4 coisas mais importantes que o produto precisa fazer para resolver o problema.
   ```

---

## PROCESSAMENTO

Com as respostas, gerar a tabela de situação-problema:

### Estrutura da tabela (versão normativa)

```markdown
## Situação-Problema

| Slot | Conteúdo |
|---|---|
| O problema de | [resposta 1] |
| Afeta | [resposta 2] |
| Cujo impacto é | [resposta 3] |
| Uma solução bem-sucedida seria | [resposta 4] |
| Os usuários principais são | [resposta 5] |
| As principais funcionalidades são | [resposta 6 — lista com bullet] |
```

### Regras de geração

- Se o usuário deixou algum slot vazio ou vago: inferir com base nas outras respostas e sinalizar como "[inferido]" na versão normativa para revisão posterior
- Funcionalidades: converter resposta 6 em lista de bullet points concisos
- Verificar alinhamento com Vision Box: os usuários da situação-problema devem coincidir com o público-alvo da Vision Box
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário

---

## SAÍDA

Seção "## Situação-Problema" para compor `visao-produto.md`.

Sinalizar ao `stakeholder-identifier` que situação-problema concluída → prosseguir para `stakeholder-mapping`.
