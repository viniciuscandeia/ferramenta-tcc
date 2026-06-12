---
name: stakeholder-mapping
marco: [M1]
description: >-
  Identifica e mapeia todas as pessoas envolvidas no projeto usando o modelo Stakeholder Onion (camadas: usa/decide-paga/mantém/afetado/regula/adversário).
  Use após documentar o problema, quando é preciso saber quem tem interesse no produto.
  Map stakeholders for a layperson project; produces Onion-model table with interest, influence, and decisor flag.
---

## Filosofia desta skill (Regras Absolutas)

1. **Extrair antes de perguntar** — sempre ler skills anteriores e pré-popular a tabela com pessoas já mencionadas. Nunca repetir pergunta sobre quem já foi nomeado.
2. **Decisor explícito é obrigatório** — sem decisor identificado (Camada 2, Decide-paga), o Gate 1 não pode ser aprovado. Se o usuário não souber, registrar como `[a identificar]` e marcar como pendência aberta.
3. **Usar checklist de camadas, não perguntas abertas** — o modelo Onion define 6 camadas. O agente verifica cada camada sistematicamente, começando pelas preenchidas na Fase de extração. Menos turnos, mais cobertura.
4. **Sondagem regulatória proativa** — se o domínio sugerir regulação (saúde, finanças, educação, alimentos, transporte), o agente sonda explicitamente a Camada 5 (Regula) antes de prosseguir.

<HARD-GATE>
- NÃO executar antes de `necessidade-visao` concluído (verificar que `## 1. Visão` e `## 2. Problema & Necessidade` existem em `documentos-tecnicos/01-visao/01-visao-produto.md`)
- ⛔ STOP se pré-extração retornar 0 pessoas (indica que M1 está corrompido ou vazio) — registrar em `_pendencias.md`
- ⛔ BLOQUEAR Gate 1 se `Decisor: Sim` ausente em toda a tabela e não há `[a identificar]` justificado em `pautas_abertas`
</HARD-GATE>

## Fase 0 — Inicialização e Pré-Extração

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## 1. Visão` e `## 2. Problema & Necessidade` devem existir
3. **Pré-extração:** ler `documentos-tecnicos/01-visao/01-visao-produto.md` e extrair TODAS as pessoas/grupos/entidades já mencionados.
   - Tokenizar nomes próprios e substantivos de papel (médico, recepcionista, fornecedor, gestor, cliente, plano, órgão, etc.)
   - Mapear cada um para a camada Onion mais provável
   - Pré-preencher a tabela com `Necessidade principal: [inferida]` + flag `[a confirmar]`
4. **Detecção de domínio regulado:** inferir domínio do texto (saúde → CFM/LGPD; financeiro → BACEN/LGPD; educação → MEC/LGPD; alimentos → ANVISA; transporte → ANTT/ANAC). Se domínio regulado detectado, preparar sondagem da Camada 5.
5. **Consultar catálogo de papéis típicos:** ler `{PLUGIN_ROOT}/content/catalogos-seed/stakeholders-tipicos.md` e verificar quais papéis típicos do domínio detectado (ex.: Administrador, DPO/Encarregado de Dados, Auditor, Equipe de TI) não foram mencionados pelo usuário. Adicionar como linhas `[a confirmar]` na pré-extração — usuário confirma ou descarta na Fase 1.

## Fase 1 — Checklist de Camadas (1 `AskUserQuestion`, máx 4 perguntas)

**Lote único** — personalizado com quem já foi extraído. Cobrir as camadas ainda não preenchidas pela pré-extração:

**Candidatos do catálogo `[a confirmar]` (incluir SE Fase 0 gerou ≥ 1 candidato — contar como 1 pergunta do lote):**
```
Além das pessoas que você já mencionou, sistemas como o seu costumam ter estes perfis envolvidos. Quais fazem parte do seu projeto? (pode escolher mais de uma)
(A–C) [máx 3 candidatos gerados na Fase 0 — usar os mais relevantes para o domínio]
(D) Nenhum destes
```
`header: "Perfis"` · `multiSelect: true`
*(Omitir se a Fase 0 NÃO gerou candidatos `[a confirmar]` do catálogo.)*

**Camada 2 — Decide-paga (sempre perguntar se não identificado):**
```
Quem precisa aprovar ou pagar pelo produto? Pode ser uma pessoa, um cargo ou um departamento.
```

**Camada 3 — Mantém-suporta (se produto tiver operação contínua — inferir):**
```
Quem vai cuidar do produto depois que estiver pronto? (ex: equipe de TI, suporte, o próprio dono)
```
*(Incluir só se contexto sugere operação contínua — omitir para projetos pessoais simples.)*

