---
name: traducao-gate
description: Gera duas versões de um artefato de gate — versão normativa (IREB §3.3.3 + EARS + RFC 2119) e versão leigo (linguagem de negócio). O usuário aprova apenas a versão leigo; a equipe técnica recebe a versão normativa.
when_to_use: Ao final de cada marco (M1, M2, M3) antes de apresentar artefatos ao usuário para aprovação no gate.
---

# Skill: traducao-gate

**Decisão:** D18 — Versões leigo + normativa por artefato-gate
**Tipo:** Transversal — invocada ao final de cada marco antes do gate
**Depende de:** `traducao-leigo` (aplicada sobre a versão leigo gerada)

---

## ENTRADA

- Artefato normativo já gerado (ex: `visao-produto.md`, `03.1-funcionais.md`, `SRS-completo.md`)
- Nome do arquivo alvo (ex: `visao-produto`)
- Marco atual (M1, M2 ou M3)

---

## PROCESSO

### 1. Verificar artefato normativo

Confirmar que o artefato normativo de entrada está completo e bem formado segundo o padrão esperado para o marco.

### 2. Gerar versão normativa final

Aplicar formatação IREB §3.3.3 + EARS + slots RFC 2119 se ainda não aplicados:
- Requisitos funcionais: `[Sujeito] DEVE [verbo] [objeto] [condição opcional]`
- Requisitos não-funcionais: `[Sistema] DEVE [critério mensurável] quando [condição]`
- Seções seguindo estrutura IREB §3.3.3

Salvar como `<nome>-normativo.md`.

### 3. Gerar versão leigo

Transformar o conteúdo normativo em linguagem de negócio:

**Regras de transformação:**
- Remover toda sintaxe EARS/RFC 2119 (DEVE/DEVERIA/PODE → linguagem natural)
- Substituir termos técnicos de ER (ver blacklist `traducao-leigo`)
- Usar frases curtas e ativas
- Agrupar por tema compreensível ao dono de negócio (não por categoria técnica)
- Converter listas técnicas em linguagem narrativa quando necessário
- Incluir exemplos concretos quando o conceito for abstrato

**Por marco:**

| Marco | Versão normativa contém | Versão leigo apresenta |
|---|---|---|
| M1 | Vision Box + Situação-Problema + Stakeholders + Contexto/Limite em formato IREB | Resumo em prosa: "Seu projeto é X, resolve Y, as pessoas envolvidas são Z..." |
| M2 | Listas RF/RNF com EARS + MoSCoW + glossário técnico | Listas em linguagem de negócio: "O produto vai fazer... / O produto precisa funcionar..." |
| M3 | SRS completo IREB §3.3.3 com 6 seções | Resumo executivo com destaques por seção, sem siglas ou sintaxe |

### 4. Aplicar traducao-leigo

Passar a versão leigo gerada pela skill `traducao-leigo` para garantia final de ausência de jargão.

### 5. Salvar arquivos

Salvar ambas as versões no diretório do projeto:
- `<nome>-normativo.md` — versão técnica
- `<nome>-leigo.md` — versão para aprovação do usuário

---

## SAÍDA

Dois arquivos:
1. **`<nome>-normativo.md`** — pronto para equipe técnica
2. **`<nome>-leigo.md`** — pronto para apresentar ao usuário no gate

---

## EXEMPLO (M1)

**Entrada normativa (trecho):**
```markdown
## 2. Situação-Problema

| Slot | Conteúdo |
|---|---|
| O problema de | processo manual de agendamento gera conflitos de horário |
| Afeta | clientes e recepcionistas da clínica |
| Cujo impacto é | perda de consultas, insatisfação e retrabalho administrativo |
| Uma solução bem-sucedida seria | sistema de agendamento online com controle de disponibilidade em tempo real |
```

**Saída versão leigo (trecho):**
```markdown
## O problema que seu projeto resolve

Hoje, o agendamento é feito manualmente e isso causa confusão nos horários.
Isso afeta diretamente seus clientes e a equipe que cuida da agenda.
O resultado: consultas perdidas, pessoas insatisfeitas e muito retrabalho.

Seu projeto resolve isso com um sistema online onde os clientes marcam
horários disponíveis em tempo real, sem risco de conflito.
```
