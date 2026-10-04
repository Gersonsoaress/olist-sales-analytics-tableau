-- ============================================================
-- OLIST SALES ANALYTICS
-- Scripts SQL recuperados da camada Analytics
-- PostgreSQL
-- ============================================================
--
-- Observação:
-- Este arquivo reúne os scripts recuperados do histórico do projeto.
-- Algumas views utilizadas como dependências (como vw_order_items e
-- vw_sales) foram criadas anteriormente e não fazem parte deste arquivo.
-- ============================================================


-- ------------------------------------------------------------
-- 1. PRODUTOS COM TRADUÇÃO DE CATEGORIA
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_products AS
SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw.products p
LEFT JOIN raw.product_category_translation t
    ON p.product_category_name = t.product_category_name;


-- ------------------------------------------------------------
-- 2. VENDEDORES
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw.sellers;


-- ------------------------------------------------------------
-- 3. VIEW DE ITENS DE VENDAS
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_sales_items AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,

    p.product_category_name,
    p.product_category_name_english,

    s.seller_city,
    s.seller_state,

    i.price,
    i.freight_value,
    i.total_item

FROM analytics.vw_order_items i

LEFT JOIN analytics.vw_products p
    ON i.product_id = p.product_id

LEFT JOIN analytics.vw_sellers s
    ON i.seller_id = s.seller_id;


-- ------------------------------------------------------------
-- 4. AVALIAÇÕES AGREGADAS POR PEDIDO
-- Um pedido pode possuir mais de uma avaliação.
-- Mantemos 1 linha por order_id.
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_order_reviews AS
SELECT
    order_id,
    ROUND(AVG(review_score)::numeric, 2) AS review_score_medio,
    COUNT(*) AS quantidade_reviews
FROM raw.order_reviews
GROUP BY order_id;


-- ------------------------------------------------------------
-- 5. VIEW FINAL DE VENDAS
-- GRANULARIDADE: 1 LINHA = 1 PEDIDO
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_sales_final AS
SELECT
    s.order_id,
    s.customer_id,
    s.customer_unique_id,

    s.customer_city,
    s.customer_state,

    s.order_status,
    s.order_purchase_timestamp,
    s.purchase_year,
    s.purchase_month,

    s.delivery_days,
    s.delivery_vs_estimate_days,

    s.quantidade_itens,
    s.valor_produtos,
    s.valor_frete,
    s.valor_total,

    s.quantidade_pagamentos,
    s.valor_pago,
    s.max_parcelas,

    r.review_score_medio,
    COALESCE(r.quantidade_reviews, 0) AS quantidade_reviews

FROM analytics.vw_sales s

LEFT JOIN analytics.vw_order_reviews r
    ON s.order_id = r.order_id;


-- ------------------------------------------------------------
-- 6. VIEW FINAL DE ITENS
-- GRANULARIDADE: 1 LINHA = 1 ITEM VENDIDO
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_sales_items_final AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,

    p.product_category_name,
    p.product_category_name_english,

    i.price,
    i.freight_value,
    i.total_item,

    s.seller_city,
    s.seller_state

FROM analytics.vw_order_items i

LEFT JOIN analytics.vw_products p
    ON i.product_id = p.product_id

LEFT JOIN analytics.vw_sellers s
    ON i.seller_id = s.seller_id;


-- ------------------------------------------------------------
-- 7. FORMAS DE PAGAMENTO
-- Fonte separada porque um pedido pode ter mais de um pagamento.
-- ------------------------------------------------------------

CREATE OR REPLACE VIEW analytics.vw_payment_types AS
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw.order_payments;


-- ============================================================
-- CONSULTAS DE VALIDAÇÃO E ANÁLISE
-- ============================================================

-- Validação da view de itens
SELECT
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT order_id) AS pedidos,
    COUNT(DISTINCT product_id) AS produtos
FROM analytics.vw_sales_items;


-- Validação da tabela de produtos
SELECT
    COUNT(*) AS total_linhas,
    COUNT(DISTINCT product_id) AS produtos_unicos
FROM raw.products;


-- Top 10 categorias por valor dos produtos
SELECT
    COALESCE(product_category_name_english, 'unknown') AS categoria,
    COUNT(*) AS itens_vendidos,
    ROUND(SUM(price), 2) AS valor_produtos
FROM analytics.vw_sales_items
GROUP BY product_category_name_english
ORDER BY valor_produtos DESC
LIMIT 10;


-- Validação final das principais views
SELECT
    (SELECT COUNT(*) FROM analytics.vw_sales_final) AS pedidos,

    (SELECT COUNT(DISTINCT order_id)
     FROM analytics.vw_sales_final) AS pedidos_unicos,

    (SELECT COUNT(*)
     FROM analytics.vw_sales_items_final) AS itens,

    (SELECT COUNT(*)
     FROM analytics.vw_payment_types) AS pagamentos;


-- Estrutura da view final de vendas
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'analytics'
  AND table_name = 'vw_sales_final'
ORDER BY ordinal_position;


-- Views existentes no schema analytics
SELECT
    table_name
FROM information_schema.views
WHERE table_schema = 'analytics'
ORDER BY table_name;


-- Top 20 cidades/estados por valor de vendas
SELECT
    seller_city,
    seller_state,
    SUM(total_item) AS valor_vendas
FROM analytics.vw_sales_items_final
GROUP BY seller_city, seller_state
ORDER BY valor_vendas DESC
LIMIT 20;
