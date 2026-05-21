# Especificação de Requisitos de Software (SRS)

## 1. Introdução
Este documento detalha os requisitos para o aplicativo de organização de treinos (Nome a definir). O foco é permitir uma gestão granular de exercícios e o acompanhamento preciso da evolução do praticante.

## 2. Descrição Geral
O produto é um aplicativo móvel voltado para praticantes de musculação e exercícios físicos que desejam planejar seus treinos com detalhes (tipos de séries e pesos) e acompanhar o progresso real através de gráficos de volume.

## 3. O que o produto deve fazer (Requisitos Funcionais)

### RF01 - Cadastro de Treinos
O sistema deve permitir que o usuário crie, edite e exclua treinos, dando a eles um nome personalizado.

### RF02 - Cadastro de Exercícios
Dentro de cada treino, o usuário deve poder adicionar exercícios, vinculando-os opcionalmente a grupos musculares.

### RF03 - Configuração de Séries Granular
Para cada exercício, o sistema deve permitir:
- Definir o número de séries.
- Classificar cada série como: Aquecimento, Reconhecimento ou Trabalho.
- Definir peso, repetições-alvo e tempo de descanso para cada série.

### RF04 - Sugestão Inteligente de Carga
O sistema deve sugerir automaticamente os pesos para as séries de "Aquecimento" e "Reconhecimento" baseando-se no peso definido para a série de "Trabalho".

### RF05 - Monitor de Execução de Treino
O sistema deve permitir que o usuário "inicie" um treino e marque as séries conforme as conclui.
- Ao marcar uma série, o sistema deve iniciar um cronômetro de descanso.
- O cronômetro deve permitir "Pular" ou "Adicionar +15 segundos".

### RF06 - Registro de Performance Real
O sistema deve permitir que o usuário registre o peso e as repetições que realmente executou, caso sejam diferentes do planejado.

### RF07 - Análise de Evolução (Gráficos)
O sistema deve gerar gráficos de evolução (linhas) e de comparação de volume (barras) por dia, por treino e por grupo muscular.

### RF08 - Sincronização e Backup
O sistema deve oferecer opção de sincronização e backup para garantir a persistência dos dados entre dispositivos.
- Suporte para Google Backup (Android).
- Suporte para iCloud (iOS).

### RF09 - Sugestões de Ajuste de Carga
Se o usuário não atingir a meta de repetições em um exercício por 3 sessões seguidas, o sistema deve exibir um aviso sugerindo a redução da carga para as próximas sessões.

## 4. Como o produto deve se comportar (Requisitos Não Funcionais)

### RNF01 - Disponibilidade Offline
Todas as funcionalidades principais (cadastro, execução e gráficos) devem funcionar sem conexão com a internet.

### RNF02 - Interface e Estética
O aplicativo deve utilizar uma interface moderna em "Modo Escuro" com paleta de cores roxa/lilás e uso de degradês.

### RNF03 - Simplicidade de Acesso
O usuário deve poder utilizar as funções principais sem a necessidade de criar uma conta ou fazer login.
