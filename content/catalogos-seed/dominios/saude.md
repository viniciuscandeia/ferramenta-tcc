# Domínio: Saúde

Usado pelo sub-agente **Recomendação** para sugerir requisitos específicos de sistemas de saúde.
Inclui: prontuário eletrônico (PEP), sistemas de agendamento médico, telemedicina, gestão hospitalar/ambulatorial, sistemas de laboratório e farmácia hospitalar.

---

## Stakeholders típicos do domínio

| Stakeholder | Papel | Necessidades |
|---|---|---|
| Paciente | Beneficiário dos serviços de saúde | Agendar e cancelar consultas, acessar histórico e resultados, receber lembretes, comunicar-se com a equipe |
| Médico / Profissional de Saúde | Atende, diagnostica e prescreve | Registrar evolução clínica, emitir prescrições digitais, solicitar exames, visualizar histórico completo do paciente |
| Enfermeiro / Técnico de Enfermagem | Executa cuidados e registra dados | Lançar sinais vitais e medicações administradas, acompanhar prescrições, registrar evolução de enfermagem |
| Recepcionista / Atendimento | Gerencia agendas e cadastros | Cadastrar pacientes, agendar consultas, verificar convênio, controlar fila de espera |
| Gestor da Unidade | Administra a unidade de saúde | Relatórios de produção, gestão de equipe, controle financeiro, indicadores de qualidade |
| Operadora de Saúde / Convênio | Autoriza e paga procedimentos | Receber guias TISS, autorizar procedimentos, controlar cobertura, processar faturamento |
| Laboratório / Clínica de Imagem | Realiza e devolve resultados de exames | Receber pedidos, registrar resultados, transmitir laudos ao solicitante |
| Farmácia Hospitalar | Dispensação e controle de medicamentos | Vincular dispensação à prescrição, controlar estoque, alertar sobre interações e vencimentos |
| ANS / MS / Vigilância Sanitária | Regulação e fiscalização do setor | Receber dados epidemiológicos, verificar conformidade, acessar notificações obrigatórias |
| DPO / Encarregado de Dados (LGPD) | Conformidade no tratamento de dados sensíveis de saúde | Auditar consentimentos, processar solicitações de acesso e exclusão, registrar incidentes |

---

## Requisitos Funcionais específicos

### Cadastro e Agendamento

- Cadastrar paciente com: nome completo, CPF, data de nascimento, endereço, telefone, email, contato de emergência e alergias conhecidas
- Vincular convênio/plano de saúde ao cadastro com número de carteirinha e validade
- Agendar consulta por especialidade, médico, data e unidade de saúde
- Gerenciar lista de espera automaticamente quando agenda cheia
- Cancelar e reagendar consultas com liberação do horário para outros pacientes
- Enviar lembrete de consulta por SMS e/ou email com opção de confirmação
- Registrar chegada do paciente e atualizar status da fila em tempo real

### Prontuário Eletrônico do Paciente (PEP)

- Registrar evolução clínica no formato SOAP (Subjetivo, Objetivo, Avaliação, Plano)
- Registrar diagnósticos codificados em CID-10 e CID-11 com busca por código ou nome
- Emitir prescrição médica com medicamento, dose, via, frequência e duração; assinatura digital ICP-Brasil obrigatória
- Registrar alergias e alertas clínicos com destaque visual em todas as telas do paciente
- Registrar e visualizar série histórica de medidas antropométricas e sinais vitais (peso, altura, IMC, PA, temperatura, SpO2, glicemia)
- Histórico completo e ordenado de consultas, internações, cirurgias e procedimentos
- Registro e controle do calendário de imunizações com alertas de vacinas em atraso
- Anexar documentos externos (laudos em PDF, imagens DICOM, declarações)
- Controle de acesso por papel: médico vê o prontuário completo; enfermagem vê parte de evolução e prescrição; recepção não acessa dados clínicos

### Telemedicina

- Videoconsulta integrada com sala virtual segura (criptografada)
- Prontuário acessível durante a teleconsulta sem troca de tela
- Prescrição digital em telemedicina com assinatura ICP-Brasil (conforme CFM 2.314/2022)
- Gravação opcional da consulta com consentimento explícito do paciente
- Relatório de teleconsulta gerado automaticamente ao término

### Pedidos e Resultados de Exames

- Solicitar exames laboratoriais e de imagem vinculados ao prontuário com CID justificativo
- Transmitir pedido eletronicamente ao laboratório/clínica conveniado(a)
- Receber resultado e laudo e anexar automaticamente ao prontuário do paciente
- Notificar o médico solicitante quando resultado estiver disponível
- Destacar resultados críticos (valores fora do limite de alarme) com alerta ativo

### Faturamento TISS (Convênios)

