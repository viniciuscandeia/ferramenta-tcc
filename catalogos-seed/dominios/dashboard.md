# Domínio: Dashboard / BI / Analytics

Usado pelo sub-agente **Recomendação** para sugerir requisitos específicos de sistemas de visualização de dados.
Inclui: dashboards executivos, ferramentas de BI (Business Intelligence), plataformas de analytics, sistemas de relatórios operacionais e portais de dados.

---

## Stakeholders típicos do domínio

| Stakeholder | Papel | Necessidades |
|---|---|---|
| Analista de Dados / Analista de BI | Constrói e mantém relatórios e visualizações | Criar e editar dashboards, conectar a fontes de dados, configurar cálculos e métricas, versionar trabalho |
| Gestor / Diretor / Executivo | Consome KPIs para tomada de decisão | Visualizar indicadores de forma clara, filtrar por período e área, receber relatórios automáticos, alertas de anomalias |
| Engenheiro de Dados / Plataforma BI | Mantém pipelines e integração de dados | Configurar conexões, gerenciar ETL/ELT, monitorar freshness e qualidade dos dados, controlar performance de queries |
| TI / DevOps | Infraestrutura e segurança da plataforma | Gestão de usuários e permissões, monitoramento de uso e performance, controle de versões da plataforma |
| DPO / Encarregado de Dados | Conformidade LGPD nos dados expostos | Auditar quais dados pessoais são exibidos e por quem, garantir minimização, controlar exportações em massa |
| Auditor / Compliance | Rastrear acesso e uso de dados sensíveis | Log de quem visualizou quais dashboards e dados, e quando; relatório de acessos para auditoria |
| Time de Produto | Monitora métricas de produto e UX | Acompanhar funil, retenção, NPS, bugs por versão; criar dashboards de feature flags e experimentos |

---

## Requisitos Funcionais específicos

### Visualizações

- Gráficos de barra (simples, empilhada, agrupada), linha, área, pizza/donut, scatter, mapa de calor, funil, cascata (waterfall) e gauge/velocímetro
- Tabela interativa com ordenação por coluna, filtro inline e paginação
- KPI card com valor atual, meta, variação percentual e sparkline (mini-gráfico de tendência)
- Mapa geográfico cloroplético com dados por país, estado ou município
- Drill-down por hierarquia (ex.: Região → Estado → Cidade → Loja)
- Drill-through: clicar em um ponto abre detalhe em tela ou painel lateral

### Filtros e Interação

- Filtros globais de dashboard que se aplicam a todos os componentes simultaneamente
- Filtros locais por widget, independentes dos globais
- Seletor de período com opções rápidas (hoje, 7d, 30d, trimestre, ano) e período customizado com calendário
- Cross-filtering: selecionar um elemento em um gráfico filtra automaticamente os demais
- Modo exploração (interativo) e modo apresentação (somente leitura, sem controles)
- Barra de busca para localizar dashboards, relatórios e métricas por nome

### Relatórios e Export

- Exportar visualização individual nos formatos PNG, SVG e PDF
- Exportar dados brutos de qualquer componente em CSV e XLSX
- Gerar relatório PDF do dashboard completo com logotipo, cabeçalho, rodapé e data de geração
- Agendar envio automático de relatório por email (diário, semanal, mensal, customizado)
- Integração de envio via Slack, Microsoft Teams ou webhook genérico
- Histórico de relatórios gerados com link de download por 30 dias

### Alertas e Monitoramento de Dados

- Criar alerta por threshold simples (ex.: taxa de erro > 5% → notificar)
- Criar alerta por variação percentual relativa (ex.: receita cai > 20% semana a semana)
- Detecção automática de anomalias com alerta configurável por sensibilidade
- Canal de notificação por email, Slack, webhook ou push no app
- Histórico de alertas disparados com status (disparado, reconhecido, resolvido)
- Silenciamento temporário de alerta (snooze) com prazo

### Colaboração e Compartilhamento

- Adicionar comentários por dashboard ou por widget específico
- Inserir anotações em pontos específicos de gráficos de linha/barra (ex.: "campanha lançada aqui")
- Compartilhar dashboard por link público (sem login) ou autenticado (com permissão)
- Incorporar (embed) visualização em site externo via iframe com token de acesso
- Permissões por usuário ou grupo: viewer (somente leitura), editor (cria/edita), admin (configurações)
- Row-level security: cada usuário vê somente os dados da sua região, filial ou segmento

### Gestão de Fontes de Dados