**Camada 4 — Afetado (se não identificado na pré-extração):**
```
Tem alguém que vai ser afetado pelo produto sem usá-lo diretamente? (ex: clientes dos seus clientes, parceiros, equipes que dependem dos dados)
```

**Camada 5 — Regula (se domínio regulado detectado na Fase 0 — SEMPRE incluir):**
```
O produto precisa seguir alguma regra legal, norma do setor ou exigência de órgão regulador? (ex: proteção de dados, regras de saúde, normas financeiras)
```
*(Se não regulado: omitir esta pergunta.)*

**Camada 6 — Adversário (opcional — incluir se produto lida com dados sensíveis/acesso controlado):**
```
Tem algum grupo que NÃO deve ter acesso ao produto ou que poderia tentar usá-lo de forma indevida?
```

**Regra:** incluir apenas as perguntas para camadas que a pré-extração NÃO cobriu. Se todas as camadas relevantes já estiverem preenchidas, pular o lote e ir direto para a Fase 2.

## Fase 2 — Síntese

Montar tabela com os **usuários diretos** (Camada 1 — "Usa diretamente") para o documento entregue. Demais camadas ficam registradas apenas em `estado-projeto.yaml`:

```markdown
## 3. Pessoas Envolvidas

| Papel | Interesse principal | Influência |
|---|---|---|
| [Nome do papel — usuário direto] | [O que precisa ou espera] | Alta / Média / Baixa |
```

**Regras de síntese:**
- Listar **somente** perfis da Camada 1 (Usa diretamente) no documento
- Influência: inferir da intensidade de uso (usuário principal = Alta; uso ocasional = Média)
- Inferências marcadas como `[inferido]` na versão normativa
- Se usuário não souber quem usa: registrar como `[a identificar]` + adicionar à `pautas_abertas` em `estado-projeto.yaml`
- **Demais camadas** (Decide-paga, Mantém-suporta, Afetado, Regula, Adversário): registrar em `estado-projeto.yaml` com campos `decisor`, `reguladores`, `afetados`; não incluir no documento entregue
- Verificar: ao menos 1 papel identificado como "Decisor: Sim" em `estado-projeto.yaml` (campo interno) — se ausente, registrar pendência crítica
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

## Fase 3 — Saída

1. Append seção `## 3. Pessoas Envolvidas` em `documentos-tecnicos/01-visao/01-visao-produto.md`
2. Atualizar `estado-projeto.yaml`:
   - Se houver `[a identificar]`: adicionar à lista `pautas_abertas`
   - Se decisor ausente: registrar `pendencia_gate_1: "Decisor não identificado — bloqueará Gate 1"`
3. ⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
   Invocar imediatamente `Skill("contexto-e-limite")` usando a ferramenta Skill.

   **PROIBIDO antes desta chamada:**
   - Produzir qualquer TextBlock ao usuário (ex: "✓ Mapeei...", "Próximo passo é...", "Salvei o arquivo...")
   - Escrever qualquer prosa assistente no chat
   - Finalizar o turno sem invocar a próxima Skill

   A chamada `Skill("contexto-e-limite")` deve ser a próxima ferramenta invocada após os Writes de artefato.

<!-- internal -->
## Anti-Padrão: Pré-Extração Perde Entidade de Texto Longo

**Como acontece:** Em inputs ricos (ex: texto longo da médica no Caso 2), o pré-processamento lê só a seção de Visão e perde entidades mencionadas no corpo do texto de Problema (ex: "plano de saúde" mencionado como exigência regulatória).

**Como detectar:** Varrer TODAS as seções já escritas em `01-visao-produto.md` — não só a `## 1. Visão`. Tokenizar substantivos de papel em todas as seções.

**O que fazer:** Fail-safe — adicionar qualquer entidade não capturada como linha extra com camada `[a confirmar]`. Melhor uma linha a mais para revisar do que uma omissão silenciosa.

---

## Anti-Padrão: Camada Regula Ignorada em Domínio Sensível

**Como acontece:** Projeto de saúde ou financeiro não ativa a sondagem de regulação porque o usuário não mencionou espontaneamente. LGPD, CFM, BACEN, ANVISA ficam fora do mapa de pessoas/restrições.

**Como detectar:** Verificar domínio inferido na Fase 0. Se domínio ∈ {saúde, financeiro, educação, alimentos, transporte, jurídico}, a Camada 5 deve estar presente na tabela ou ter uma linha `[a identificar]`.

**O que fazer:** Forçar a pergunta de Camada 5 quando o domínio for regulado — nunca omitir por "provavelmente o usuário sabe".
<!-- /internal -->
