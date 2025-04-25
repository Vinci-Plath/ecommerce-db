CREATE DATABASE ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;

-- Table 1. Brand information
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    website_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT uc_brand_name UNIQUE (name)
) ENGINE=InnoDB;

-- Table 2. Product categories
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    slug VARCHAR(100) NOT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES product_category(category_id),
    CONSTRAINT uc_category_slug UNIQUE (slug)
) ENGINE=InnoDB;


-- Table 3. Color options
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    hex_code CHAR(7),
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT uc_color_name UNIQUE (name)
) ENGINE=InnoDB;

-- Table 4.Size classification
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    CONSTRAINT uc_size_category_name UNIQUE (name)
) ENGINE=InnoDB;

-- Table 5. Specific size options
CREATE TABLE size_option (
    size_option_id INT AUTO_INCREMENT PRIMARY KEY,
    size_category_id INT NOT NULL,
    label VARCHAR(20) NOT NULL,
    measurement DECIMAL(5,2) NULL,
    display_order INT DEFAULT 0,
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id),
    CONSTRAINT uc_size_label_category UNIQUE (size_category_id, label)
) ENGINE=InnoDB;

-- Table 6. Main product table
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    base_price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id),
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    CONSTRAINT uc_product_slug UNIQUE (slug)
) ENGINE=InnoDB;

-- Table 7. Product images
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Table 8. Product variations
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    color_id INT NULL,
    size_option_id INT NULL,
    sku VARCHAR(100) NOT NULL,
    additional_price DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_option_id) REFERENCES size_option(size_option_id),
    CONSTRAINT uc_product_variation UNIQUE (product_id, color_id, size_option_id),
    CONSTRAINT uc_sku UNIQUE (sku)
) ENGINE=InnoDB;

-- Table 9. Inventory items
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    variation_id INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    barcode VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id) ON DELETE CASCADE,
    CONSTRAINT uc_barcode UNIQUE (barcode)
) ENGINE=InnoDB;

-- 10. Attribute categories
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    CONSTRAINT uc_attribute_category_name UNIQUE (name)
) ENGINE=InnoDB;

-- 11. Attribute data types
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    CONSTRAINT uc_attribute_type_name UNIQUE (name)
) ENGINE=InnoDB;

-- 12. Product attributes
CREATE TABLE product_attribute (
    product_attribute_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_category_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    value TEXT NOT NULL,
    display_order INT DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id),
    CONSTRAINT uc_product_attribute UNIQUE (product_id, attribute_category_id, name)
) ENGINE=InnoDB;


-- 13. Sample data

INSERT INTO brand (name, description, logo_url, website_url) VALUES
('Gucci', 'Luxury fashion brand', 'https://logo.com/gucci.png', 'https://gucci.com'),
('Zara', 'Fast fashion retailer', 'https://logo.com/zara.png', 'https://zara.com'),
('H&M', 'Affordable fashion', 'https://logo.com/hm.png', 'https://hm.com'),
('Louis Vuitton', 'Designer bags and accessories', 'https://logo.com/lv.png', 'https://louisvuitton.com'),
('Chanel', 'Luxury fashion house', 'https://logo.com/chanel.png', 'https://chanel.com');

INSERT INTO product_category (parent_id, name, description, slug, display_order) VALUES
(NULL, 'Bags', 'Handbags and backpacks', 'bags', 1),
(NULL, 'Shoes', 'Heels, boots, sneakers', 'shoes', 2),
(NULL, 'Jewellery', 'Rings, earrings, necklaces', 'jewellery', 3),
(NULL, 'Clothing', 'Dresses, tops, pants', 'clothing', 4),
(NULL, 'Accessories', 'Belts, scarves, sunglasses', 'accessories', 5);

INSERT INTO color (name, hex_code) VALUES
('Black', '#000000'),
('White', '#FFFFFF'),
('Gold', '#FFD700'),
('Red', '#FF0000'),
('Nude', '#F2D2BD');

