package com.dattran.ecommerce.domain.entities;

import java.util.List;

import com.dattran.ecommerce.domain.enums.ProductStatus;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;
import lombok.AccessLevel;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Table(name = "product_variants")
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProductVariant extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY)
    Product product;

    String sku;

    Double price;

    @Column(name = "compare_price")
    Double comparePrice;

    @Column(name = "cost_price")
    Double costPrice;

    @Column(name = "stock_quantity")
    Integer stockQuantity;

    @Column(name = "min_stock_level")
    Integer minStockLevel;

    Double weight;

    String dimensions;

    @Column(name = "is_default")
    Boolean isDefault;

    @Enumerated(EnumType.STRING)
    ProductStatus status;

    @OneToMany(
        mappedBy = "productVariant",
        fetch = FetchType.LAZY,
        cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH}
    )
    List<VariantAttributeValue> variantAttributeValues;
}
