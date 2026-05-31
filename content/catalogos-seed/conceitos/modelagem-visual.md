# Catálogo: Modelagem Visual — Templates Mermaid

Usado pela skill **`modelagem-visual`** para gerar diagramas consistentes entre
projetos. Cada template é canônico — a skill substitui os placeholders com dados
reais dos artefatos de entrada.

Fundamento normativo:
- IREB CPRE AL — 3 perspectivas: estrutural/dados, funcional, comportamental
- ISO/IEC/IEEE 29148 — diagrama de contexto e casos de uso como recommended practices
- Motor: Mermaid (render nativo GitHub/VSCode, sem runtime extra)

---

## Regras de rotulagem leigo-safe

As regras a seguir valem para **todos** os rótulos de nós no subconjunto leigo
(context, use-case, fluxo). Aplicar `traducao-leigo` sobre os rótulos gerados.

| Proibido nos rótulos leigo | Substituir por |
|---|---|
| Termos da blacklist D1 (requisito, elicitação, stakeholder…) | Equivalentes da blacklist |
| Nomes de entidades técnicas (ex: `UserEntity`) | Nome de negócio (ex: "Cliente") |
| Acrônimos não expandidos (ex: `API`, `BD`) | Nome legível (ex: "Serviço de Pagamento", "Banco de Dados") |
| Verbos técnicos (ex: "autenticar", "serializar") | Verbos de negócio (ex: "entrar no sistema", "salvar") |

---

## 1. Diagrama de Contexto (obrigatório — sempre gerar)

**Perspectiva:** ISO 29148 / fronteira do sistema
**Leigo-safe:** ✅ sim
**Fonte:** `documentos-tecnicos/01-visao/01-visao-produto.md` — seção Contexto e
Limites (integrações, atores principais) + `02.3-restricoes.md` (sistemas externos)

**Algoritmo:**
1. Extrair o nome do sistema/produto
2. Extrair perfis de usuário (camada 1 do onion)
3. Extrair integrações externas (sistemas, serviços, APIs terceiras)
4. Montar flowchart LR com: atores à esquerda, sistema no centro, externos à direita

```mermaid
flowchart LR
    U1["👤 [Perfil de Usuário 1]"]
    U2["👤 [Perfil de Usuário 2]"]
    S(["📦 [Nome do Sistema]"])
    E1["⚙️ [Sistema Externo 1]"]
    E2["⚙️ [Sistema Externo 2]"]

    U1 -->|usa| S
    U2 -->|usa| S
    S -->|integra com| E1
    S -->|integra com| E2
```

**Regras:**
- Se não há integração externa → omitir nós externos (não criar nó vazio)
- Máximo 4 atores e 4 externos — agrupar se ultrapassar
- Rótulos das setas em linguagem de negócio (não "POST /api/…")

---

## 2. Diagrama de Caso de Uso — "Mapa de Funcionalidades" (obrigatório)

**Perspectiva:** ISO 29148 use cases / funcional
**Leigo-safe:** ✅ sim (mostrar como "o que o sistema faz para cada pessoa")
**Fonte:** `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (RFs DEVE)
× stakeholders da camada 1 do onion

**Algoritmo:**
1. Agrupar RFs DEVE por ator principal (quem executa ou inicia a ação)
2. Para cada ator: criar nó de ator + nós de funcionalidade vinculados

```mermaid
flowchart LR
    A1["👤 [Perfil 1]"]
    A2["👤 [Perfil 2]"]

    A1 --> F1["[Funcionalidade 1]"]
    A1 --> F2["[Funcionalidade 2]"]
    A2 --> F3["[Funcionalidade 3]"]
    A2 --> F1
