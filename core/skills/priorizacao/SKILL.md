---
name: priorizacao
description: Atribui modal RFC 2119 (DEVE/DEVERIA/PODE) e campo de prioridade de negócio a cada RF e RNF classificado. Usa MoSCoW como base obrigatória; aciona Kano e IEEE como sub-rotinas automáticas conforme gatilhos (D9). Usuário nunca vê os nomes das técnicas.
when_to_use: Invocada pelo modeler no Passo 2 da Fase B após classificacao-rf-rnf. Entrada: rascunhos de 03.1-funcionais.md e 03.2-qualidade.md.
---

# Skill: priorizacao

**Decisão:** D9 — MoSCoW MVP + Kano + IEEE como sub-rotinas  
**Referências:** Wiegers Software Requirements · IEEE 830 · Kano Model · RFC 2119
**Marco:** M2 — Consenso de Escopo (Fase B, Passo 2)
**Invocada por:** `modeler`

---

## MAPEAMENTO DE SAÍDA (único para todas as sub-rotinas)

| Valor interno (modeler) | Apresentado ao usuário | Modal RFC 2119 |
|---|---|---|
| `DEVE_TER` | "vem primeiro / é essencial" | `DEVE` |
| `DEVERIA_TER` | "vem logo depois / importante mas não crítico" | `DEVERIA` |
| `PODERIA_TER` | "fica para depois / bom ter se der" | `PODE` |
| `NAO_TERA` | "fica fora desta versão" | (sem modal — fora do escopo) |

---

## SUB-ROTINA 1 — MoSCoW (SEMPRE EXECUTAR)

### Critério de prioridade

Para cada RF/RNF:

- **DEVE_TER (DEVE):** Item sem o qual o produto não pode funcionar ou viola uma restrição legal. Critério: "Se removermos este item, o produto falha ou é ilegal?"
- **DEVERIA_TER (DEVERIA):** Item importante que tem alternativa temporária. Critério: "Se removermos este item agora, o produto funciona com limitação aceitável?"
- **PODERIA_TER (PODE):** Item desejável mas postergável sem impacto na usabilidade mínima. Critério: "O produto funciona normalmente sem este item?"
- **NAO_TERA:** Item reconhecidamente fora do escopo desta versão (registrar para versões futuras)

### Âncoras de referência

Ao atribuir MoSCoW, verificar consistência com:
- Restrições de `03.3-restricoes.md`: toda restrição legal/regulatória implica `DEVE` nos RFs que a implementam
- Funcionalidades-chave de `visao-produto-normativo.md`: geralmente são `DEVE_TER`
- Items surgidos apenas de catálogo (recomendacao-implicitos): geralmente começam como `PODERIA_TER`

---

## SUB-ROTINA 2 — Kano (CONDICIONAL — D-S4.2)

### Gatilho de ativação

Ativar **automaticamente** se e somente se:
- RFs com `DEVERIA_TER` ou `PODERIA_TER` ≥ 8, **E**
- Stakeholders distintos identificados em M1 ≥ 2

### O que o Kano adiciona

Reordena os itens `DEVERIA_TER`/`PODERIA_TER` com base em 3 categorias:

| Categoria Kano | Lógica | Impacto na prioridade |
|---|---|---|
| **Obrigatório** (must-be) | Se ausente, usuário fica insatisfeito; se presente, não gera satisfação extra | Promover para `DEVE_TER` se não estava |
| **Proporcional** (one-dimensional) | Quanto mais, melhor — satisfação proporcional à presença | Manter posição atual |
| **Encantador** (attractive) | Surpreende positivamente quando presente; não causa insatisfação se ausente | Reclassificar para `PODERIA_TER` se estava como `DEVERIA_TER` |

### Processo simplificado (sem perguntar ao usuário sobre Kano)

Para cada item `DEVERIA_TER`/`PODERIA_TER`:
1. Verificar: "Se o sistema **não tiver** este item, o usuário vai reclamar ativamente?"
   - SIM → categoria Obrigatório → promover para `DEVE_TER`