INSERT INTO size_category (name, description) VALUES
('Clothing Sizes', 'Standard clothing sizes'),
('Shoe Sizes', 'Standard shoe sizes'),
('Ring Sizes', 'Ring sizes for jewellery'),
('Bag Sizes', 'Small, medium, large bag sizes'),
('Belt Sizes', 'Waist-based belt sizes');

INSERT INTO size_option (size_category_id, label, measurement) VALUES
(1, 'S', 4.00),
(1, 'M', 6.00),
(2, '38', 38.00),
(3, '6', 6.00),
(4, 'Medium', 12.00);

INSERT INTO product (category_id, brand_id, name, slug, description, short_description, base_price) VALUES
(1, 1, 'Gucci GG Marmont', 'gucci-gg-marmont', 'A shoulder bag made in matelassé leather.', 'Elegant leather shoulder bag.', 2250.00),
(2, 2, 'Zara Ankle Boots', 'zara-ankle-boots', 'Trendy ankle boots with block heels.', 'Black ankle boots', 120.00),
(3, 3, 'H&M Gold Necklace', 'hm-gold-necklace', 'Minimalist gold-plated necklace.', 'Gold necklace', 35.00),
(4, 4, 'LV Monogram Dress', 'lv-monogram-dress', 'Signature LV monogram midi dress.', 'LV branded dress', 3150.00),
(5, 5, 'Chanel Sunglasses', 'chanel-sunglasses', 'Vintage oversized sunglasses.', 'Fashionable eyewear', 800.00);

INSERT INTO product_image (product_id, url, alt_text, is_primary) VALUES
(1, 'images/gucci_bag.jpg', 'Gucci GG Marmont Bag', TRUE),
(2, 'images/zara_boots.jpg', 'Zara Ankle Boots', TRUE),
(3, 'images/hm_necklace.jpg', 'H&M Necklace', TRUE),
(4, 'images/lv_dress.jpg', 'Louis Vuitton Dress', TRUE),
(5, 'images/chanel_sunglasses.jpg', 'Chanel Sunglasses', TRUE);

INSERT INTO product_variation (product_id, color_id, size_option_id, sku, additional_price) VALUES
(1, 1, 5, 'GUCCI-GG-BAG-001', 0.00),
(2, 1, 3, 'ZARA-ANKLE-001', 10.00),
(3, 3, 4, 'HM-NECK-001', 0.00),
(4, 4, 2, 'LV-DRESS-001', 100.00),
(5, 2, NULL, 'CHANEL-SUN-001', 0.00);


INSERT INTO product_item (variation_id, stock_quantity, price, barcode) VALUES
(1, 10, 2250.00, 'GUCCI-BARCODE-001'),
(2, 25, 130.00, 'ZARA-BARCODE-002'),
(3, 50, 35.00, 'HM-BARCODE-003'),
(4, 5, 3250.00, 'LV-BARCODE-004'),
(5, 20, 800.00, 'CHANEL-BARCODE-005');

INSERT INTO attribute_category (name, description) VALUES
('Material', 'Type of material used'),
('Weight', 'Product weight'),
('Origin', 'Country of origin'),
('Gender', 'Target gender'),
('Style', 'Fashion style or trend');


INSERT INTO attribute_type (name, description) VALUES
('Text', 'Plain text format'),
('Number', 'Numeric value'),
('Boolean', 'Yes/No'),
('Date', 'Date type attribute'),
('Enum', 'Enumeration from set options');

INSERT INTO product_attribute (product_id, attribute_category_id, attribute_type_id, name, value) VALUES
(1, 1, 1, 'Material', 'Leather'),
(2, 1, 1, 'Material', 'Synthetic'),
(3, 2, 2, 'Weight', '0.1'),
(4, 3, 1, 'Origin', 'France'),
(5, 5, 1, 'Style', 'Vintage');


 -- 14. Indexes for performance

CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_active ON product(is_active);
CREATE INDEX idx_variation_product ON product_variation(product_id);
CREATE INDEX idx_item_variation ON product_item(variation_id);
CREATE INDEX idx_product_slug ON product(slug);
CREATE INDEX idx_product_attribute_product ON product_attribute(product_id);










































