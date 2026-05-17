# Deliberação das Decisões D20–D24 — Extensão SDD/TDD

**Data:** 2026-05-17  
**Fonte das candidatas:** [`docs/estudo-padroes/04-Integracao-com-IREB.md`](../estudo-padroes/04-Integracao-com-IREB.md) §5 (Síntese e questões em aberto)  
**Decisões fundadoras (baseline):** [`1 - Decisões Tomadas.md`](1%20-%20Decisões%20Tomadas.md) (D1–D11) e [`5 - Revisão D12-D19.md`](5%20-%20Revisão%20D12-D19.md) (D12–D19)  
**Método:** deliberação estruturada questão por questão com alternativas A/B/C; veredito por seleção do stakeholder

---

## Sumário executivo

- **5 candidatas aceitas:** D20, D21, D22, D23, D24
- **0 rejeitadas**
- **0 adiadas**
- **Tensão T5 identificada:** D24 (Gate M4) amplia o escopo do TCC com novo marco — impacto no ROADMAP; gravidade anotada em "Próximos passos"
- **Tensão T6 identificada:** D20 pressupõe RFC 2119 como critério de prioridade para geração de specs; se o slot estruturado de prioridade no SRS for diferente do modal, a skill `sdd-spec-generator` precisará de ajuste de implementação

---

## Contexto: de onde vêm estas decisões

O documento [`4 - Evolucao-SDD-TDD.md`](4%20-%20Evolucao-SDD-TDD.md) previu a integração de Spec-Driven Development (SDD) e Test-Driven Development (TDD) como extensão futura da ferramenta — produzindo um "repositório executável" além do SRS. A revisão D12–D19 classificou essa proposta como "não formalizada — candidata a ciclo futuro de revisão".

O estudo [`docs/estudo-padroes/`](../estudo-padroes/) aprofundou a fundamentação teórico-prática, e a seção §5 de [`04-Integracao-com-IREB.md`](../estudo-padroes/04-Integracao-com-IREB.md) mapeou 5 questões em aberto que precisavam de deliberação antes de qualquer implementação. Este documento registra o veredito sobre cada uma.

---

## D20 — Escopo de geração de specs (skill `sdd-spec-generator`)

**Proposta:** a skill `sdd-spec-generator` gera cenários Gherkin apenas para requisitos funcionais marcados com modal `DEVE` (RFC 2119). RFs marcados `DEVERIA` e `PODE` não recebem spec gerada automaticamente.

**Alternativas consideradas:**
- A — Cobertura completa: todos os RFs geram spec (rejeitada — repositório final excessivamente grande para projetos médios)
- **B — Seletiva por RFC 2119: apenas `DEVE` (ACEITA)**
- C — Completa com classificação CORE/EXTENDED/EDGE (rejeitada — complexidade de classificação desnecessária no MVP)

**Tensões:** T6 — RFC 2119 (`DEVE`) é o critério de prioridade adotado. Se o SRS também usar um campo separado de prioridade (além do modal), a skill deve usar o campo, não o modal, como critério principal. A ser resolvida na implementação da skill.

**DECISÃO: ACEITA como está**

**Justificativa:** RFs marcados `DEVERIA` e `PODE` são por definição menos críticos; gerar specs para eles cria ruído no repositório de saída. O critério RFC 2119 é objetivo, já está no SRS e não requer nova pergunta ao leigo. A cobertura resultante (estimativa: 40–60% dos RFs de um projeto típico) representa o núcleo mínimo verificável do sistema.

---

## D21 — Tratamento de RNFs na fase de spec

**Proposta:** a ferramenta gera um arquivo `TESTING-STRATEGY.md` no repositório de saída, listando cada requisito não-funcional do SRS com: (a) categoria (desempenho, segurança, usabilidade, disponibilidade); (b) ferramenta sugerida para verificação (ex: k6, OWASP ZAP, Lighthouse, teste manual); (c) métrica de referência quando disponível; (d) sinalização explícita quando a verificação automatizada é inviável.

**Alternativas consideradas:**
- A — Omitir RNFs da fase de spec (rejeitada — deixa o desenvolvedor sem orientação sobre como verificar requisitos relevantes)
- B — Gerar checks automatizados para RNFs mensuráveis (rejeitada para MVP — lógica de classificação complexa; prazo 2026-07-01 não comporta)
- **C — `TESTING-STRATEGY.md` como guia de estratégia (ACEITA)**

**Tensões:** nenhuma — artefato independente, não afeta o SRS nem os cenários Gherkin.

**DECISÃO: ACEITA como está**

