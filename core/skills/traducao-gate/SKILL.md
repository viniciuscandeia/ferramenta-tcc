---
name: traducao-gate
marco: [M1, M2, M3]
description: Gera duas versões de um artefato de gate — versão normativa (IREB §3.3.3 + EARS + RFC 2119) e versão leigo (linguagem de negócio). O usuário aprova apenas a versão leigo; a equipe técnica recebe a versão normativa.
when_to_use: Ao final de cada marco (M1, M2, M3) antes de apresentar artefatos ao usuário para aprovação no gate.
---

## Filosofia desta skill (Regras Absolutas)

1. **2 versões são obrigatórias, sem exceção.** Normativa e leigo são arquivos distintos. Uma não substitui a outra — o usuário aprova a leigo; a equipe técnica usa a normativa.
2. **Versão leigo ≠ versão normativa com palavras substituídas.** Transformação real: sem EARS, sem RFC 2119, sem siglas, reagrupada por tema de negócio, em prosa narrativa. Se a estrutura de seções é a mesma, a transformação falhou.
3. **`traducao-leigo` é etapa obrigatória na Fase 3** — não pular mesmo que a versão leigo pareça limpa. Verificação pós-geração é inegociável.

<HARD-GATE>
- NÃO executar sem artefato normativo completo de entrada
- NÃO executar se artefato normativo não passou pelo validador do marco correspondente
- ⛔ STOP se versão leigo ainda contém termos da blacklist D1 após aplicar `traducao-leigo` — corrigir antes de exibir
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar artefato normativo de entrada está completo e bem formado para o marco
3. Confirmar nome do arquivo alvo e marco atual (M1, M2 ou M3)

## Fase 1 — Gerar Versão Normativa Final

Aplicar formatação IREB §3.3.3 + EARS + RFC 2119 se ainda não aplicados:
- Requisitos funcionais: `[Sujeito] DEVE [verbo] [objeto] [condição opcional]`
- Requisitos não-funcionais: `[Sistema] DEVE [critério mensurável] quando [condição]`
- Seções seguindo estrutura IREB §3.3.3

Salvar como `<nome>-normativo.md`.

## Fase 2 — Gerar Versão Leigo

Transformar conteúdo normativo em linguagem de negócio. A versão leigo tem estrutura diferente da normativa:

| Marco | Versão normativa contém | Versão leigo apresenta |
|---|---|---|
| M1 | Vision Box + Situação-Problema + Stakeholders + Contexto/Limite em formato IREB | Resumo em prosa: "Seu projeto é X, resolve Y, as pessoas envolvidas são Z..." |
| M2 | Listas RF/RNF com EARS + MoSCoW + glossário técnico | Listas em linguagem de negócio: "O produto vai fazer... / O produto precisa funcionar..." |
| M3 | SRS completo IREB §3.3.3 com 6 seções | Resumo executivo com destaques por seção, sem siglas ou sintaxe |

**Regras de transformação:**
- Remover toda sintaxe EARS/RFC 2119 (DEVE/DEVERIA/PODE → linguagem natural)
- Substituir termos técnicos de ER (ver blacklist de `traducao-leigo`)
- Usar frases curtas e ativas
- Agrupar por tema compreensível ao dono de negócio (não por categoria técnica)
- Converter listas técnicas em linguagem narrativa quando necessário
- Incluir exemplos concretos quando o conceito for abstrato

**Exemplo de transformação (M1):**

Entrada normativa:
```markdown
## 2. Situação-Problema

| Slot | Conteúdo |
|---|---|
| O problema de | processo manual de agendamento gera conflitos de horário |
| Afeta | clientes e recepcionistas da clínica |
| Cujo impacto é | perda de consultas, insatisfação e retrabalho administrativo |
| Uma solução bem-sucedida seria | sistema de agendamento online com controle de disponibilidade em tempo real |
```

Saída versão leigo:
```markdown
## O problema que seu projeto resolve

Hoje, o agendamento é feito manualmente e isso causa confusão nos horários.
Isso afeta diretamente seus clientes e a equipe que cuida da agenda.
O resultado: consultas perdidas, pessoas insatisfeitas e muito retrabalho.

Seu projeto resolve isso com um sistema online onde os clientes marcam
horários disponíveis em tempo real, sem risco de conflito.
```

## Fase 3 — Aplicar traducao-leigo

Passar a versão leigo gerada pela skill `traducao-leigo`:
- Verificação final de blacklist D1
- Strip de quaisquer blocos `<!-- internal -->` que tenham vazado
- Corrigir antes de salvar se termos proibidos ainda presentes

## Fase 4 — Saída

Salvar ambas as versões no subdiretório do marco correspondente:

| Marco | Arquivo normativo | Arquivo leigo |
|---|---|---|
| M1 | `documentos-tecnicos/01-visao/01-visao-produto.md` | `documentos-para-leigo/01-visao/01-visao-produto.md` |
| M2 | `documentos-tecnicos/02-requisitos/<nome>.md` | `documentos-para-leigo/02-requisitos/<nome>.md` |
| M3 | `documentos-tecnicos/03-documento/03-srs-completo.md` | `documentos-para-leigo/03-documento/03-documento-do-projeto.md` |

- Versão normativa — pronto para equipe técnica
- Versão leigo — pronto para apresentar ao usuário no gate

Sinalizar ao orquestrador: traducao-gate concluída → apresentar versão leigo ao usuário para aprovação.

<!-- internal -->
## Anti-Padrão: Versão Leigo = Versão Normativa Parafraseada

**Como acontece:** Skill substitui apenas os termos da blacklist na versão normativa e salva como versão leigo. Resultado: listas técnicas, seções IREB §3.3.3, estrutura EARS — tudo presente, só os termos substituídos. O usuário recebe um documento com aparência técnica em linguagem de negócio.

**Como detectar:** Versão leigo com o mesmo número de seções e mesma estrutura hierárquica da versão normativa.

**O que fazer:** Fase 2 exige reagrupamento real por tema de negócio — não só substituição de termos. A versão leigo deve parecer um resumo executivo escrito para o dono do negócio, não um documento técnico com palavras diferentes. Se a estrutura de seções é idêntica à normativa, refazer a Fase 2.
<!-- /internal -->
