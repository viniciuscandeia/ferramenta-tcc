# Conceitos: Elicitação e Análise

Este guia orienta os agentes sobre como conduzir o processo de descoberta e refinamento de requisitos.

---

## 1. O Processo de Elicitação (Levantamento)
A elicitação não é apenas "coletar" dados, mas sim **descobrir** as necessidades reais.

### Técnicas Avançadas para IA
- **Protocolo do Garçom (Mirroring):** Repetir o que o usuário disse com as suas próprias palavras para confirmar o entendimento. "Então, o senhor deseja um sistema que... correto?". Isso evita que a IA assuma premissas falsas.
- **Modelo Kano:** Identificar quais funcionalidades são:
  - **Básicas:** Se não tiver, o usuário fica insatisfeito (ex: login).
  - **De Desempenho:** Quanto mais melhor (ex: velocidade).
  - **Encantadoras (Delighters):** O usuário não espera, mas ficaria muito feliz se tivesse.
- **Análise de Stakeholders (Matriz Poder x Interesse):** Identificar quem tem mais influência no projeto para priorizar seus requisitos.

## 2. Diretrizes de Condução (Protocolo IA)
1. **Preparação:** Consultar Catálogos Seed antes da interação.
2. **Escuta Ativa & Espelhamento:** Aplicar o Protocolo do Garçom a cada bloco de informações.
3. **Sondagem de Exceções:** Perguntar "E se isso der errado?" ou "Existe algum caso onde essa regra não se aplica?" (Caminhos de exceção).
4. **Tratamento de Conflitos:** Apontar inconsistências de forma empática.

## 3. Diretiva D1: Combate ao Jargão Técnico
**REGRA DE OURO:** Manter a conversa no nível do domínio do usuário.

| Termo Proibido (ER) | Sugestão Amigável |
|---|---|
| Requisito Funcional | "O que o sistema faz" |
| Requisito Não-Funcional | "Qualidade" / "Regra de funcionamento" |
| Stakeholder | "Pessoa interessada" / "Envolvido" |
| Elicitação | "Fase de descoberta" / "Entendimento" |
| Matriz de Rastreabilidade | "Vínculo entre o que foi pedido e o que foi feito" |

## 4. Análise e Refinamento
A análise ocorre no processamento interno da IA:
- **Decomposição:** Quebrar um requisito complexo em partes menores e atômicas.
- **Detecção de Ambiguidade:** Identificar palavras "perigosas" (rápido, fácil, seguro, diversos, alguns) e solicitar quantificação.
- **Análise de Impacto:** Se um novo requisito for adicionado, a IA deve analisar se ele contradiz ou altera requisitos já elicitados.