**Justificativa:** RNFs subjetivos (usabilidade, disponibilidade sem SLA) resistem à especificação executável. Tentar gerá-los como Gherkin produz cenários mal formados ou falsos positivos. `TESTING-STRATEGY.md` é honesto sobre os limites da automação e educativo para o desenvolvedor. A evolução natural para B (D21-v2) pode ocorrer em versão futura da ferramenta sem retrocompatibilidade obrigatória.

---

## D22 — Formato único de specs: Gherkin

**Proposta:** Gherkin é o único formato de especificação executável gerado pela ferramenta. OpenAPI/AsyncAPI (para contratos de API) e JSON Schema (para estruturas de dados) ficam fora do escopo do MVP, documentados como evolução futura.

**Alternativas consideradas:**
- **A — Gherkin apenas, agnóstico de plataforma (ACEITA)**
- B — OpenAPI para projetos com API + Gherkin para comportamentos de UI/fluxo (rejeitada para MVP — dois formatos, lógica de detecção por domínio, maior carga de implementação)
- C — Gherkin + YAML inline (rejeitada — não é OpenAPI válido; perde o ecossistema de geração de código)

**Relação com D12:** D12 (engine canônico agnóstico de IDE) alinha-se com D22: um único formato de spec funciona nos adapters Gemini CLI, Claude Code e Codex sem adaptações.

**Tensões:** projetos com APIs REST/GraphQL perdem verificabilidade de contratos automática. Trade-off aceito para MVP.

**DECISÃO: ACEITA como está**

**Justificativa:** um formato, uma ferramenta — menor barreira de adoção para o desenvolvedor que recebe o repositório. OpenAPI como extensão de versão 2.0 deve ser documentado em `1 - Decisões Tomadas.md` como "evolução prevista, não comprometida".

---

## D23 — Toolchain: `README-TESTS.md` dedicado

**Proposta:** o repositório de saída inclui um arquivo `README-TESTS.md` que explica: (a) que os cenários Gherkin estão em estado RED intencional; (b) como instalar e rodar os testes nos 3 frameworks mais comuns — Pytest-BDD (Python), Cucumber-js (JavaScript/TypeScript), SpecFlow (.NET); (c) estrutura de diretórios `spec/` e `tests/`.

**Alternativas consideradas:**
- **A — `README-TESTS.md` dedicado (ACEITA)**
- B — Instruções inline no SRS em seção de Anexos (rejeitada — viola separação de responsabilidades: SRS é documento de requisitos, não de ambiente de desenvolvimento)
- C — Detecção de linguagem via nova pergunta ao leigo/desenvolvedor (rejeitada — leigo não sabe responder; introduzir "desenvolvedor" como novo persona amplia o fluxo de elicitação além do MVP)

**Tensões:** nenhuma — arquivo independente no repositório de saída; não afeta o SRS nem os cenários Gherkin.

**DECISÃO: ACEITA como está**

**Justificativa:** `README-TESTS.md` tem responsabilidade única e clara. O template genérico cobrindo 3 frameworks equilibra utilidade (o desenvolvedor provavelmente usa um deles) e manutenibilidade (sem lógica de detecção de linguagem). O Agente Gerência é o responsável natural por gerar este arquivo no Marco 3.

---

## D24 — Gate M4: revisão técnica do repositório de saída

**Proposta:** introduzir um Marco M4 opcional — após o Gate M3 (aprovação do leigo no SRS), o desenvolvedor ou tech lead revisa o repositório de saída completo (`spec/`, `tests/`, `README-TESTS.md`, `TESTING-STRATEGY.md`) antes de aceitar o baseline de implementação. O gate M4 é gatilhado pelo stakeholder técnico, não pelo leigo.

**Alternativas consideradas:**
- A — Gate M3 inalterado (rejeitada — o leigo aprova intenção; sem gate técnico, specs podem ser inconsistentes ou incompletas do ponto de vista de implementação)
- B — Estender M3 com "resumo de exemplos" traduzidos para o leigo (rejeitada — mistura a aprovação de intenção do leigo com a validação técnica da spec; dois gates M3 distintos criam confusão de persona)
- **C — Gate M3 inalterado + Gate M4 novo para persona técnica (ACEITA)**

**Tensões:** T5 — D24 amplia o escopo do TCC com novo marco e novo agente/skill. Impacto direto no ROADMAP (ver "Próximos passos"). O Marco M4 deve ser marcado como opcional no MVP — a ferramenta entrega o repositório mesmo se o M4 não for conduzido, mas o Agente Gerência sinaliza que ele existe.

**DECISÃO: ACEITA como está**

