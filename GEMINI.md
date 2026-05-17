# GEMINI.md - TCC: Ferramenta de Elicitação de Requisitos

Este repositório contém o Trabalho de Conclusão de Curso (TCC) de Vinicius Candeia, focado no desenvolvimento de uma ferramenta assistida por agentes de IA para elicitação e documentação de requisitos de software.

---

## 🚀 Visão Geral do Projeto

A ferramenta conduz stakeholders leigos através de perguntas estruturadas (invertendo o protocolo de interação: a IA pergunta, o usuário responde) para gerar uma **Especificação de Requisitos de Software (SRS)** seguindo o padrão **IREB §3.3.3 (ISO/IEC/IEEE 29148)**.

### Tecnologias Principais
- **Plataforma:** Gemini CLI (Primária) / Claude Code (Porte MVP).
- **Linguagem:** Prompts estruturados em Markdown, Skills e Agentes.
- **Interação:** Primitiva `ask_user` (Gemini CLI) para loops interativos.

---

## 📂 Estrutura do Repositório

O projeto possui uma **estrutura dupla**:

| Pasta | Papel |
|---|---|
| `ferramenta-tcc/` | **A ferramenta** — Agentes, skills, catálogos seed e testes. |
| `docs/planejamento/` | Decisões de design, arquitetura, vocabulário técnico e ROADMAP. |
| `docs/estudo-skills/` | Notas de pesquisa sobre design de skills e agentes. |
| `referencias/` | Bibliografia consultada (PDFs). **Não distribuível**. |
| `sandbox/` | Experimentos e protótipos não-produtivos. |

### Arquitetura da Ferramenta (`ferramenta-tcc/`)
A ferramenta é organizada em **4 camadas**:
1. **Orquestração (Marcos 1, 2, 3):** Fluxo macro com gates de aprovação humana.
2. **Agentes-etapa (6):** Visão, Elicitação, Análise, SRS, Validação, Gerência.
3. **Sub-agentes transversais (5):** NLP, Implícitos, Conflitos, Recomendação, Visualização.
4. **Skills (~30):** Implementações específicas de técnicas de ER (ex: `vision-box-conductor`, `entrevista-estruturada`).

---

## 🛠️ Desenvolvimento e Convenções

### Convenções Críticas (Diretiva D1)
**Lista Negra de Jargão:** Nunca use termos técnicos de ER em prompts para o usuário final.
- ❌ Requisito Funcional → ✅ "O que o produto precisa fazer"
- ❌ Stakeholder → ✅ "Pessoa envolvida"
- ❌ Elicitação → ✅ "Levantamento" / "Descoberta"

### Regras de Implementação
- **Estado:** O estado é persistido no **sistema de arquivos** (`marco-1/`, `marco-2/`, etc.). Agentes devem ler o disco para inferir o progresso (`detection-based recovery`).
- **Skills:** Devem possuir frontmatter `name` e `description` para autodetecção pelo Gemini CLI.
- **Catálogos Seed:** Localizados em `ferramenta-tcc/catalogos-seed/`. A ferramenta deve ler estes arquivos, não a bibliografia em `referencias/`.

---

## 🧪 Como Testar

Atualmente, não há uma suite de testes automatizados. A validação é feita via **Testes E2E Manuais** no Gemini CLI.

1. **Localização:** `ferramenta-tcc/tests/marco-1/` (atualmente focado no Marco 1).
2. **Processo:**
   - Carregue o agente correspondente (ex: `visao-produto`).
   - Siga um dos casos em `casos.md`.
   - Valide o resultado contra o `checklist.md`.
3. **Critério de Sucesso:** 100% de conformidade no checklist e geração correta dos artefatos em `marco-1/`.

---

## 📄 Documentos Essenciais

- **Arquitetura Completa:** `docs/planejamento/3 - Arquitetura da Ferramenta.md`
- **Decisões de Design:** `docs/planejamento/1 - Decisões Tomadas.md`
- **Roadmap Atualizado:** `docs/planejamento/ROADMAP.md`
- **Manual do `ask_user`:** `sandbox/ask_user_instructions.md`

---

> **Nota:** Este arquivo `GEMINI.md` serve como instrução base para o agente Gemini CLI operar neste workspace.
