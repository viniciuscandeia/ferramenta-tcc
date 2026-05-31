# Catálogo: Requisitos Não-Funcionais Típicos

Usado pelo sub-agente **Implícitos** para identificar RNFs que o usuário não mencionou.
Baseado em FURPS+ (Grady, 1992) e ISO/IEC 25010 (Livro SON cap. 5) + categorias do Material Dani (`seminario requisitos nao funcionais.md` e `requisitos_de_usabilidade-1.md`).

Critérios de qualidade do IREB §3.8 para verificar RNFs: Adequado, Necessário, Sem ambiguidade, Completo, Compreensível, Verificável.
Referência normativa IREB: `normas/cpre_foundationlevel_handbook_BR_v1.2.md` §3.8.
Todo RNF deve ser **verificável** — "deve ser rápido" não é RNF válido; "tempo de resposta < 2s em P95" é.

---

## Desempenho (Performance)

**Quando está presente:** qualquer sistema com múltiplos usuários simultâneos ou com dados em volume.

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Tempo de resposta | < 2s para 95% das requisições em condições normais | "Quanto tempo o usuário pode esperar por uma resposta do sistema sem ficar frustrado?" |
| Capacidade de usuários simultâneos | Suportar 500 usuários simultâneos sem degradação | "Quantas pessoas vão usar o sistema ao mesmo tempo no pico?" |
| Throughput | Processar 100 transações por segundo | "Existe algum processamento em volume — tipo importar muitos dados de uma vez?" |
| Tempo de carregamento de página | < 3s em conexão 4G | "Os usuários vão acessar em conexões lentas (mobile, interior)?" |
| Tamanho de dados suportado | Suportar arquivos de até 50MB por upload | "Vão ser enviados arquivos grandes? De qual tamanho?" |

---

## Disponibilidade e Confiabilidade

**Quando está presente:** sistemas críticos para o negócio, com usuários que dependem do sistema para trabalhar.

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Disponibilidade (uptime) | 99,5% de disponibilidade — máx. 3,6h de downtime/mês | "O sistema pode ficar fora do ar? Por quanto tempo isso seria aceitável?" |
| Janela de manutenção | Manutenção apenas às madrugadas de domingo | "Tem algum horário em que o sistema NUNCA pode ficar fora do ar?" |
| Tolerância a falhas | Sistema continua funcionando se um componente falhar | "Se alguma parte do sistema parar, o resto deve continuar funcionando?" |
| Backup e recuperação | Backup diário; recuperação em até 4h (RPO/RTO) | "Em caso de desastre (servidor queima, banco corrompe), em quanto tempo o sistema precisa voltar?" |
| Dados sem perda | Zero perda de transações após confirmação | "É aceitável perder alguma transação confirmada em caso de falha?" |

---

## Segurança (Security)

**Quando está presente:** qualquer sistema com dados pessoais, financeiros ou sensíveis — obrigatório para LGPD.

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Autenticação forte | Senha mínima 8 chars + maiúscula + número; suporte a 2FA | "Existem áreas do sistema que só pessoas autorizadas podem acessar?" |
| Autorização por papel | Usuário A não pode ver dados do usuário B | "Um usuário pode ver ou alterar dados de outro usuário?" |
| Criptografia em trânsito | HTTPS/TLS 1.2+ obrigatório | "O sistema vai funcionar pela internet? (se sim, HTTPS é obrigatório)" |
| Criptografia em repouso | Senhas armazenadas com bcrypt/Argon2; dados sensíveis com AES-256 | "Existem dados muito sensíveis que precisam estar protegidos mesmo se o banco for comprometido?" |
| Conformidade LGPD | Consentimento registrado, portabilidade e exclusão de dados disponíveis | "O sistema vai guardar dados pessoais de brasileiros? (CPF, email, endereço, saúde, etc.)" |
| Proteção contra ataques | Rate limiting, proteção CSRF, validação de entrada, SQL injection | "O sistema vai ser exposto na internet pública?" |
| Auditoria de acesso | Log de todos os acessos a dados sensíveis | "Precisa saber quem acessou dados confidenciais e quando?" |
| Bloqueio após tentativas falhas | Bloquear conta após 5 tentativas erradas de senha | "É necessário proteger contra adivinhação de senhas (brute force)?" |

