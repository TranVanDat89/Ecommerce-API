ALTER TABLE categories ADD COLUMN level INT NOT NULL;
ALTER TABLE product_attributes DROP COLUMN IF EXISTS type;
ALTER TABLE attribute_values DROP COLUMN IF EXISTS color_code;