# Necessidades do Produto

Este documento lista o que o produto precisa fazer e como ele deve funcionar.

## O que as pessoas podem fazer
- **Cadastrar Treinos:** O usuário pode criar diferentes tipos de treinos (ex: Treino A, Treino B).
- **Adicionar Exercícios:** Dentro de cada treino, o usuário pode adicionar exercícios específicos.
- **Configurar Detalhes de Cada Exercício:**
    - Definir a quantidade de séries.
    - **Tipos de Séries:** O usuário pode classificar cada série como "Aquecimento", "Reconhecimento" ou "Trabalho".
    - **Sugestão de Peso:** O aplicativo sugere automaticamente os pesos das séries iniciais (aquecimento/reconhecimento) baseando-se no peso final definido para a série de trabalho.
    - Definir o peso que será usado em cada série individualmente.
    - Definir a meta de repetições.
    - Definir o tempo de descanso entre as séries.
- **Marcar Execução e Ajuste Real:**
    - O usuário marca cada série concluída.
    - Se fizer um número de repetições diferente da meta, o usuário pode registrar o valor real.
- **Cronômetro de Descanso:** Assim que uma série é marcada como concluída, o aplicativo inicia automaticamente a contagem regressiva do tempo de descanso definido.
- **Sugestões Inteligentes:** Se o usuário não conseguir atingir a meta de repetições por várias sessões seguidas, o aplicativo sugere diminuir levemente o peso para manter a qualidade do treino.
- **Histórico e Evolução:** O aplicativo deve gerar gráficos de progresso baseados no volume de treino (por dia, por tipo de treino e por grupo muscular).

## Como o produto deve se comportar
- **Simplicidade de Uso:** O aplicativo deve ser muito simples de usar, sem burocracia.
- **Visual Moderno:** Preferência por Modo Escuro com paleta de cores em roxo e lilás, utilizando degradês para um aspecto moderno.
- **Vínculo com Músculos:** Ao cadastrar um exercício, o usuário pode indicar a quais músculos ele pertence para facilitar a análise de volume nos gráficos.
- **Sem Limites:** O usuário pode cadastrar quantos treinos e exercícios desejar.
- **Funciona Sem Internet:** O aplicativo deve permitir o uso completo de todas as funções principais mesmo sem conexão com a internet.
- **Sincronização:** O aplicativo deve oferecer sincronização via backup (ex: Google Backup) para não perder dados ao trocar de aparelho.
- **Alertas e Controle de Descanso:** 
    - O aplicativo deve avisar o fim do descanso com som, vibração e notificações.
    - O usuário deve poder pular o descanso ou adicionar mais 15 segundos rapidamente se precisar.

## Quem usa o produto
- **Praticante de exercícios:** O único perfil de usuário identificado até agora.
