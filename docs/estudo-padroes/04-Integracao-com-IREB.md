# Integração entre IREB §3.3.3 / ISO 29148 e SDD/TDD

**Referências:**  
- IREB — *CPRE Foundation Level Handbook v1.2* (em `referencias/`)  
- ISO/IEC/IEEE 29148:2018  
- Alistair Mavin et al. — *EARS: Easy Approach to Requirements Syntax* (IEEE RE, 2009)

**Ver também:** [`01-Spec-Driven-Development.md`](01-Spec-Driven-Development.md), [`03-BDD-Convergencia-SDD-TDD.md`](03-BDD-Convergencia-SDD-TDD.md)

---

## 1. O padrão atual da ferramenta do TCC

A ferramenta produz, no Marco 3, um SRS conforme:

- **IREB §3.3.3** — critérios de qualidade por requisito (singular) e por SRS (conjunto)
- **ISO/IEC/IEEE 29148:2018** — estrutura canônica do documento SRS e critérios de bem-formação
- **EARS** (Easy Approach to Requirements Syntax) — sintaxe estruturada para requisitos textuais (D8)
- **RFC 2119** — semântica dos modais (`DEVE`, `DEVERIA`, `PODE`) — D8

Os requisitos funcionais no SRS têm forma EARS, por exemplo:

```
WHEN o usuário clica em "Entrar" com credenciais válidas
o sistema DEVE autenticar o usuário e redirecionar para o painel inicial
em até 3 segundos.
```

Critérios de qualidade IREB para esse requisito: verificável, não-ambíguo, completo (diz o que o sistema faz), consistente (não contradiz outros), rastreável.

---

## 2. Comparação prática: EARS × Gherkin

Para o mesmo requisito de negócio, as duas notações produzem:

**Requisito de origem** (catálogo seed `rfs-tipicos.md`):
> Login / Autenticação — acesso com credenciais; sessão com timeout

**Notação EARS (como aparece no SRS):**

```
WHEN o usuário informa email e senha válidos e aciona "Entrar"
o sistema DEVE autenticar o usuário e iniciar uma sessão ativa
com timeout de 30 minutos de inatividade.

WHEN o usuário informa email ou senha inválidos
o sistema DEVE exibir mensagem de erro genérica
sem revelar qual dos dois campos está incorreto.

WHEN a sessão atinge 30 minutos de inatividade
o sistema DEVE encerrar a sessão automaticamente
e redirecionar o usuário para a tela de login.
```

**Notação Gherkin (como apareceria na spec executável):**

```gherkin
Feature: Login e autenticação de usuário

  Scenario: Login com credenciais válidas
    Given que o usuário está na tela de login
    And que existe uma conta com email "usuario@exemplo.com"
    When o usuário informa email "usuario@exemplo.com" e senha correta
    And clica em "Entrar"
    Then o sistema redireciona para o painel inicial
    And uma sessão ativa é iniciada com timeout de 30 minutos

  Scenario: Login com credenciais inválidas
    Given que o usuário está na tela de login
    When o usuário informa email ou senha incorretos
    And clica em "Entrar"
    Then o sistema exibe "Email ou senha incorretos"
    And não revela qual dos campos está incorreto

  Scenario: Expiração de sessão por inatividade
    Given que o usuário está autenticado
    And a sessão está inativa há 30 minutos
    When o usuário realiza qualquer ação no sistema
    Then o sistema encerra a sessão
    And redireciona para a tela de login
```

---

## 3. O que a comparação revela

### 3.1 Complementaridade estrutural

EARS e Gherkin **não são rivais** — têm propósitos distintos:

| Dimensão | EARS | Gherkin |
|---|---|---|
| Audiência primária | Equipe técnica, auditores | Stakeholders + desenvolvedores |
| Nível de abstração | Mais genérico (cobre classes de situações) | Mais concreto (exemplos específicos) |
| Executabilidade | Não roda | Roda com Cucumber/Pytest-BDD |
| Verificação de ambiguidade | Pela leitura e revisão | Automática — se o step não resolve, falha |
| Cobertura | Completa (obrigação da norma) | Por exemplos selecionados |
| Padrão de referência | ISO 29148, IREB | Comunidade BDD/ágil |

**A combinação ideal:** EARS como *especificação normativa* (o contrato formal do SRS) e Gherkin como *especificação por exemplo* (a verificação automatizada de casos representativos).

### 3.2 Onde a 29148 já prevê verificabilidade

A ISO/IEC/IEEE 29148:2018, §5.2.5 (requisitos individuais), lista como critério obrigatório que cada requisito seja **verificável**: deve ser possível determinar, por algum método, se o sistema satisfaz o requisito.

O §10 trata de "validação de requisitos" — o processo de garantir que os requisitos corretos foram especificados. ATDD/BDD operacionalizam esse critério de verificabilidade de forma automatizada: o cenário Gherkin **é** o método de verificação.

