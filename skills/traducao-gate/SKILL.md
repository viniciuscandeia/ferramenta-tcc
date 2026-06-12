---
name: traducao-gate
marco: [M1, M2, M3]
description: Gera duas versões de um artefato de gate — versão normativa (Documento de Visão no M1; IREB §3.3.3 + EARS + RFC 2119 no M2/M3) e versão leigo (linguagem de negócio). O usuário aprova apenas a versão leigo; a equipe técnica recebe a versão normativa.
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

**Marco-aware:** o formato normativo varia por marco.

**M1 — Documento de Visão:**
Estruturar o artefato normativo seguindo o template `content/templates/01-documento-visao.md` com 5 seções:
1. Visão — frase-síntese estilo Geoffrey Moore
2. Problema & Necessidade — dor real, quem sofre, impacto, indicadores de sucesso (sem lista de solução/features)
3. Pessoas Envolvidas — tabela com usuários diretos (Papel | Interesse | Influência)
4. Contexto e Limites — dentro / fora / integrações / restrições tipadas
5. Premissas e Itens em Aberto

**M2/M3 — Requisitos:**
Aplicar formatação estruturada se ainda não aplicada:
- Requisitos funcionais: `[Sujeito] DEVE [verbo] [objeto] [condição opcional]`
- Requisitos não-funcionais: `[Sistema] DEVE [critério mensurável] quando [condição]`

Salvar com o nome canônico do marco (ver Fase 4).

## Fase 2 — Gerar Versão Leigo

Transformar conteúdo normativo em linguagem de negócio. A versão leigo tem estrutura diferente da normativa:

| Marco | Versão normativa contém | Versão leigo apresenta |
|---|---|---|
| M1 | Documento de Visão: frase-síntese + problema/necessidade + indicadores de sucesso + usuários diretos + contexto/limites + premissas | Resumo em prosa: "Seu produto é X, resolve o problema Y, as pessoas que usam são Z, o objetivo é A..." |
| M2 | Listas RF/RNF com modais + glossário técnico | Listas em linguagem de negócio: "O produto vai fazer... / O produto precisa funcionar..." |
| M3 | SRS completo com 8 seções + diagramas embutidos | **Único documento "Visão do Produto"** — resumo executivo com destaques por tema de negócio, sem siglas ou sintaxe técnica + 2 diagramas Mermaid leigo-safe (contexto e caso de uso) |

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
## 2. Problema & Necessidade

**A dor:** processo manual de agendamento gera conflitos de horário

**Quem sofre:** clientes e recepcionistas da clínica

**Impacto concreto:** perda de consultas, insatisfação e retrabalho administrativo

**Indicadores de sucesso:** reduzir conflitos de horário em 90% no primeiro mês
```

Saída versão leigo:
```markdown
## O problema que seu produto resolve

Hoje, o agendamento é feito manualmente e isso causa confusão nos horários.
Isso afeta diretamente seus clientes e a equipe que cuida da agenda.
O resultado: consultas perdidas, pessoas insatisfeitas e muito retrabalho.

Seu produto resolve isso com um sistema online onde os clientes marcam
horários disponíveis em tempo real, sem risco de conflito.

Será um sucesso quando: conflitos de horário reduzirem 90% no primeiro mês.
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

> **M3 leigo — "Documento do Projeto":** único documento para o cliente. Contém resumo executivo do produto (o que faz, para quem, quais as regras principais) em linguagem de negócio, organizado por tema — não por seção técnica. Não espelha a estrutura do SRS.

**M3 — Inclusão de diagramas leigo-safe (Fase 2.5):**
Após gerar o resumo executivo do SRS (M3), antes de aplicar `traducao-leigo`:
1. Verificar se `documentos-tecnicos/03-documento/03.3-diagramas.md` existe
2. Se sim: extrair o bloco entre `<!-- LEIGO-SAFE-START -->` e `<!-- LEIGO-SAFE-END -->`.
   O bloco contém **2 diagramas** (contexto do sistema e caso de uso — o diagrama de fluxo foi removido).
3. Inserir o bloco extraído no doc leigo como nova seção, após o resumo executivo:
   ```markdown
   ## Como o produto funciona visualmente

   > Os diagramas abaixo mostram como o produto se encaixa no seu dia a dia.
   > Eles foram gerados automaticamente a partir das informações que você forneceu.

   [conteúdo leigo-safe aqui]
   ```
4. Aplicar `traducao-leigo` sobre os **rótulos de nós** dos blocos Mermaid extraídos
   (não só sobre o texto narrativo) — a blacklist D1 vale dentro dos diagramas também
5. Se o arquivo `03.3-diagramas.md` não existir → omitir a seção sem erro

- Versão normativa — pronto para equipe técnica
- Versão leigo — pronto para apresentar ao usuário no gate

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Verificar `marco_corrente` em `estado-projeto.yaml` e agir imediatamente:
- `marco_corrente: M1` → executar PRE-FLIGHT do Gate 1 e abrir via `AskUserQuestion`
- `marco_corrente: M2` → executar PRE-FLIGHT do Gate 2 e abrir via `AskUserQuestion`
- `marco_corrente: M3`, Fase A → Invocar imediatamente `Skill("validacao-checklist-ireb")` (Fase B começa agora)

**PROIBIDO** qualquer TextBlock antes desta ação.

<!-- internal -->
## Anti-Padrão: Versão Leigo = Versão Normativa Parafraseada

**Como acontece:** Skill substitui apenas os termos da blacklist na versão normativa e salva como versão leigo. Resultado: listas técnicas, seções IREB §3.3.3, estrutura EARS — tudo presente, só os termos substituídos. O usuário recebe um documento com aparência técnica em linguagem de negócio.

**Como detectar:** Versão leigo com o mesmo número de seções e mesma estrutura hierárquica da versão normativa.

**O que fazer:** Fase 2 exige reagrupamento real por tema de negócio — não só substituição de termos. A versão leigo deve parecer um resumo executivo escrito para o dono do negócio, não um documento técnico com palavras diferentes. Se a estrutura de seções é idêntica à normativa, refazer a Fase 2.
<!-- /internal -->
