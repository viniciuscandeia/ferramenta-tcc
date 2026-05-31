# Domínio: Educação / E-learning

Usado pelo sub-agente **Recomendação** para sugerir requisitos específicos do domínio educacional.
Inclui: plataformas de ensino (EAD, LMS), sistemas de gestão escolar/universitária, apps de tutoria, plataformas de cursos.

Fonte: IMS Global Learning Consortium "Learning Management Systems Interoperability" (2020) imsglobal.org; ISO/IEC 19796-1:2005 "IT — Learning, education and training — Quality management"; sistematizado por análise de domínio de plataformas LMS (Moodle, Canvas, Blackboard). Andrade, F. "Engenharia de Requisitos: da demanda ao gerenciamento" (Alura, curso 1777) — cenários de uso.

---

## Stakeholders típicos do domínio

| Stakeholder | Papel | Necessidades |
|---|---|---|
| Aluno / Estudante | Beneficiário principal do ensino | Acessar conteúdo, acompanhar progresso, receber notas, interagir com colegas e professores |
| Professor / Instrutor | Produtor de conteúdo e avaliador | Criar turmas, publicar material, lançar notas, visualizar desempenho da turma, dar feedback |
| Coordenador Pedagógico | Supervisor do processo de ensino | Monitorar desempenho geral, aprovar currículos, gerar relatórios institucionais |
| Secretaria / Administrativo | Gestão de matrículas e documentos | Matricular alunos, emitir históricos e certificados, controlar mensalidades |
| Responsável (para menores) | Acompanhamento de dependente | Ver notas e frequência do filho, receber comunicados, autorizar atividades |
| Tutor / Monitor | Apoio pedagógico aos alunos | Responder dúvidas, corrigir atividades, acompanhar alunos com dificuldade |
| Diretor / Reitor | Gestão estratégica da instituição | Relatórios consolidados, indicadores de desempenho, conformidade regulatória (MEC) |

---

## Requisitos Funcionais específicos

### Gestão de Turmas e Matrículas
- Criar e gerenciar turmas (código, disciplina, professor, período, vagas)
- Matricular e cancelar matrícula de alunos em turmas
- Gerar lista de espera automaticamente quando turma lotada
- Transferir aluno entre turmas

### Conteúdo Didático
- Upload e organização de materiais por módulo/semana (PDF, vídeo, áudio, link)
- Controle de ordem e liberação progressiva de conteúdo (unlock por conclusão)
- Player de vídeo integrado com controle de progresso assistido
- Leitura de PDF embutida

### Avaliações e Notas
- Criar provas, quizzes e trabalhos com prazo e peso
- Correção automática (múltipla escolha) e manual (dissertativa com critérios)
- Lançar e publicar notas; calcular média automaticamente
- Histórico de notas por aluno e por turma
- Controle de frequência / presença (manual ou QR Code)

### Comunicação e Colaboração
- Fórum de discussão por turma ou disciplina
- Chat ou mensagem direta professor ↔ aluno
- Comunicados institucionais (mural, avisos)
- Videoconferência integrada (Zoom/Meet) ou agendamento de aula ao vivo

### Certificados e Documentos
- Emissão de certificado de conclusão com carga horária (PDF com QR Code de validação)
- Emissão de histórico escolar
- Declaração de matrícula
- Validação de autenticidade de certificados por código/QR

### Gamificação (quando aplicável)
- Pontos e badges por conclusão de módulos/atividades
- Ranking de desempenho (opcional — cuidado com comparação negativa)
- Progresso visual por trilha de aprendizagem

---

## Requisitos Não-Funcionais específicos

| RNF | Detalhamento | Por quê é específico deste domínio |
|---|---|---|
| Acessibilidade WCAG 2.1 AA | Contraste, alternativa textual para imagens, legendas em vídeos | Obrigatório para IES públicas (Lei Brasileira de Inclusão, Lei 13.146/2015); alunos com deficiência |
| Responsividade mobile | 100% das funcionalidades principais acessíveis em telas de 360px | Alunos acessam pelo celular, muitas vezes em redes lentas |
| Modo offline (EAD) | Download de material para acesso sem internet | Alunos em áreas com conectividade instável |
| Suporte a vídeos longos | Player suporta vídeos de até 4h com retomada do ponto parado | Aulas gravadas longas são comuns em EAD |
| LGPD com atenção a menores | Consentimento dos responsáveis para alunos < 18 anos; restrição de exposição de dados de alunos | Dado sensível: rendimento escolar é dado pessoal sensível |
| Conformidade MEC | Históricos e diplomas devem seguir normas do MEC para reconhecimento | IES regulamentadas pelo MEC |
| Alta disponibilidade em períodos de prova | 99,9% disponibilidade nas semanas de avaliação | Picos de acesso em períodos de prova podem derrubar plataforma |

---

## Restrições específicas

- **LDB (Lei 9.394/1996):** carga horária mínima presencial para certos cursos; EAD precisa de autorização MEC.
- **INEP / Censo Escolar:** IES públicas devem reportar dados ao INEP — sistema pode precisar exportar no formato exigido.
- **CFE/MEC para diplomas:** diplomas de cursos superiores devem seguir formato padrão do MEC para validade nacional.
- **Proteção de dados de menores:** art. 14 da LGPD — tratamento de dados de crianças exige consentimento dos pais.
- **Copyrights de material didático:** plataforma deve ter controle de quem pode fazer download de material protegido.