Isso significa que SDD/TDD não viola a 29148 — ele a estende, fornecendo um mecanismo executável para o critério de verificabilidade que a norma pede mas não especifica como implementar.

### 3.3 Rastreabilidade completa

A cadeia de rastreabilidade possível com a combinação:

```
Pergunta ao leigo (ask_user)
  → Resposta registrada em sessões/
    → Requisito IREB (EARS, RFC 2119) no SRS
      → Cenário Gherkin (spec executável)
        → Step definitions (código de teste)
          → Implementação (código de produção)
```

Cada seta é rastreável: o requisito IREB aponta para a sessão de origem; o cenário Gherkin referencia o ID do requisito; o step definition é colocalizado com o cenário. O desenvolvedor que recebe o repositório sabe *por quê* cada teste existe.

---

## 4. Pontos de tensão

### 4.1 EARS é forte em estrutura; Gherkin em executabilidade — mas não são intercambiáveis

EARS cobre o requisito de forma completa e normativa. Gherkin cobre exemplos selecionados. Converter EARS para Gherkin automaticamente é uma aproximação, não uma equivalência. Requisitos com múltiplas condições (`WHEN A AND B AND NOT C`) precisam de vários cenários Gherkin para cobertura mínima — o que pode gerar uma suite grande para um único requisito IREB.

### 4.2 Requisitos de qualidade (RNF) não têm tradução natural em Gherkin

Como discutido em `03-BDD-Convergencia-SDD-TDD.md` §6, requisitos de desempenho, segurança em repouso, usabilidade e disponibilidade resistem à forma Given/When/Then. Uma skill `sdd-spec-generator` que processe requisitos funcionais funciona bem — mas precisaria de um tratamento separado para os não-funcionais elicitados pelo Agente Análise.

### 4.3 Toolchain vs. output em Markdown

A ferramenta do TCC atual entrega Markdown puro — não há pipeline de CI. Gherkin rodável requer que o projeto do usuário final tenha framework de teste instalado (Cucumber, Pytest-BDD, etc.). A skill `test-case-generator` prevista no doc 4 geraria código de teste, mas a *execução* desse código dependeria do ambiente do desenvolvedor que recebe o repositório. O repositório entregável seria, portanto, um repositório em *estado RED intencional* — aguardando implementação.

### 4.4 Aprovação do leigo no gate M3 e specs técnicas

O gate M3 (aprovação do cliente leigo) funciona para o SRS em linguagem de negócio. Cenários Gherkin são legíveis por leigos? Sim, mas requerem um mínimo de familiaridade com a estrutura Given/When/Then. A solução prevista em D18 (tradução dupla nos artefatos-gate) se aplica aqui também: o leigo aprova a versão em linguagem natural; a equipe técnica recebe os cenários Gherkin.

---

## 5. Síntese e questões em aberto para D20+

Este estudo não propõe decisão. O que ele revela como **questões em aberto** para eventual deliberação formal:

**Q1 — Escopo da geração de specs:**  
A skill `sdd-spec-generator` deve gerar Gherkin para **todos** os requisitos funcionais do SRS, ou apenas para os marcados como prioritários/críticos? Gerar para todos pode resultar em centenas de cenários para projetos médios — o que tem custo de manutenção para o desenvolvedor.

**Q2 — Tratamento de RNFs:**  
Como a ferramenta trata requisitos não-funcionais na geração de specs? Opções: (a) omitir — gera specs só para RFs; (b) gerar checks de performance/segurança como testes separados (não Gherkin); (c) sinalizar explicitamente ao desenvolvedor que aquele requisito exige estratégia de teste específica.

**Q3 — Formato dos contratos de API:**  
Para projetos com APIs (e-commerce, dashboard, mobile backend), a spec mais natural é OpenAPI, não Gherkin. A skill `sdd-spec-generator` deveria detectar o tipo de projeto (via catálogo de domínios) e escolher o formato?

**Q4 — Dependência de toolchain:**  
O repositório de saída deve incluir instruções de setup do framework de teste, ou assumir que o desenvolvedor já tem? Uma opção é gerar um `README-TESTS.md` explicando como instalar e rodar os testes gerados.

**Q5 — Impacto no gate M3:**  
A aprovação do leigo no gate M3 hoje cobre o SRS. Se o repositório de saída incluir Gherkin + testes, o gate deve também cobrir esses artefatos? Ou o leigo só aprova o SRS e os specs/testes são entregues sem gate específico?

---

Essas questões mapeiam o espaço de decisão que uma eventual D20+ precisaria cobrir. Com este estudo como base, a deliberação pode ser fundamentada nos princípios de SDD e TDD e nas tensões concretas identificadas — em vez de partir de intuição.