**Justificativa:** a separação de persona é fundamental para a integridade do processo. O Gate M3 foi projetado para o leigo validar intenção de negócio em linguagem não-técnica (D1, D18). Forçar o leigo a também validar specs técnicas dilui o princípio de D1. O Gate M4 fecha o loop com o stakeholder correto: o desenvolvedor confirma que o repositório entregue é implementável. O caráter "opcional" preserva a viabilidade no prazo 2026-07-01 — a ferramenta pode ser entregue sem M4 completamente implementado, desde que o Agente Gerência o sinalize como etapa seguinte.

---

## Impacto nos artefatos de saída (Marco 3 → Marcos 3+4)

Com D20–D24 aceitas, o repositório de saída final passa a ser:

```
projeto-do-usuario/
├── marco-1/                     (inalterado)
├── marco-2/                     (inalterado)
├── marco-3/
│   ├── srs/
│   │   └── SRS-completo.md      (inalterado)
│   ├── spec/                    (NOVO — D20, D22)
│   │   └── *.feature            (cenários Gherkin para RFs DEVE)
│   ├── tests/                   (NOVO — D20)
│   │   ├── unit/
│   │   └── acceptance/
│   ├── TESTING-STRATEGY.md      (NOVO — D21)
│   └── README-TESTS.md          (NOVO — D23)
└── marco-4/                     (NOVO — D24, opcional)
    ├── revisao-tecnica.md        (checklist de revisão pelo desenvolvedor)
    └── aprovacao-tecnica.md      (baseline aceito pelo tech lead)
```

---

## Tabela de veredito

| # | Decisão | Status | Modifica | Data | Notas |
|---|---|---|---|---|---|
| D20 | Escopo de geração de specs (`DEVE` apenas) | ACEITA | Nova | 2026-05-17 | RFC 2119 como critério de prioridade; T6 a resolver na implementação |
| D21 | Tratamento de RNFs via `TESTING-STRATEGY.md` | ACEITA | Nova | 2026-05-17 | Evolução para verificações automatizadas prevista como D21-v2 |
| D22 | Formato único Gherkin (OpenAPI adiado) | ACEITA | Nova | 2026-05-17 | OpenAPI como evolução de versão 2.0 documentada, não comprometida |
| D23 | `README-TESTS.md` no repositório de saída | ACEITA | Nova | 2026-05-17 | Template genérico; 3 frameworks cobertos |
| D24 | Gate M4 — revisão técnica pelo desenvolvedor | ACEITA | Novo Marco | 2026-05-17 | T5: impacto no ROADMAP; M4 opcional no MVP |

---

## Tensões não resolvidas após a deliberação

- **T5 — Escopo do TCC com M4:** Gate M4 cria novo marco não previsto no ROADMAP atual. Precisa ser absorvido explicitamente no cronograma 2026-07-01 ou marcado como "infra-estrutura mínima implementada, fluxo completo fora do MVP".
- **T6 — Critério de prioridade em D20:** a skill `sdd-spec-generator` usa modal RFC 2119 (`DEVE`) como critério. Se o SRS tiver campo de prioridade separado (ex: Alta/Média/Baixa), a skill deve ser especificada para usar esse campo. A ser resolvida quando a skill for implementada.

---

## Próximos passos

1. Atualizar [`1 - Decisões Tomadas.md`](1%20-%20Decisões%20Tomadas.md) com D20–D24 (tabela e justificativas resumidas).
2. Revisar [`3 - Arquitetura da Ferramenta.md`](3%20-%20Arquitetura%20da%20Ferramenta.md): adicionar Marco 4, artefatos SDD/TDD e as duas novas skills (`sdd-spec-generator`, `test-case-generator`).
3. Revisar [`ROADMAP.md`](ROADMAP.md): incluir implementação de D20–D24 e definir se M4 entra no MVP 2026-07-01 ou como extensão.
4. Implementar skill `sdd-spec-generator` (Agente SRS, Marco 3): lê os RFs com modal `DEVE` do SRS e gera cenários Gherkin em `spec/*.feature`.
5. Implementar skill `test-case-generator` (Agente Validação, Marco 3): para cada `.feature`, gera esqueleto de step definitions em estado RED.
6. Implementar `TESTING-STRATEGY.md` generator (Agente SRS ou Agente Validação): lê RNFs do SRS e gera o guia de estratégia de testes.
7. Implementar `README-TESTS.md` template (Agente Gerência, pós-Gate M3): gera instruções de setup baseadas no template genérico.
8. Definir e implementar fluxo do Marco M4 (Agente Gerência como mediador): checklist de revisão técnica + artefato `aprovacao-tecnica.md`.
