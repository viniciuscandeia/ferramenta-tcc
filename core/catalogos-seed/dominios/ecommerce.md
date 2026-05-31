# Domínio: E-commerce / Marketplace

Usado pelo sub-agente **Recomendação** para sugerir requisitos específicos de sistemas de comércio eletrônico.
Inclui: lojas virtuais, marketplaces, sistemas de venda de serviços online.

---

## Stakeholders típicos do domínio

| Stakeholder | Papel | Necessidades |
|---|---|---|
| Comprador / Cliente | Navega, escolhe e compra | Busca fácil, checkout rápido, tracking de pedido, devolução simples |
| Vendedor / Lojista (marketplace) | Cadastra e vende produtos | Painel de gestão de produtos, pedidos, estoque e financeiro |
| Administrador da plataforma | Gerencia toda a plataforma | Moderação de produtos, gestão de vendedores, relatórios globais, configuração de taxas |
| Gateway de Pagamento | Processa transações financeiras | API de integração, webhooks de confirmação, gestão de estornos |
| Transportadora / Logística | Entrega os pedidos | Coleta de etiquetas, atualização de status de entrega, integração via API |
| SAC / Atendimento | Resolve problemas pós-venda | Acesso a pedidos, histórico do cliente, abertura de chamados de devolução |
| Financeiro | Conciliação e repasse | Relatórios de vendas, notas fiscais, repasse para vendedores (marketplace) |

---

## Requisitos Funcionais específicos

### Catálogo de Produtos
- Cadastrar produto com: nome, descrição, fotos (múltiplas), preço, SKU, categoria, peso e dimensões
- Variações de produto (cor, tamanho, modelo) com estoque individual por variação
- Busca por texto, filtro por categoria, faixa de preço, avaliação, disponibilidade
- Ordenação por relevância, preço, novidades, mais vendidos
- Comparação de produtos
- Lista de desejos / favoritos

### Carrinho e Checkout
- Adicionar/remover itens do carrinho; salvar carrinho para retomar depois
- Cálculo de frete por CEP (Correios, transportadoras) antes do checkout
- Aplicar cupom de desconto e código promocional
- Checkout em até 3 passos: endereço → frete → pagamento → confirmação
- Checkout como convidado (sem cadastro obrigatório)
- Resumo do pedido antes de confirmar

### Pagamento
- Cartão de crédito (até 12x) com ou sem juros
- Cartão de débito
- Pix com QR Code e código copia-e-cola
- Boleto bancário com validade de 3 dias
- Carteira virtual / saldo da plataforma
- Salvar cartão para próximas compras (tokenizado — nunca armazenar CVV)

### Pedidos e Pós-Venda
- Confirmação de pedido por email e notificação push
- Tracking em tempo real com eventos (pedido confirmado → separado → enviado → entregue)
- Prazo estimado de entrega no produto e no checkout
- Solicitar cancelamento (antes do envio) e devolução/troca (após recebimento)
- Prazo legal de arrependimento: 7 dias (CDC art. 49)
- Avaliação de produto e vendedor após entrega confirmada

### Gestão do Vendedor (marketplace)
- Painel com: produtos, estoque, pedidos, financeiro, avaliações
- Cadastrar/editar produtos em massa (CSV/planilha)
- Emitir NF-e para cada pedido
- Relatório de repasse financeiro (quando recebe e quanto)

---

## Requisitos Não-Funcionais específicos

| RNF | Detalhamento | Por quê é específico deste domínio |
|---|---|---|
| Alta disponibilidade | 99,9% uptime; sem downtime em datas comemorativas (Black Friday, Natal) | Downtime = vendas perdidas; picos de acesso previsíveis |
| Performance no pico | Suportar 10x o tráfego normal sem degradação (Black Friday) | Picos sazonais dramáticos no e-commerce brasileiro |
| Segurança PCI-DSS | Se armazenar dados de cartão, deve seguir PCI-DSS nível 4+ | Obrigatório para quem processa cartão de crédito |
| Tempo de carregamento de produto | Página de produto carregada em < 2s (impacto direto na conversão) | Cada segundo extra reduz conversão em ~7% (estudo Akamai) |
| Disponibilidade de imagens | CDN para imagens de produto; fallback se CDN falhar | Produto sem imagem não vende |
| LGPD | Consentimento de cookies, política de privacidade, direito de exclusão de dados | Compra envolve CPF, endereço, cartão — dados pessoais sensíveis |
| Integridade transacional | Zero pedidos duplicados; zero cobrança sem pedido confirmado | Falha aqui gera chargebacks e processos no PROCON |

---

## Restrições específicas

- **Código de Defesa do Consumidor (CDC):**
  - Art. 49: direito de arrependimento em até 7 dias para compras online, sem custo.
  - Art. 30-37: oferta é vinculante; proibido publicidade enganosa.
  - Prazo máximo de entrega deve ser informado antes da compra.
- **NF-e obrigatória:** toda venda de produto físico exige emissão de NF-e (SEFAZ) ou NFS-e (serviço, Prefeitura).
- **Resolução BACEN 4.649 / Marco Legal das Fintechs:** se o marketplace retém dinheiro dos vendedores, pode ser enquadrado como instituição de pagamento.
- **PCI-DSS:** tokenização obrigatória para dados de cartão; nunca armazenar CVV.
- **PROCON / SENACON:** reclamações podem gerar multas; sistema deve ter evidências de prazo de entrega, comunicação com cliente e processo de devolução.
- **SEO:** URLs amigáveis para produtos e categorias são requisito de negócio quase sempre; impacta diretamente receita.