# Conceitos: Qualidade e Validação

Este guia define os critérios para garantir que os requisitos levantados sejam úteis, precisos e prontos para o desenvolvimento.

---

## 1. Critérios de Qualidade (IREB §3.8)
Cada requisito deve ser avaliado individualmente:
- **Adequado, Necessário, Sem Ambiguidade, Completo, Compreensível e Verificável.**
- **Dica:** Use o acrônimo **SMART** para requisitos de negócio e **INVEST** para User Stories.

## 2. Verificação vs. Validação (V&V)
- **Verificação:** "Estamos construindo o documento corretamente?" (Consistência interna, padrões de escrita, ausência de erros técnicos).
- **Validação:** "Estamos construindo o documento certo?" (Atende aos desejos do usuário?).

## 3. Técnicas de Revisão Técnica
A ferramenta deve aplicar processos de revisão antes de finalizar um marco:
- **Walkthrough (Passagem):** O agente explica o requisito para o usuário em linguagem simples para validar o fluxo.
- **Inspeção de Fagan (Checklist):** Verificação rigorosa contra defeitos comuns (ambiguidade, falta de RNF, contradição).
- **Leitura em Perspectiva:** Analisar o requisito sob o olhar de diferentes atores (ex: Como um desenvolvedor leria isso? E um testador?).

## 4. Rastreabilidade Bidirecional
Crucial para a gerência de requisitos:
- **Forward (Para frente):** Do objetivo de negócio para o requisito funcional e para o código/teste.
- **Backward (Para trás):** De um requisito específico de volta para a sua origem (quem pediu e por quê?).
- **Impacto:** Ajuda a evitar o "Scope Creep" (funcionalidades inúteis que não ligam a nenhum objetivo de negócio).

## 5. Como Identificar Defeitos de Requisitos
O agente deve atuar como um revisor crítico, buscando por:
- **Omissão:** O que está faltando? (Ex: Esqueceu de falar como recupera a senha).
- **Contradição:** O requisito A diz "X", o requisito B diz "não-X".
- **Superespecificação (Gold Plating):** Funcionalidade complexa que o usuário não pediu, mas a IA sugeriu.
- **Inexequibilidade:** Requisitos que não podem ser construídos com o tempo/tecnologia disponível.

---

**Regra Final:** Um requisito só é considerado "Pronto" (Definition of Done) quando passa pela validação técnica (IA) e pela validação de negócio (Usuário).