```

**Regras:**
- Máximo 8 funcionalidades por diagrama — se ultrapassar, agrupar por módulo
  (usar `subgraph`) ou recortar pelo ator
- Usar descrição do RF sem sintaxe EARS ("Cadastrar produto" não "O sistema DEVE permitir o cadastro de produto")
- Se RF não tem ator claro → mapear para o ator de maior influência no onion

---

## 3. Diagrama de Fluxo / Atividade — Caminho Principal (obrigatório)

**Perspectiva:** IREB funcional
**Leigo-safe:** ✅ sim
**Fonte:** `documentos-tecnicos/03-documento/04-spec/*.feature` (cenário "caminho
feliz" de cada RF DEVE) ou `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`
(narrativa de uso, se cenário não disponível ainda)

**Algoritmo:**
1. Selecionar o fluxo principal do produto (feature mais importante — RF DEVE de
   maior prioridade no MoSCoW, ou o primeiro RF na lista)
2. Extrair passos do Gherkin: `Given` → pré-condição, `When` → ação, `Then` → resultado
3. Montar flowchart TD com decisões para caminhos de erro se existirem no cenário

```mermaid
flowchart TD
    Start([Início])
    P1["[Pré-condição: contexto inicial]"]
    A1["[Ação: o que o usuário faz]"]
    D{"[Decisão se houver]?"}
    R1["[Resultado esperado]"]
    R2["[Resultado alternativo]"]
    End([Fim])

    Start --> P1 --> A1 --> D
    D -->|Sim| R1 --> End
    D -->|Não| R2 --> End
```

**Regras:**
- Se não há decisão → usar flowchart linear (sem losango)
- Máximo 8 nós no fluxo principal — encurtar se necessário
- Rótulos: linguagem de negócio, sem jargão técnico

---

## 4. Diagrama Entidade-Relacionamento (técnico — não leigo)

**Perspectiva:** IREB estrutural/dados
**Leigo-safe:** ❌ (versão técnica apenas)
**Fonte:** `documentos-tecnicos/02-requisitos/02.5-glossario.md` (entidades e suas
definições + relações mencionadas)

**Algoritmo:**
1. Extrair substantivos do glossário que representem "coisas que o sistema armazena"
   (ex: "Pedido", "Cliente", "Produto", "Pagamento")
2. Inferir atributos principais do contexto (id, nome, data, status são seguros)
3. Inferir relações das definições e dos RFs (ex: "Pedido contém vários Itens")
4. Usar notação crow's foot

```mermaid
erDiagram
    ENTIDADE1 {
        string id
        string nome
        date data_criacao
    }
    ENTIDADE2 {
        string id
        string status
    }
    ENTIDADE3 {
        string id
        number quantidade
    }

    ENTIDADE1 ||--o{ ENTIDADE2 : "tem"
    ENTIDADE2 ||--o{ ENTIDADE3 : "contém"
```

**Regras:**
- Nomear entidades em MAIÚSCULAS (convenção erDiagram)
- Inferência conservadora: incluir só entidades com ≥ 2 atributos identificáveis
- Se glossário tem < 3 termos substantivos → não gerar ER; registrar nota explicando
- Relações: inferir dos RFs e definições — nunca inventar

---

## 5. Diagrama de Estados (técnico — condicional)

**Perspectiva:** IREB comportamental
**Leigo-safe:** ❌ (versão técnica apenas)
**Condição de geração:** só gerar se houver ≥ 1 entidade com ciclo de vida explícito
nos RFs ou glossário (ex: "Pedido: novo → confirmado → enviado → entregue";
"Usuário: ativo → suspenso → excluído")
**Fonte:** `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + glossário

**Algoritmo:**
1. Buscar padrões de ciclo de vida nos RFs: verbos que implicam transição de estado
   ("cancelar", "aprovar", "publicar", "arquivar", "expirar")
2. Buscar campos de status no glossário (ex: "status: ativo/inativo")
3. Para cada entidade com ciclo de vida identificado: montar stateDiagram-v2

```mermaid
stateDiagram-v2
    direction LR
    [*] --> Estado1 : criação
    Estado1 --> Estado2 : [evento que dispara]
    Estado2 --> Estado3 : [evento]
    Estado3 --> [*] : conclusão
    Estado2 --> Estado1 : [reversão se possível]
```

**Regras:**
- Nomear estados em PascalCase descritivo ("Aguardando", "EmAnalise", "Aprovado")
- Se não há ciclo de vida identificável → não gerar; registrar nota explícita:
  "Nenhum ciclo de vida de entidade identificado nos artefatos — diagrama de
  estados omitido."
- Máximo 2 entidades por arquivo — criar diagrama separado por entidade se mais

---

## 6. Subconjunto leigo-safe — o que vai para traducao-gate

O arquivo `03.3-diagramas.md` contém uma seção marcada que `traducao-gate`
extrai para embutir no doc leigo:

```markdown
<!-- LEIGO-SAFE-START -->
## Como o sistema funciona

### Quem usa e o que o sistema faz

[diagrama de contexto aqui]

### O que cada pessoa pode fazer

[diagrama de caso de uso aqui]

### Como o fluxo principal funciona

[diagrama de fluxo aqui]
<!-- LEIGO-SAFE-END -->
```

`traducao-leigo` deve ser aplicado sobre os rótulos dos nós antes de embutir
no doc leigo — os títulos de seção também devem seguir a blacklist D1.
