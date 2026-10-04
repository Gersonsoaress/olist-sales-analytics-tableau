# 📊 Olist Sales Analytics — SQL & Tableau

Projeto de análise de dados de vendas do e-commerce brasileiro **Olist**, desenvolvido com **PostgreSQL, SQL e Tableau**.

O objetivo do projeto foi transformar dados brutos de vendas em informações de negócio, passando pela preparação dos dados em banco de dados até a construção de um dashboard interativo para análise dos principais indicadores comerciais.

## 🎯 Objetivo

Analisar o desempenho das vendas da Olist e facilitar a identificação de padrões relacionados a faturamento, pedidos, localização geográfica, categorias de produtos e comportamento das vendas ao longo do tempo.

## 📈 Dashboard

O dashboard apresenta os seguintes indicadores:

- **Valor Pago:** R$ 16,01 milhões
- **Total de Pedidos:** 99.441
- **Ticket Médio:** R$ 160,99
- **Nota Média:** 4,09

Também foram desenvolvidas análises de:

- Evolução das vendas por mês
- Top 10 estados por vendas
- Top 10 categorias de produtos por vendas
- Top 10 cidades por vendas
- Filtros e interações entre as visualizações

## 🖼️ Visualização

![Dashboard Olist](Captura%20de%20tela%202026-10-03%20202337.png)

## 📂 Fonte dos Dados

Os dados utilizados neste projeto são provenientes do **Brazilian E-Commerce Public Dataset by Olist**, disponibilizado publicamente no Kaggle.

O conjunto contém aproximadamente 100 mil pedidos realizados entre 2016 e 2018 no e-commerce brasileiro, com informações sobre pedidos, clientes, vendedores, produtos, pagamentos, avaliações e localização.

🔗 [Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/olistbr/brazilian-ecommerce)

## 🔄 Fluxo do Projeto

1. Obtenção do dataset público da Olist no Kaggle
2. Importação e armazenamento dos dados no PostgreSQL
3. Preparação e transformação dos dados utilizando SQL
4. Criação de views analíticas para organizar os dados utilizados na análise
5. Conexão dos dados preparados ao Tableau
6. Desenvolvimento dos KPIs e visualizações
7. Construção do dashboard interativo
8. Publicação e documentação do projeto no GitHub

## 🛠️ Tecnologias utilizadas

- PostgreSQL
- SQL
- Tableau Desktop
- GitHub
- Análise e visualização de dados

## 📂 Arquivos

- `Olist_Analytics_Tableau.twbx` — workbook empacotado do Tableau
- `olist_analytics.sql` — views, validações e consultas SQL da camada Analytics
- Imagem do dashboard — visualização do resultado final
- `README.md` — documentação do projeto

## 💡 Principais Insights

A análise mostrou uma forte concentração das vendas no estado de **São Paulo**, que apresentou o maior valor de vendas entre os estados analisados.

Entre as categorias com maior participação nas vendas estão **Saúde e Beleza**, **Relógios e Presentes** e **Cama, Mesa e Banho**.

A análise por cidades também demonstrou a forte participação da cidade de **São Paulo** no volume financeiro das vendas.

A evolução mensal permite acompanhar o comportamento das vendas ao longo do período analisado e identificar períodos de crescimento e mudanças no desempenho comercial.

## 👤 Autor

**Gerson Soares**

Projeto desenvolvido para portfólio profissional na área de **Análise de Dados**.