- Conectar a bancos relacionais (PostgreSQL, MySQL, SQL Server, BigQuery, Snowflake, Redshift)
- Conectar a APIs REST com autenticação (Bearer token, API key, OAuth 2.0)
- Conectar a arquivos (CSV, XLSX, Google Sheets) com atualização automática
- Configurar refresh de dados: tempo real (streaming), micro-batch (5-15 min), batch diário
- Refresh manual sob demanda com feedback de progresso
- Exibir horário e status da última atualização em cada dashboard

### Versionamento de Dashboards

- Histórico automático de versões com autor, data e descrição da alteração
- Restaurar versão anterior com um clique
- Publicar nova versão sem desligar a versão atual (deploy sem downtime)
- Clonar dashboard existente como base para um novo

---

## Requisitos Não-Funcionais específicos

| RNF | Detalhamento | Por quê é específico deste domínio |
|---|---|---|
| Performance de carregamento | Dashboard inicial carregado em <5s; query interativa com resposta em <3s para 95% dos casos | Executivo impaciente: dashboard que demora é ignorado; lentidão destrói adoção |
| Escalabilidade de usuários simultâneos | Suportar >100 usuários simultâneos sem degradação perceptível | Reuniões matinais: todos abrem o dashboard ao mesmo tempo |
| Granularidade de permissões | Row-level security (dados por usuário/grupo) e column-level security (ocultar campos sensíveis) | Gestor regional não pode ver dados de outra região; CPF não deve aparecer para analistas sem necessidade |
| Auditoria de acesso | Log imutável de quem visualizou quais dashboards, quais filtros aplicou e quais dados exportou | LGPD + compliance: precisa provar quem viu o quê em caso de incidente de dados |
| Cache com invalidação correta | Queries em cache invalidadas automaticamente após cada refresh do ETL; evitar stale data silencioso | Cache stale faz gestor decidir com dado errado sem perceber — risco de negócio |
| Freshness declarada | SLA de freshness de cada dataset exposto ao usuário (ex.: "atualizado há 3h"); alerta quando fora do SLA | Dado de ontem apresentado como "hoje" induz decisão errada; usuário precisa saber a age do dado |
| Alta disponibilidade | 99,9% uptime no horário comercial (07h–22h nos dias úteis) | Reuniões de resultado ocorrem em horário comercial; indisponibilidade nesse janela é crítica |
| Segurança em exportações | Log de toda exportação em massa; notificação ao DPO quando exportação supera N linhas de dado pessoal | LGPD art. 18: exportação em massa equivale a portabilidade — requer controle e rastreabilidade |

---

## Restrições específicas

- **LGPD — minimização (art. 6°, III):** dashboards devem expor somente os dados pessoais estritamente necessários para a finalidade declarada; proibido agregar campos sensíveis (CPF, endereço, saúde) sem necessidade justificada.
- **LGPD art. 18 — direitos do titular:** exportação em massa de dados pessoais equivale a portabilidade; o sistema deve controlar quem pode exportar e registrar cada ocorrência; volumes acima de limiares definidos devem notificar o DPO.
- **Governança de dados — lineage e catálogo:** dashboards em organizações com obrigações regulatórias (saúde, financeiro, governo) exigem rastreabilidade da origem do dado (lineage); sistema deve expor, por dataset, de qual fonte veio e quando foi processado.
- **SLA do data warehouse subjacente:** o RNF de freshness é limitado pelo pipeline upstream (ETL/ELT); o sistema deve exibir a latência real e não prometer dados mais frescos do que a infraestrutura entrega.
- **Domínios regulados (herança de restrições):** dashboards sobre dados de saúde herdam restrições do CFM/LGPD art. 11; dashboards financeiros herdam BACEN/CVM; dashboards de governo herdam a Lei de Acesso à Informação (LAI, 12.527/2011).
- **PCI-DSS — mascaramento:** se o dashboard exibe números de cartão de crédito ou dados de transação, deve mascarar (ex.: exibir apenas os últimos 4 dígitos); não armazenar PAN em cache de query.
- **Lei de Acesso à Informação (LAI, 12.527/2011):** para órgãos públicos, métricas operacionais podem ter obrigação de transparência ativa — sistema deve ter mecanismo de publicação pública de dashboards selecionados.
- **Retenção de logs de acesso:** logs de auditoria (quem viu o quê) devem ser retidos por prazo mínimo compatível com o domínio do negócio (em geral 5 anos para dados financeiros; 20 anos para dados de saúde); não devem ser editáveis pelo administrador da plataforma.
