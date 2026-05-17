# Domínio: Aplicativo Mobile

Usado pelo sub-agente **Recomendação** para sugerir requisitos específicos de apps mobile (iOS e/ou Android).
Inclui: apps utilitários, apps de serviço, apps complementares a sistema web.

---

## Stakeholders típicos do domínio

| Stakeholder | Papel | Necessidades |
|---|---|---|
| Usuário final do app | Usa o app para cumprir tarefa no celular | Experiência fluida, rápida, offline quando possível, interface intuitiva |
| Administrador do backend | Gerencia conteúdo e usuários via painel web | Painel web responsivo, não necessariamente o app |
| Loja de apps (Apple App Store / Google Play) | Valida e distribui o app | Conformidade com políticas de privacidade, permissões declaradas, avaliação humana |
| Equipe de suporte | Ajuda usuários com problemas | Acesso a logs de erro do dispositivo, versão do app, sistema operacional |

---

## Requisitos Funcionais específicos

### Onboarding
- Tela de boas-vindas com apresentação do app (carousel de features)
- Cadastro e login simplificados (email, Google, Apple Sign-In)
- Tutorial interativo na primeira vez (tooltips/walkthrough)
- Permissões solicitadas em contexto, com explicação clara

### Notificações Push
- Receber notificações push (requer permissão explícita do usuário)
- Configurar quais notificações receber (preferências)
- Ação direto na notificação (deep link para tela específica)
- Notificações locais agendadas (lembretes no próprio device)

### Modo Offline
- Cache local de dados essenciais para acesso sem internet
- Indicador visual de modo offline
- Sincronização automática ao retomar conectividade
- Fila de ações feitas offline para sincronizar depois

### Câmera e Mídia
- Tirar foto ou escolher da galeria
- Scan de QR Code ou código de barras
- Gravação de áudio ou vídeo curto
- Upload com progresso e retry automático em falha de rede

### Localização e Mapas
- Solicitar permissão de geolocalização com explicação clara
- Exibir mapa com pontos de interesse
- Calcular distância e rota
- Geofencing (ação quando entra/sai de área)

### Atualização do App
- Verificar nova versão disponível ao abrir
- Forçar atualização para versões críticas
- Atualização OTA de conteúdo (sem republicar na loja)

---

## Requisitos Não-Funcionais específicos

| RNF | Detalhamento | Por quê é específico deste domínio |
|---|---|---|
| Performance em redes lentas | Funcional em 3G (< 1 Mbps); operações críticas em < 5s | Usuários mobile frequentemente em redes instáveis |
| Consumo de bateria | App não deve consumir mais de X% da bateria por hora em uso passivo | Background processes consomem bateria e causam desinstalação |
| Tamanho do app | APK/IPA < 50MB para download celular; < 150MB total com assets | Usuários com armazenamento limitado desinstalam apps pesados |
| Tempo de inicialização | App pronto em < 3s em cold start | Usuário abandona app que demora para abrir |
| Compatibilidade iOS | iOS 15+ (cobre ~95% dos iPhones ativos em 2024) | Versões muito antigas exigem código legado e limitam features |
| Compatibilidade Android | Android 11+ (API level 30+) | Fragmentação do Android exige definição explícita de versão mínima |
| Responsividade a diferentes telas | Funciona em telas de 4" a 7" e em tablets | Variedade de tamanhos de dispositivos Android especialmente |
| Acessibilidade (VoiceOver/TalkBack) | Elementos com labels para leitores de tela | Apple e Google exigem acessibilidade básica para aprovação nas lojas |
| Segurança local | Dados sensíveis no Keychain (iOS) / Keystore (Android), não em SharedPreferences | Dados em texto puro no device são risco de segurança |
| Crash rate | < 0,5% de sessões com crash | Benchmark de qualidade das lojas; abaixo disso leva ao rebaixamento |

---

## Restrições específicas

- **Políticas Apple App Store:** revisão humana obrigatória (3-7 dias úteis); proibido conteúdo adulto sem restrição de idade; IAP (compras no app) obrigatoriamente via sistema Apple com taxa de 30%.
- **Políticas Google Play:** revisão mais rápida, mas políticas rigorosas para apps financeiros e de saúde; taxa de 15-30% em compras.
- **Permissões declaradas:** todas as permissões usadas (câmera, localização, microfone, contatos) devem ser declaradas no manifesto e justificadas ao usuário.
- **Privacy Nutrition Label (Apple):** obrigatório declarar todos os dados coletados e para qual finalidade.
- **Deep Links / Universal Links:** para funcionamento de notificações com ação direta, é necessário configuração específica no servidor.
- **LGPD no app:** política de privacidade linkada na loja e acessível dentro do app; consentimento registrado.