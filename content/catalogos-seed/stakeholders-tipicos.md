# Catálogo: Stakeholders Típicos

Usado pelo sub-agente **Implícitos** para identificar stakeholders que o usuário não mencionou.
Para cada stakeholder: quando aparece, necessidades típicas e pergunta-gatilho para confirmar com o usuário.

Fonte principal: Livro 2 (planilha de stakeholders), Livro SON cap. 6, Alexander, I. & Robertson, S. "Understanding Project Sociology by Modeling Stakeholders" (2004) IEEE Software 21(1) pp. 23-27 [Onion Model], IREB CPRE Foundation Level §3.1.

---

## Internos ao sistema (usuários diretos)

### Administrador do Sistema
**Quando está presente:** quase sempre que o sistema tem usuários gerenciados (login, papéis, permissões).
**Necessidades típicas:** criar/editar/desativar contas de usuário, resetar senhas, configurar o sistema, visualizar relatórios de uso e acesso, gerenciar papéis e permissões.
**Pergunta-gatilho:** "Haverá alguém responsável por gerenciar os usuários e as configurações do sistema? Quem seria essa pessoa?"

### Usuário Final (papel principal)
**Quando está presente:** sempre — é o beneficiário direto da funcionalidade principal.
**Necessidades típicas:** realizar a tarefa principal do sistema de forma simples e rápida, acessar pelo dispositivo de preferência, ter histórico das suas ações.
**Pergunta-gatilho:** "Quem vai usar o sistema no dia a dia para realizar as tarefas principais? Como essa pessoa costuma usar tecnologia — é familiarizada com apps ou prefere algo mais simples?"

### Usuário com Papel Diferenciado (moderador, revisor, aprovador)
**Quando está presente:** sistemas com fluxo de aprovação, publicação de conteúdo, workflows.
**Necessidades típicas:** revisar e aprovar itens, devolver com comentários, ver fila de pendências.
**Pergunta-gatilho:** "Existe alguma etapa em que alguém precisa revisar ou aprovar o que outro usuário fez antes de seguir em frente?"

### Equipe de Suporte / Atendimento
**Quando está presente:** sistemas com base de usuários que podem ter problemas — quase sempre em produtos públicos.
**Necessidades típicas:** visualizar dados de um usuário para diagnóstico, resetar senhas, registrar e rastrear chamados, acessar histórico de ações do usuário.
**Pergunta-gatilho:** "Se um usuário tiver um problema com o sistema, quem vai ajudá-lo? Essa equipe precisará de acesso especial para investigar?"

### Equipe de TI / DevOps
**Quando está presente:** qualquer sistema que precise de monitoramento, deploy e manutenção.
**Necessidades típicas:** acesso a logs, métricas de desempenho, alertas de falhas, ferramentas de deploy e rollback.
**Pergunta-gatilho:** "Quem vai manter o sistema no ar e fazer atualizações? Essa equipe vai precisar de painéis de monitoramento ou alertas automáticos?"

---

## Externos ao sistema

### Cliente / Consumidor Final
**Quando está presente:** sistemas de e-commerce, serviços, portais de auto-atendimento.
**Necessidades típicas:** navegar, buscar, comprar/contratar, acompanhar pedido/solicitação, obter suporte.
**Pergunta-gatilho:** "O sistema será usado por clientes externos à sua organização? Eles vão acessar sem precisar de treinamento?"

### Fornecedor / Parceiro
**Quando está presente:** sistemas de marketplace, logística, cadeia de suprimentos, integração B2B.
**Necessidades típicas:** cadastrar ofertas/produtos, receber pedidos, atualizar estoque, emitir notas fiscais, acompanhar pagamentos.
**Pergunta-gatilho:** "Terão empresas ou pessoas de fora que vão fornecer produtos, serviços ou dados para o sistema?"

### Responsável Legal (p/ menores de idade)
**Quando está presente:** sistemas educacionais com alunos menores, aplicativos infantis.
**Necessidades típicas:** acompanhar progresso do dependente, receber notificações, autorizar uso.
**Pergunta-gatilho:** "O sistema será usado por crianças ou adolescentes? Haverá pais ou responsáveis que precisam acompanhar o uso?"

---

## Regulatórios e de conformidade

### Auditor / Fiscal
**Quando está presente:** sistemas financeiros, de saúde, educação pública, governo.
**Necessidades típicas:** acesso a logs de auditoria completos, relatórios de conformidade, rastreabilidade de todas as ações.
**Pergunta-gatilho:** "Existe alguma necessidade de comprovar para auditores ou fiscais o que foi feito no sistema? Tipo relatórios para a Receita Federal, vigilância sanitária ou órgão regulador?"

### DPO / Encarregado de Dados (LGPD)
**Quando está presente:** qualquer sistema que colete, processe ou armazene dados pessoais de brasileiros (Lei 13.709/2018).
**Necessidades típicas:** visualizar e exportar dados pessoais por titular, registrar consentimentos, processar solicitações de exclusão/portabilidade, relatório de incidentes.
**Pergunta-gatilho:** "O sistema vai guardar informações pessoais das pessoas, como nome, CPF, endereço, email ou localização? Quem vai ser o responsável por garantir que isso está dentro da LGPD?"

---

## Indiretos

### Gestor / Patrocinador do Projeto
**Quando está presente:** sempre — é quem aprova o investimento e define prioridades.
**Necessidades típicas:** relatórios gerenciais, dashboards de KPIs, visibilidade do ROI.
**Pergunta-gatilho:** "Quem na sua organização vai acompanhar se o sistema está gerando resultados? Essa pessoa vai precisar de relatórios ou painéis para isso?"

### Analista de Negócios / Produto
**Quando está presente:** organizações com área de produto ou negócios separada da TI.
**Necessidades típicas:** definir e acompanhar funcionalidades, analisar uso, configurar regras de negócio.
**Pergunta-gatilho:** "Tem alguém que vai definir como o sistema deve evoluir depois que for lançado — tipo um gerente de produto ou analista de negócios?"