2. Verificar: "Este item **surpreende positivamente** o usuário quando presente?"
   - SIM → categoria Encantador → reclassificar como `PODERIA_TER` (encantamento é bônus, não obrigação)
3. Caso contrário → categoria Proporcional → manter posição atual

---

## SUB-ROTINA 3 — IEEE (CONDICIONAL — D-S4.2)

### Gatilho de ativação

Ativar **automaticamente** se e somente se:
- Total de RFs + RNFs ≥ 25, **E**
- `03.3-restricoes.md` contém restrição de prazo fixo (data limite explícita)

### O que o IEEE adiciona

Ordena os `DEVE_TER` em sequência de implementação com base em:

| Critério | Peso |
|---|---|
| Estabilidade (quão improvável de mudar) | Alta → implementar primeiro |
| Dependência (outros RFs dependem deste?) | Muitas dependências → implementar primeiro |
| Risco (quão incerto é implementar?) | Alto risco → implementar primeiro (fail fast) |

### Saída do IEEE

Adicionar campo `ordem_impl: N` aos RFs `DEVE_TER` (1 = primeiro a implementar).

---

## PROCESSO UNIFICADO

### Entrada

- `03.1-funcionais.md` rascunho (do Passo 1)
- `03.2-qualidade.md` rascunho (do Passo 1)
- `visao-produto-normativo.md` (funcionalidades-chave + stakeholders)
- `03.3-restricoes.md` rascunho (para verificar gatilho IEEE)

### Execução

1. Aplicar MoSCoW a todos os itens
2. Verificar gatilhos de Kano e IEEE — ativar sub-rotinas se condições atendidas
3. Aplicar sub-rotinas ativas e ajustar campos de prioridade
4. Atualizar `03.1-funcionais.md` e `03.2-qualidade.md` com campos preenchidos
5. Sem interação com usuário

### Sem perguntas ao usuário

Esta skill opera inteiramente com base nas respostas já coletadas. Nenhuma pergunta sobre "o que é mais importante" é feita diretamente ao usuário — o modeler infere a partir do contexto de negócio e das restrições declaradas.

---

## SAÍDA

### 03.1-funcionais.md (atualizado)

```markdown
| ID | Descrição | Modal | MoSCoW | Kano | ordem_impl | Fonte |
|---|---|---|---|---|---|---|
| RF-001 | O sistema DEVE permitir que o usuário cadastre um produto com nome, preço e foto | DEVE | DEVE_TER | — | 1 | cenario-narrativa §2 |
| RF-002 | O sistema DEVERIA enviar confirmação por e-mail após pedido | DEVERIA | DEVERIA_TER | Proporcional | — | recomendacao-implicitos |
| RF-003 | O sistema PODE exibir sugestões de produtos relacionados | PODE | PODERIA_TER | Encantador | — | recomendacao-dominio |
```

### 03.2-qualidade.md (atualizado)

```markdown
| ID | Bucket | Descrição | Métrica | Modal | MoSCoW | Fonte |
|---|---|---|---|---|---|---|
| RNF-001 | Desempenho | O sistema DEVE responder a buscas de produtos em menos de 2 segundos para 95% das requisições | < 2s / P95 | DEVE | DEVE_TER | entrevista-estruturada |
```

---

## REGRAS DE QUALIDADE

- RNFs classificados como `DEVE_TER` sem métrica → criar pauta para `pautas-reelicitacao` (lacuna crítica)
- Todo item com modal `DEVE` precisa ter critério de aceitação claro (senão → pauta)
- Items `NAO_TERA` não entram nos artefatos — registrar em seção separada "Fora do escopo desta versão" no final de `03.1-funcionais.md`
- Não usar os termos "MoSCoW", "Kano", "IEEE", "prioridade" em qualquer saída apresentada ao usuário