- Gerar guia eletrônica TISS para consultas, internações e SADT (Serviço de Apoio ao Diagnóstico e Terapia)
- Solicitar autorização eletrônica ao convênio com retorno de código de autorização
- Registrar e controlar glosas recebidas com classificação por tipo
- Fluxo de recurso de glosa com envio de documentação complementar
- Relatórios de produção médica e financeira por período, especialidade e convênio

### Farmácia Hospitalar

- Controle de estoque de medicamentos com lote, validade e localização física
- Dispensação de medicamento vinculada à prescrição eletrônica — bloquear dispensação sem prescrição
- Alertar sobre interação medicamentosa ao dispensar ou ao prescrever
- Alertar sobre medicamentos próximos do vencimento
- Controle especial de psicotrópicos e antimicrobianos com rastreabilidade de receita (ANVISA RDC 20/2011)

---

## Requisitos Não-Funcionais específicos

| RNF | Detalhamento | Por quê é específico deste domínio |
|---|---|---|
| Privacidade e consentimento (LGPD art. 11) | Dado de saúde é dado sensível — base legal restrita (consentimento explícito ou saúde pública); finalidade e retenção documentados | Saúde é categoria especial de dado pessoal; violação gera sanção máxima da ANPD |
| Auditoria irrevogável | Trilha de auditoria de toda visualização, criação e alteração de prontuário; não pode ser apagada; retida por mínimo 20 anos | CFM 1.821/2007 exige que o PEP registre quem acessou, quando e o quê |
| Alta disponibilidade | 99,9% de uptime; failover automático em <30s; sistema crítico em emergências | Indisponibilidade pode impedir acesso a alergias ou prescrições em situação de risco de vida |
| Interoperabilidade HL7 FHIR / RNDS | API FHIR R4 para troca de dados; conector com RNDS (Rede Nacional de Dados em Saúde) | Portaria 1.434/2020 exige que estabelecimentos enviem dados à RNDS; padrão nacional de interoperabilidade |
| Retenção e backup | Backup diário com retenção mínima de 20 anos; backup imutável (não editável) | CFM 1.821/2007 — prontuário eletrônico deve ser guardado por pelo menos 20 anos |
| Criptografia | TLS 1.3 em trânsito; AES-256 em repouso para dados do prontuário | Dado sensível; exigência implícita da LGPD e boas práticas do CFM |
| Performance | Prontuário do paciente carregado em <3s; pedido de exame transmitido em <5s | Médico atendendo não pode esperar; lentidão gera bypass do sistema |
| Controle de acesso granular | RBAC (papel) + ABAC (contexto, ex.: só médico que atendeu pode ver prontuário de terceiros) | Sigilo médico (CFM; Código de Ética Médica art. 89) — acesso ao prontuário é restrito ao profissional responsável |
| Assinatura digital | ICP-Brasil obrigatória para prescrições e laudos eletrônicos | CFM 1.821/2007; Medida Provisória 2.200-2/2001 — validade jurídica do documento eletrônico |

---

## Restrições específicas

- **CFM 1.821/2007:** define padrões técnicos para PEP; exige autenticação do profissional, trilha de auditoria e retenção mínima de 20 anos.
- **CFM 2.314/2022:** regulamenta telemedicina; exige prontuário, prescrição assinada digitalmente via ICP-Brasil e consentimento do paciente para gravação.
- **Lei 13.787/2018:** dispõe sobre a digitalização e a utilização de sistemas informatizados para a guarda, o armazenamento e o manuseio de prontuário de paciente.
- **ANS — Padrão TISS:** tabela de procedimentos, guias eletrônicas e protocolos de comunicação com operadoras são padronizados pela ANS (RN 305/2012 e atualizações); implementação obrigatória para faturamento a convênios.
- **TUSS:** Terminologia Unificada da Saúde Suplementar — codificação dos procedimentos para faturamento TISS.
- **ANVISA RDC 20/2011:** controle especial de psicotrópicos e antimicrobianos — rastreabilidade de receita e dispensação obrigatória.
- **ANVISA RDC 302/2005:** regulamento técnico para laboratórios clínicos — sistema de LIMS deve seguir requisitos de rastreabilidade analítica.
- **LGPD art. 11:** dados de saúde são dados pessoais sensíveis — exigem consentimento específico, finalidade declarada, minimização e retenção justificada; violação tem sanção máxima.
- **RNDS / DataSUS (Portaria 1.434/2020):** estabelecimentos de saúde devem enviar dados à Rede Nacional de Dados em Saúde; API FHIR é o padrão de integração exigido.
- **Assinatura digital ICP-Brasil (MP 2.200-2/2001):** prescições médicas eletrônicas e laudos têm validade jurídica somente com certificado digital ICP-Brasil do profissional responsável.
- **Sigilo médico (Código de Ética Médica, art. 73-79):** o sistema não pode expor dados de pacientes a terceiros sem consentimento ou obrigação legal; acesso de equipe deve ser vinculado ao atendimento.
