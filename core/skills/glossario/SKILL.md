---
name: glossario
description: Detecta termos do domínio usados pelo usuário sem definição clara e constrói glossario.md com definição, exemplos e sinônimos. Previne ambiguidade nos artefatos M2 e M3. Referência: Wiegers Ch11 (anti-ambiguidade).
when_to_use: Invocada pelo modeler no Passo 3 da Fase B. Entrada: elicitacao-raw.md + rascunhos M2. Sem interação com usuário — opera sobre texto já coletado.
---

# Skill: glossario

**Referência:** Wiegers Software Requirements Ch11 (ambiguidade e glossário)
**Marco:** M2 — Consenso de Escopo (Fase B, Passo 3)
**Invocada por:** `modeler`

---

## OBJETIVO

Construir `glossario.md` com todos os termos do domínio que:
1. Aparecem ≥ 2 vezes nos artefatos M2 (sinal de importância)
2. Têm definição ambígua ou implícita (risco de interpretação divergente)
3. São acrônimos, termos técnicos do negócio, ou palavras com múltiplos sentidos no domínio

O glossário é insumo direto da Seção 5 do SRS IREB §3.3.3 — o `documenter` consome `glossario.md` em M3.

---

## HEURÍSTICA DE DETECÇÃO

### Termos candidatos ao glossário

Incluir termos que atendam ≥ 1 dos critérios:

| Critério | Exemplos de termos típicos |
|---|---|
| Substantivo do domínio com freq ≥ 2 | "pedido", "catálogo", "sessão", "perfil", "relatório" |
| Acrônimo não-expandido | "SKU", "LGPD", "CPF", "API", "SLA" |
| Termo com múltiplos sentidos no contexto | "cliente" (quem compra? quem contratou o software?), "usuário" (admin ou consumidor?) |
| Termo técnico do negócio sem equivalente óbvio | "frete grátis a partir de X", "controle parental", "nível de progressão" |
| Termo que gerou pergunta de clarificação | qualquer item que precise de `clarificacao-pos-visao` ou pauta |

### Exclusão

Não incluir no glossário:
- Termos do português corrente sem ambiguidade no contexto (ex: "nome", "senha", "botão")
- Termos da blacklist D1 (esses não aparecem ao usuário de qualquer forma)
- Termos de ER que o modeler usa internamente mas nunca expõe ao usuário

---

## PROCESSO

### Entrada

- `elicitacao-raw.md`
- `03.1-funcionais.md` rascunho
- `03.2-qualidade.md` rascunho
- `visao-produto-normativo.md`

### Algoritmo

1. Concatenar todos os textos de entrada (exceto seções de metadados/cabeçalho)
2. Extrair todos os substantivos e substantivos compostos
3. Contar frequência de cada termo
4. Para termos com freq ≥ 2: verificar se têm definição explícita nos artefatos
   - Se não têm: candidatos ao glossário
5. Para termos com freq < 2: verificar se atendem aos outros critérios (acrônimo, ambiguidade, domínio)
6. Montar `glossario.md` com os termos candidatos + definições inferidas do contexto
7. Se um termo é central mas a definição é incerta: marcar com `[DEFINIÇÃO INCERTA]` para criar pauta em `pautas-reelicitacao`

### Sem interação com usuário

O glossário é construído automaticamente a partir dos textos coletados. Não perguntar ao usuário sobre termos do glossário (isso geraria jargão técnico desnecessário).

---

## SAÍDA

### glossario.md

```markdown
# Glossário do Projeto

> Termos específicos do domínio usados neste projeto.

---

**[Termo]**
Definição: [explicação em linguagem de negócio, sem jargão técnico]
Exemplos: [1–2 exemplos concretos do contexto do projeto]
Sinônimos usados no projeto: [outros termos usados para a mesma coisa, se houver]

---

**[Próximo termo]**
...
```

### Exemplo preenchido

```markdown
# Glossário do Projeto

**Pedido**
Definição: Solicitação formal de compra feita por um cliente após escolher produtos no carrinho. Um pedido tem número único, data, lista de itens, valor total e status (aguardando, em preparo, enviado, entregue).
Exemplos: "Pedido #1042 — 3 itens — R$ 89,90 — status: enviado"
Sinônimos usados no projeto: "compra" (nas respostas do usuário), "solicitação" (no e-mail de confirmação)

---

**LGPD**
Definição: Lei Geral de Proteção de Dados (Lei 13.709/2018). Regula como dados pessoais de usuários brasileiros devem ser coletados, armazenados e usados. Implica: consentimento explícito, direito de exclusão e política de privacidade.
Exemplos: "O usuário deve poder solicitar exclusão de sua conta e dados associados."
Sinônimos usados no projeto: "proteção de dados", "lei de dados" (nas respostas do usuário)
```

---

## REGRAS DE QUALIDADE

- Mínimo de 5 termos para projetos de qualquer domínio (se menos → revisar critérios e incluir termos óbvios do contexto)
- Cada termo tem obrigatoriamente: Definição + Exemplos + Sinônimos (campo pode ser "nenhum" se aplicável)
- Termos marcados `[DEFINIÇÃO INCERTA]` devem gerar entrada em `pautas-reelicitacao.md`
- Glossário usa uma única versão (linguagem natural) — D18 não se aplica (não tem versão normativa separada)
- Acrônimos: expandir completamente na primeira entrada; formato "SIGLA — Forma expandida"
