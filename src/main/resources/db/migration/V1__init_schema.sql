-- ============================================
-- ECOMMERCE SCHEMA CHUẨN HÓA CHẠY TRÊN FLYWAY
-- ============================================
CREATE TYPE product_attribute_type AS ENUM('text','number','select','multiselect','boolean','color');
CREATE TYPE product_status_type AS ENUM('active', 'inactive', 'draft');
-- 1. BẢNG CATEGORIES
CREATE TABLE categories (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE
    SET
        NULL
);

CREATE INDEX idx_categories_parent_id ON categories (parent_id);

CREATE INDEX idx_categories_active_sort ON categories (is_active, sort_order);

-- 2. BẢNG PRODUCT ATTRIBUTES
CREATE TABLE product_attributes (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    type product_attribute_type,
    is_required BOOLEAN DEFAULT FALSE,
    is_variation BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_product_attributes_variation ON product_attributes (is_variation);

-- 3. BẢNG ATTRIBUTE VALUES
CREATE TABLE attribute_values (
    id UUID PRIMARY KEY,
    attribute_id UUID NOT NULL,
    value VARCHAR(255) NOT NULL,
    color_code VARCHAR(7),
    sort_order INT DEFAULT 0,
    CONSTRAINT fk_attribute_values_attribute FOREIGN KEY (attribute_id) REFERENCES product_attributes(id) ON DELETE CASCADE,
    CONSTRAINT uq_attribute_value UNIQUE (attribute_id, value)
);

CREATE INDEX idx_attribute_values_attribute_id ON attribute_values (attribute_id);

-- 4. BẢNG CATEGORY ATTRIBUTES (LIÊN KẾT DANH MỤC - THUỘC TÍNH)
CREATE TABLE category_attributes (
    id UUID PRIMARY KEY,
    category_id UUID NOT NULL,
    attribute_id UUID NOT NULL,
    is_required BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    CONSTRAINT fk_category_attributes_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_category_attributes_attribute FOREIGN KEY (attribute_id) REFERENCES product_attributes(id) ON DELETE CASCADE,
    CONSTRAINT uq_category_attribute UNIQUE (category_id, attribute_id)
);

-- 5. BẢNG PRODUCTS
CREATE TABLE products (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    short_description TEXT,
    category_id UUID NOT NULL,
    brand VARCHAR(255),
    sku_prefix VARCHAR(50),
    status product_status_type,
    meta_title VARCHAR(255),
    meta_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE INDEX idx_products_category_id ON products (category_id);

CREATE INDEX idx_products_status ON products (status);

CREATE INDEX idx_products_brand ON products (brand);

-- 6. BẢNG PRODUCT VARIANTS
CREATE TABLE product_variants (
    id UUID PRIMARY KEY,
    product_id UUID NOT NULL,
    sku VARCHAR(255) UNIQUE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    compare_price DECIMAL(10, 2),
    cost_price DECIMAL(10, 2),
    stock_quantity INT DEFAULT 0,
    min_stock_level INT DEFAULT 0,
    weight DECIMAL(8, 2),
    dimensions VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    status product_status_type,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_variants_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_variants_product_id ON product_variants (product_id);

CREATE INDEX idx_product_variants_status ON product_variants (status);

CREATE INDEX idx_product_variants_default ON product_variants (is_default);

-- 7. BẢNG VARIANT ATTRIBUTE VALUES
CREATE TABLE variant_attribute_values (
    id UUID PRIMARY KEY,
    variant_id UUID NOT NULL,
    attribute_id UUID NOT NULL,
    attribute_value_id UUID,
    custom_value VARCHAR(255),
    CONSTRAINT fk_variant_attribute_values_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
    CONSTRAINT fk_variant_attribute_values_attribute FOREIGN KEY (attribute_id) REFERENCES product_attributes(id) ON DELETE CASCADE,
    CONSTRAINT fk_variant_attribute_values_attr_value FOREIGN KEY (attribute_value_id) REFERENCES attribute_values(id) ON DELETE
    SET
        NULL,
        CONSTRAINT uq_variant_attribute UNIQUE (variant_id, attribute_id)
);

CREATE INDEX idx_variant_attribute_variant_id ON variant_attribute_values (variant_id);

CREATE INDEX idx_variant_attribute_attribute_id ON variant_attribute_values (attribute_id);

-- 8. BẢNG PRODUCT IMAGES
CREATE TABLE product_images (
    id UUID PRIMARY KEY,
    product_id UUID,
    variant_id UUID,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    sort_order INT DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_images_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_images_product_id ON product_images (product_id);

CREATE INDEX idx_product_images_variant_id ON product_images (variant_id);

CREATE INDEX idx_product_images_primary ON product_images (is_primary);