---

## Usabilidade (Usability)

Baseado nas 5 dimensões de Nielsen: aprendizado, eficiência, memorização, erros, satisfação.
Fonte: Material Dani `requisitos_de_usabilidade-1.md`.

**Quando está presente:** sistemas usados por leigos ou com alta frequência de uso.

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Aprendizagem | Novo usuário realiza tarefa principal em < 5 min sem treinamento | "Os usuários vão precisar de treinamento para usar o sistema, ou ele deve ser intuitivo?" |
| Acessibilidade WCAG | Conformidade WCAG 2.1 nível AA | "Haverá usuários com deficiência visual, auditiva ou motora? (também pode ser exigência legal)" |
| Responsividade / Mobile | Funciona em telas de 320px a 1920px | "Os usuários vão acessar pelo celular, tablet, computador — ou apenas um desses?" |
| Suporte a múltiplos idiomas | Interface em PT-BR e EN; textos externalizados | "O sistema vai ser usado por pessoas de outros países ou que falam outros idiomas?" |
| Mensagens de erro úteis | Mensagem explica o problema e como corrigir | *(implícito — boas práticas de UX)* |
| Tempo de aprendizado de atalhos | Usuário frequente realiza tarefa principal em < 30s | "Usuários experientes vão usar o sistema muitas vezes por dia?" |

---

## Manutenibilidade

**Quando está presente:** sistemas que vão evoluir após o lançamento (quase sempre).

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Cobertura de testes | ≥ 80% de cobertura de testes unitários | "A equipe vai precisar adicionar funcionalidades novas com frequência após o lançamento?" |
| Documentação de código | README, docstrings, ADRs para decisões críticas | *(implícito — boas práticas)* |
| Tempo de deploy | Deploy em produção em < 30 min | "Com que frequência vai precisar atualizar o sistema em produção?" |
| Monitoramento | Alertas automáticos para erros acima de threshold | "A equipe precisa ser avisada automaticamente quando algo der errado?" |

---

## Portabilidade e Compatibilidade

**Quando está presente:** sistemas web, mobile, ou que precisam rodar em ambientes diferentes.

| RNF | Exemplo verificável | Pergunta-gatilho |
|-----|---------------------|------------------|
| Compatibilidade de browsers | Chrome, Firefox, Safari, Edge — últimas 2 versões | "Em quais navegadores o sistema precisa funcionar?" |
| Compatibilidade mobile | iOS 15+ e Android 11+ | "Em quais versões de iOS e Android o app precisa funcionar?" |
| Compatibilidade de SO (desktop) | Windows 10+, macOS 12+ | "Os usuários vão instalar alguma coisa no computador?" |
| Independência de banco de dados | Migrar de MySQL para PostgreSQL sem reescrita | *(pergunta avançada — relevante em sistemas empresariais)* |

---

## Conformidade Legal e Regulatória

**Quando está presente:** sistemas no Brasil com dados pessoais, financeiros, de saúde ou educacionais.

| RNF | Quando se aplica | Pergunta-gatilho |
|-----|-----------------|------------------|
| LGPD (Lei 13.709/2018) | Qualquer sistema com dados pessoais de brasileiros | "O sistema vai guardar informações pessoais de pessoas?" |
| CFM / ANVISA | Sistemas de saúde | "O sistema é da área da saúde? Envolve prontuários, prescrições ou diagnósticos?" |
| COFEN | Sistemas de enfermagem | *(idem saúde)* |
| MEC / INEP | Sistemas educacionais que emitem diplomas ou históricos | "O sistema vai emitir documentos oficiais de educação (histórico, diploma, certificado)?" |
| Código de Defesa do Consumidor | E-commerce e serviços ao consumidor | "O sistema vai vender produtos ou serviços para consumidores finais?" |
| PCI-DSS | Sistemas que processam cartão de crédito | "O sistema vai guardar ou processar dados de cartão de crédito diretamente?" |