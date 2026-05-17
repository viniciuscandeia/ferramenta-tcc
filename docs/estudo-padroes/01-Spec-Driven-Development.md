# Spec-Driven Development (SDD)

**Referência principal:** GitHub Spec Kit (`github/spec-kit`); marcusgoll/Spec-Flow  
**Ver também:** [`03-BDD-Convergencia-SDD-TDD.md`](03-BDD-Convergencia-SDD-TDD.md) (onde spec e teste convergem)

---

## 1. O problema que SDD resolve

A engenharia de software tem um problema estrutural clássico: a **especificação como documento** e o **código como realidade** vivem em mundos separados. O documento não roda. Ele pode ficar desatualizado sem que ninguém perceba. O desenvolvedor o interpreta — e diferentes desenvolvedores o interpretam diferente.

Spec-Driven Development é uma resposta a esse problema: **a especificação deve ser um artefato executável**, não uma representação textual de intenção. Se a spec não pode ser verificada automaticamente, ela não é confiável como contrato.

A ideia não é nova — remonta ao conceito de *executable specifications* dos anos 1990 e à popularização do BDD (Dan North, 2006). O que muda nas ferramentas modernas (GitHub Spec Kit, marcusgoll/Spec-Flow) é a **operacionalização em agentes de IA e workflows de CLI**: a spec é gerada a partir de linguagem natural e imediatamente conectada a testes e implementação.

---

## 2. Princípios centrais

### 2.1 Spec como contrato

A spec não descreve intenção — ela **estabelece um contrato** entre quem pede (stakeholder/analista) e quem entrega (desenvolvedor/agente de implementação). Contratos têm partes verificáveis. Se uma parte for violada, a verificação falha — não fica a cargo de interpretação.

*Implicação:* spec ambígua = contrato inválido. Se não é possível escrever um teste para a spec, a spec está mal formada.

### 2.2 Spec gera tanto código quanto testes

Em fluxos SDD maduros, a spec é o input único do qual derivam:
- o esqueleto do código (scaffold)
- os testes de aceitação (cenários BDD ou contratos de API)
- a documentação

Isso é rastreabilidade automática: o teste aponta para a spec, que aponta para o requisito do stakeholder. Não há perda de informação nas transições.

### 2.3 Spec versionada como código

A spec vive no repositório Git ao lado do código. Muda quando o requisito muda. O histórico de mudanças é auditável. Essa é uma diferença fundamental com documentos Word ou PDFs: a spec tem a mesma disciplina de versionamento do código.

### 2.4 Spec separa o *o quê* do *como*

A spec descreve **comportamento observável** do sistema — o que ele faz, não como ele faz. O desenvolvedor (ou o agente) tem liberdade de implementar como quiser, contanto que a spec passe.

Esse princípio é herdado do BDD e do design por contrato (Meyer, *Object-Oriented Software Construction*, 1988): a spec é o invariante; a implementação é detalhe.

---

## 3. Ferramentas e ecossistema

### 3.1 GitHub Spec Kit

Conjunto de comandos (slash commands para agentes de IA) que operacionalizam SDD:

| Comando | Função |
|---|---|
| `/speckit.constitution` | Define os guardrails permanentes do projeto (padrões, jargão proibido, restrições) |
| `/speckit.clarify` | Detecta lacunas em categorias críticas e faz perguntas antes da especificação profunda |
| `/speckit.specify` | Gera a spec executável a partir de linguagem natural do stakeholder |
| `/speckit.plan` | Decompõe a spec em tarefas de implementação |
| `/speckit.analyze` | Verifica consistência cross-artefato (CRITICAL / HIGH / MEDIUM / LOW) |

O Spec Kit já influenciou decisões do TCC: `constitution.md` (D15), sub-fase de clarificação (D16) e análise cross-artefato pré-gate M3 (D17).

### 3.2 marcusgoll/Spec-Flow

Repositório de referência para estrutura agnóstica de IDE:

- Lógica de prompts/agentes em diretório `core/` — independente de plataforma
- Adapters por IDE (`.gemini/`, `.claude/`, `.codex/`) mapeiam primitivas sem redefinir comportamento
- `state.yaml` por epic — inspirou D13 (`estado-projeto.yaml`)
- Question batching pattern — inspirou D14

Esse repositório é o mais próximo de uma **implementação de referência** de SDD em contexto de agentes de IA de CLI.

### 3.3 Contratos de API como spec

Para sistemas com APIs, a spec executável toma a forma de um **schema formal de contrato**:

- **OpenAPI / AsyncAPI** — especificam endpoints, parâmetros, tipos de resposta e erros. Ferramentas como `openapi-generator` derivam código e testes do schema.
- **JSON Schema** — valida a estrutura de dados trocados entre componentes.
- **Pact** (contract testing) — verifica que produtor e consumidor de uma API obedecem ao mesmo contrato em tempo de CI. Cada parte mantém seu "pact file"; o servidor Pact Broker media a verificação.

Contratos de API são specs executáveis no sentido mais estrito: rodam automaticamente, falham com mensagem específica, são versionados no repositório.

---

## 4. Pontos fortes

**Ambiguidade detectável.** Se não é possível gerar um teste para a spec, a ambiguidade é forçada a aparecer — o sistema não pode fingir que a spec está pronta.

**Rastreabilidade automática.** A cadeia stakeholder → spec → teste → código é rastreável sem esforço manual adicional.

**Contrato formal entre times.** Em ambientes com múltiplos times, a spec é o artefato que pode ser negociado e assinado sem que as partes precisem ler o código um do outro.

**Compatível com IA generativa.** Agentes podem gerar spec a partir de linguagem natural e, em seguida, gerar código a partir da spec — com a spec como filtro de qualidade entre os dois passos.

---

## 5. Pontos fracos e limitações

**Maturidade do ecossistema ainda emergente (2024–2026).** Ferramentas como GitHub Spec Kit e Spec-Flow são relativamente novas e menos padronizadas do que IREB ou ISO 29148. Há menos consenso sobre o formato canônico de uma spec executável.

**Nem todo requisito é facilmente especificável em forma executável.** Requisitos de qualidade (desempenho, segurança, usabilidade) não têm semântica de teste óbvia. Dizer "o sistema DEVE responder em menos de 2 segundos" é uma spec executável — dizer "o sistema DEVE ser intuitivo" não é. (Ver `04-Integracao-com-IREB.md` para a tensão com FURPS+/ISO 25010.)

**Risco de over-engineering da spec.** A tentação de detalhar demais a spec transforma o trabalho de especificação em trabalho de implementação disfarçado — o que derrota o propósito de separar *o quê* do *como*.

**Dependência de toolchain.** SDD pleno requer que o time tenha pipeline de CI capaz de rodar a spec automaticamente. Em projetos sem toolchain (como o TCC atual, que é só Markdown), a executabilidade da spec é aspiracional.

---

## 6. SDD no contexto do doc `4 - Evolucao-SDD-TDD.md`

O doc 4 prevê uma skill `sdd-spec-generator` que, após a elicitação, traduz as respostas do stakeholder em formato SDD-compliant (cenários `Given/When/Then` + contratos de API). Essa é a operacionalização de SDD dentro da ferramenta do TCC.

A pergunta não formalizada (candidata a D20+) é: **qual formato de spec adotar?** Puro Gherkin? OpenAPI para requisitos de integração? Combinação? A resposta depende do tipo de projeto do usuário final — que o catálogo seed em `ferramenta-tcc/catalogos-seed/dominios/` já segmenta por domínio.
