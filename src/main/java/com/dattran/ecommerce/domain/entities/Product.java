package com.dattran.ecommerce.domain.entities;

import java.util.List;

import com.dattran.ecommerce.domain.enums.ProductStatus;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
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
@Table(name = "products")
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Product extends BaseEntity {
    String name;

    String slug;

    String description;

    @Column(name = "short_description")
    String shortDescription;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    Category category;

    String brand;

    @Column(name = "sku_prefix")
    String skuPrefix;

    @Column(name = "status")
    ProductStatus productStatus;

    @Column(name = "meta_title")
    String metaTitle;

    @Column(name = "meat_description")
    String metaDescription;

    @OneToMany(
        mappedBy = "product", 
        fetch = FetchType.LAZY,
        cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH})
    List<ProductVariant> productVariants;

    @OneToMany(
        mappedBy = "product",
        fetch = FetchType.LAZY,
        cascade = {CascadeType.PERSIST, CascadeType.MERGE, CascadeType.REFRESH, CascadeType.DETACH}
    )
    List<ProductImage> productImages;
}
