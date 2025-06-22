package com.dattran.ecommerce.domain.entities;

import jakarta.persistence.Column;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
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
@Table(name = "attribute_values")
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AttributeValue {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String id;

    String value;

    @Column(name = "sort_order")
    Integer sortOrder;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "attribute_id")
    ProductAttribute productAttribute;

    @OneToMany(mappedBy = "attributeValue", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<VariantAttributeValue> variantAttributeValues;
}
