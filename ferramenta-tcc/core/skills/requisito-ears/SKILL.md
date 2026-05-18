---
name: requisito-ears
description: Formata todos os RFs e RNFs de M2 com sintaxe EARS (5 padrões) e modais RFC 2119 (DEVE/DEVERIA/PODE), gerando tabela estruturada com colunas: ID | Tipo-EARS | Sujeito | Modal | Verbo | Objeto | Condição | Modal-original. Base para srs-ireb-template e gherkin-spec.
when_to_use: Invocada pelo documenter como Passo 1 do Processo M3. Entrada obrigatória: 03.1-funcionais.md e 03.2-qualidade.md com campos modal RFC 2119 já atribuídos pela skill priorizacao (M2).
---

# Skill: requisito-ears

**Referências:** `catalogos-seed/conceitos/especificacao-e-modelagem.md` §1 · RFC 2119 (DEVE/DEVERIA/PODE) · EARS (Easy Approach to Requirements Syntax — Mavin et al.)
**Marco:** M3 — Detalhamento (Passo 1)
**Invocada por:** `documenter`

---

## PADRÕES EARS (5 tipos canônicos)

| # | Padrão | Gatilho linguístico | Estrutura |
|---|---|---|---|
| 1 | **Ubíquo** | Sem condição — comportamento sempre ativo | "O sistema [Modal] [verbo] [objeto]" |
| 2 | **Evento** | "Quando [evento ocorrer]" | "Quando [evento], o sistema [Modal] [verbo] [objeto]" |
| 3 | **Estado** | "Enquanto [estado ativo]" | "Enquanto [estado], o sistema [Modal] [verbo] [objeto]" |
| 4 | **Opcional** | "Onde [recurso disponível]" | "Onde [recurso], o sistema [Modal] [verbo] [objeto]" |
| 5 | **Indesejado / Exceção** | "Se [falha ou erro ocorrer]" | "Se [falha/erro], o sistema [Modal] [verbo] [objeto]" |

**Regra de seleção de padrão:** usar o padrão mais específico que a descrição do requisito permite. Ubíquo é o padrão residual — usar apenas quando nenhum dos outros 4 se encaixa.

---

## MODAIS RFC 2119

| Modal | Força normativa | Equivalência EN |
|---|---|---|
| `DEVE` | Obrigatório — sem exceção | MUST |
| `DEVERIA` | Recomendado — exceção justificável | SHOULD |
| `PODE` | Opcional — a critério da implementação | MAY |

O campo modal vem preenchido de `03.1-funcionais.md` e `03.2-qualidade.md` pela skill `priorizacao` (M2). Esta skill **preserva** o modal original — não altera prioridades.

---

## PROCESSO

### Entrada

- `03.1-funcionais.md` — lista de RFs com campo modal preenchido (produzido pelo modeler M2)
- `03.2-qualidade.md` — lista de RNFs com bucket Wiegers + campo modal preenchido (produzido pelo modeler M2)

### Algoritmo de detecção de padrão EARS

Para cada RF em `03.1-funcionais.md`:

1. Ler a descrição textual do requisito
2. Detectar gatilhos linguísticos na seguinte ordem de precedência:
   - Contém "se [erro/falha/timeout/indisponível]" → **Indesejado**
   - Contém "quando [evento]" → **Evento**
   - Contém "enquanto [estado]" → **Estado**
   - Contém "onde [recurso]" ou "se [funcionalidade opcional] disponível" → **Opcional**
   - Nenhum dos anteriores → **Ubíquo**
3. Decompor em slots: Sujeito (sempre "O sistema") | Modal | Verbo | Objeto | Condição (se aplicável)
4. Registrar na tabela de saída

Para cada RNF em `03.2-qualidade.md`:

1. Ler descrição + bucket Wiegers + métrica
2. Formatar como linha na tabela de qualidade com: ID | Bucket | Sujeito | Modal | Comportamento | Métrica
3. Não aplicar padrão EARS estrutural — RNFs seguem formato de qualidade (descrição mensurável direta)

### Sem interação com usuário

Esta skill não faz perguntas ao usuário. Itens com padrão EARS ambíguo ou descrição vaga demais para decomposição são marcados com flag `[VERIFICAR]` na coluna Condição.

---

## SAÍDA

### Tabela de RFs formatados (EARS + RFC 2119)

```markdown
# Requisitos Formatados (EARS + RFC 2119)

## Funcionais

| ID | Tipo-EARS | Sujeito | Modal | Verbo | Objeto | Condição |
|---|---|---|---|---|---|---|
| RF-001 | Ubíquo | O sistema | DEVE | permitir | cadastro de produto | — |
| RF-002 | Evento | O sistema | DEVE | enviar | confirmação por e-mail | Quando um pedido for concluído |
| RF-003 | Indesejado | O sistema | DEVE | exibir | mensagem de erro detalhada | Se o pagamento falhar |
| RF-004 | Estado | O sistema | DEVERIA | bloquear | novas requisições | Enquanto o limite de sessões for atingido |
| RF-005 | Opcional | O sistema | PODE | exportar | relatório em PDF | Onde o módulo de relatórios estiver habilitado |
| RF-006 | Ubíquo | O sistema | DEVE | [descrição vaga — lacuna de elicitação] | [VERIFICAR] | — |

## Qualidade

| ID | Bucket | Sujeito | Modal | Comportamento | Métrica |
|---|---|---|---|---|---|
| RNF-001 | Desempenho | O sistema | DEVE | responder a requisições da interface | em < 2s para 95% das chamadas sob carga nominal |
| RNF-002 | Disponibilidade | O sistema | DEVE | estar disponível | 99,5% do tempo em janela de 30 dias |
| RNF-003 | Segurança | O sistema | DEVE | autenticar usuários | via OAuth 2.0 com token de 24h |
| RNF-004 | Usabilidade | O sistema | DEVERIA | permitir conclusão de tarefa principal | em ≤ 3 cliques por usuário novo |
```

---

## REGRAS

- Não interagir com o usuário — processamento totalmente automatizado
- Preservar todos os IDs de `03.1-funcionais.md` e `03.2-qualidade.md` sem renumerar
- A contagem de RFs e RNFs na saída deve ser idêntica à contagem de entrada (sem omissão silenciosa)
- Itens sem padrão EARS claramente identificável → marcar como `[VERIFICAR]` na coluna Condição (não descartar)
- Sujeito é sempre "O sistema" (conforme EARS canônico)
- Um requisito = uma linha na tabela (não consolidar, não dividir sem marcar)
- Saída desta skill é o input direto para `srs-ireb-template` (Passo 2) e `gherkin-spec` (Passo 3)
