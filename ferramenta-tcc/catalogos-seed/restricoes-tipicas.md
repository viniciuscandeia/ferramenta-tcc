# Catálogo: Restrições Típicas

Usado pelo sub-agente **Implícitos** para identificar restrições que o usuário não mencionou.
Restrições limitam o espaço de solução além do que seria necessário para atender funcionais e qualidade (definição IREB §1.1).
Diferente de RNF: restrição impõe uma escolha; RNF é uma qualidade mensurável.

Fonte: IREB CPRE §1.1, Livro SON cap. 5.

---

## Legais e Regulatórias (Brasil)

| Restrição | Obrigação | Pergunta-gatilho |
|-----------|-----------|------------------|
| LGPD (Lei 13.709/2018) | Consentimento explícito para coleta; direito de acesso, portabilidade e exclusão; notificação de incidentes em 72h à ANPD | "O sistema coleta dados pessoais? (nome, email, CPF, endereço, localização, saúde, etc.)" |
| COPPA / Marco Civil (menores) | Consentimento dos pais/responsáveis para menores de 12 anos; proibição de coleta de dados sem autorização | "Menores de 18 anos vão usar o sistema?" |
| NF-e (SEFAZ) | Emissão de nota fiscal eletrônica conforme leiaute SEFAZ para transações comerciais | "O sistema vai realizar vendas de produtos ou prestação de serviços tributáveis?" |
| eSocial / SPED | Integração com sistemas do governo para folha de pagamento, contabilidade | "O sistema vai gerenciar folha de pagamento ou contabilidade?" |
| Resolução CFM 2314/2022 | Prontuário eletrônico do paciente (PEP) deve seguir padrões do CFM | "É um sistema de saúde que guarda registros médicos?" |

---

## Técnicas (Escolhas impostas externamente)

| Restrição | Descrição | Pergunta-gatilho |
|-----------|-----------|------------------|
| Linguagem/Framework obrigatório | "Deve ser em Python" ou "Deve usar React" — definido por equipe ou cliente | "A equipe já tem uma tecnologia definida que o sistema DEVE usar?" |
| Banco de dados obrigatório | PostgreSQL, MySQL, Oracle — pode ser exigência de TI ou licença existente | "A empresa já tem um banco de dados contratado que o sistema deve usar?" |
| Infraestrutura definida | Deve rodar na AWS, Azure, GCP, ou no servidor on-premise da empresa | "Já tem definido onde o sistema vai rodar — nuvem específica ou servidor próprio?" |
| Integração obrigatória com legado | Deve se integrar com sistema ERP/CRM/financeiro já existente | "O sistema precisa se comunicar com algum sistema que a empresa já tem hoje?" |
| Restrição de hardware | Deve rodar em equipamentos específicos (ex.: terminais com 2GB RAM, impressoras fiscais) | "O sistema vai rodar em equipamentos especiais ou com recursos limitados?" |
| Protocolo de comunicação | Deve usar SOAP/REST/GraphQL — definido por parceiro externo | "Tem parceiros externos que definem como a comunicação com eles deve funcionar?" |
| Single Sign-On (SSO) | Deve usar o provedor de identidade da empresa (AD, LDAP, Okta) | "A empresa já tem um sistema de login central que todos os sistemas devem usar?" |

---

## Organizacionais e de Processo

| Restrição | Descrição | Pergunta-gatilho |
|-----------|-----------|------------------|
| Prazo fixo | Data de lançamento não pode ser alterada (evento, contrato, regulação) | "Existe uma data que o sistema PRECISA estar no ar, independentemente do escopo?" |
| Orçamento máximo | Custo total de desenvolvimento não pode ultrapassar X | "Existe um limite de investimento definido para o projeto?" |
| Equipe definida | Deve ser desenvolvido com a equipe atual, sem contratar externos | "Já tem equipe de desenvolvimento definida? Pode contratar mais pessoas se necessário?" |
| Metodologia obrigatória | Deve usar Scrum, Kanban, PMBOK — exigência do cliente ou da empresa | "Existe alguma metodologia de gestão de projeto que o cliente ou a empresa exige?" |
| Licença de software | Deve usar apenas software open source, ou apenas software com licença corporativa | "Há alguma restrição sobre que tipo de ferramentas/bibliotecas podem ser usadas (open source, licenciado)?" |
| Política de segurança interna | Deve seguir políticas de TI da empresa (ex.: nenhum dado na nuvem pública, VPN obrigatória) | "A TI da empresa tem alguma política que o sistema deve respeitar (onde os dados ficam, acesso remoto)?" |

---

## De Interface e Integração

| Restrição | Descrição | Pergunta-gatilho |
|-----------|-----------|------------------|
| Padrão visual / Design System | Deve usar a identidade visual da empresa (cores, fontes, componentes) | "Existe um guia de estilo ou design system da empresa que o sistema deve seguir?" |
| API externa obrigatória | Deve consumir API específica de terceiro (ex.: Correios, IBGE, Receita Federal) | "O sistema vai precisar buscar alguma informação de órgãos públicos ou serviços externos obrigatórios?" |
| Formato de arquivo obrigatório | Exportações devem ser em XML no padrão do parceiro X | "O parceiro ou cliente exige que os dados sejam exportados em algum formato específico?" |