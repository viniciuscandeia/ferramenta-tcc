# Catálogo: Requisitos Funcionais Típicos

Usado pelo sub-agente **Implícitos** para identificar RFs que o usuário não mencionou.
Organizado por categoria funcional. Quase todos os sistemas digitais precisam das categorias marcadas com ⭐.

Fonte: Livro SON cap. 7 (técnicas de elicitação), Livro 1 cap. 1-3, Wiegers, K. & Beatty, J. "Software Requirements" 3rd ed. (2013) Microsoft Press, Robertson, J. & Robertson, S. "Mastering the Requirements Process" 3rd ed. (2012) Addison-Wesley (Volere template §8–9).

---

## ⭐ Gestão de Usuários e Acesso (quase universal)

**Quando está presente:** qualquer sistema com mais de um tipo de usuário ou com dados privados.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Cadastro de usuário | Criar conta com dados básicos (nome, email, senha) | "Como uma pessoa nova vai entrar no sistema pela primeira vez?" |
| Login / Autenticação | Acesso com credenciais; sessão com timeout | "Como o usuário vai provar que é ele toda vez que abrir o sistema?" |
| Logout | Encerrar sessão explicitamente | *(implícito — sempre acompanha login)* |
| Recuperação de senha | Fluxo de "esqueci minha senha" via email/SMS | "O que acontece se o usuário esquecer a senha?" |
| Edição de perfil | Atualizar dados pessoais e preferências | "O usuário pode atualizar os próprios dados depois de criar a conta?" |
| Desativação / Exclusão de conta | Encerrar conta definitivamente | "O usuário pode pedir para apagar a própria conta? (obrigatório LGPD)" |
| Controle de papéis e permissões | Usuários com diferentes níveis de acesso | "Todos os usuários vão ver e fazer as mesmas coisas, ou haverá diferentes perfis de acesso?" |
| Autenticação em dois fatores (2FA) | Camada extra de segurança via código | "Para funcionalidades sensíveis (financeiro, saúde), será exigida confirmação extra de identidade?" |

---

## ⭐ Notificações e Comunicação

**Quando está presente:** sistemas com eventos importantes que o usuário precisa saber sobre.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Notificação por email | Avisos, confirmações, alertas enviados por email | "O sistema vai avisar o usuário por email sobre algum evento importante?" |
| Notificação in-app / push | Alertas dentro do próprio sistema ou app | "Haverá avisos que aparecem dentro do sistema, tipo um sininho de notificação?" |
| Notificação por SMS | Para urgências ou usuários sem acesso fácil a email | "Alguma notificação precisa chegar via SMS?" |
| Configuração de notificações | Usuário escolhe quais receber | "O usuário vai poder escolher quais notificações quer receber?" |

---

## ⭐ Auditoria e Rastreabilidade

**Quando está presente:** sistemas com ações irreversíveis, dados sensíveis, múltiplos usuários alterando os mesmos dados.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Log de ações do usuário | Registro de quem fez o quê e quando | "Precisa saber quem fez cada alteração no sistema?" |
| Histórico de alterações | Ver versões anteriores de um registro | "Se alguém alterar um dado importante, dá para ver o que estava antes?" |
| Trilha de auditoria | Log completo e imutável para compliance | "Vai precisar comprovar para auditores todas as ações que aconteceram?" |

---

## Busca e Filtragem

**Quando está presente:** sistemas com listas de itens (produtos, usuários, registros, tarefas).

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Busca por texto | Campo de busca em conteúdo | "O usuário vai precisar encontrar algo digitando palavras-chave?" |
| Filtros e ordenação | Refinar listas por atributo (data, categoria, status) | "O usuário vai precisar filtrar ou ordenar os itens da lista?" |
| Busca avançada | Combinação de múltiplos critérios | "Haverá necessidade de buscas complexas (ex.: todos os pedidos entre datas X e Y, do estado Z)?" |

---

## Relatórios e Exportação

**Quando está presente:** sistemas com dados que precisam ser analisados fora do sistema.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Relatórios pré-definidos | Relatórios com formatos fixos (ex.: relatório mensal) | "Haverá relatórios que o sistema gera automaticamente?" |
| Exportação para Excel/CSV | Download de dados em planilha | "Alguém vai precisar exportar dados para analisar no Excel?" |
| Exportação para PDF | Documentos formatados para impressão ou envio | "Vai precisar gerar documentos em PDF (contratos, recibos, certificados)?" |
| Dashboard / Painel gerencial | Gráficos e indicadores em tempo real | "Alguém vai precisar de um painel visual com gráficos para tomar decisões?" |

---

## Integrações Externas

**Quando está presente:** sistemas que dependem de serviços de terceiros.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Pagamento online | Integração com gateway (Stripe, PagSeguro, Mercado Pago) | "O sistema vai cobrar alguma coisa? Como será feito o pagamento?" |
| Login social | Entrar com Google, Facebook, Apple | "O usuário vai poder entrar com a conta do Google ou outra rede social?" |
| Integração com email marketing | MailChimp, SendGrid, etc. | "Vai ter envio de emails em massa (newsletters, campanhas)?" |
| API para sistemas externos | Expor ou consumir dados de outros sistemas | "Outro sistema vai precisar se conectar a este, ou este vai buscar dados em outro lugar?" |
| Mapas e geolocalização | Google Maps, endereços, raio de entrega | "Tem alguma funcionalidade que depende de localização ou mapa?" |
| Nota Fiscal Eletrônica (NF-e) | Emissão de NF-e para transações comerciais | "O sistema vai realizar vendas ou serviços que exigem emissão de nota fiscal?" |

---

## Gerenciamento de Conteúdo

**Quando está presente:** portais, blogs, sistemas educacionais, marketplaces.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Criação e edição de conteúdo | Editor de texto rico (WYSIWYG) | "Alguém vai publicar textos, artigos ou páginas dentro do sistema?" |
| Upload de arquivos | Imagens, documentos, vídeos | "O usuário vai precisar enviar arquivos para o sistema?" |
| Gerenciamento de mídia | Biblioteca de imagens/vídeos | "Haverá uma área para organizar imagens e vídeos enviados?" |
| Publicação e agendamento | Controlar quando um conteúdo fica visível | "O conteúdo vai direto ao ar ou passa por aprovação/agendamento?" |

---

## Fluxo de Trabalho (Workflow)

**Quando está presente:** sistemas com processos de negócio com etapas sequenciais.

| RF | Descrição | Pergunta-gatilho |
|----|-----------|------------------|
| Criação de solicitação/pedido | Usuário inicia um processo | "Como começa o processo principal do sistema — o usuário abre um pedido, uma solicitação?" |
| Aprovação em etapas | Vários aprovadores em sequência | "Existe alguma etapa que precisa do ok de uma pessoa antes de passar para a próxima?" |
| Devolução com comentários | Reprovação com justificativa | "O que acontece quando alguém reprova uma solicitação — ela volta para quem enviou?" |
| Histórico do fluxo | Rastrear por onde passou e quem aprovou | "Dá para ver todo o caminho que um pedido percorreu até ser aprovado?" |