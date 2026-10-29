# Canonical Business Model — E-commerce Delivery Lighthouse

## 1. Purpose

The Canonical Business Model establishes a consistent logical
business contract between the CORE physical data model and
the ONTOLOGY semantic metadata.

It was documented and validated after CP01–CP05 as part of
the CAN2–CAN5 canonical retrofit.

This is a logical architecture layer, not a new Snowflake
schema, table, or runtime transformation pipeline.

## 2. Architecture Position

CORE Physical Model
    |
    v
Canonical Business Model (Logical Contract)
    |
    v
Ontology Semantic Metadata
    |
    v
Materialized Knowledge Graph
    |
    v
CP05 Explainable Business Reasoning

The actual CP04 and CP05 SQL implementations continue to
read the existing CORE and ONTOLOGY tables directly.

## 3. Canonical Entities

| Entity | Identifier | Physical Source | Business Meaning |
|---|---|---|---|
| CUSTOMER | CUSTOMER_ID | CORE.CUSTOMER | Person placing e-commerce orders |
| CUSTOMER_ORDER | ORDER_ID | CORE.CUSTOMER_ORDER | Order placed by a customer |
| SHIPMENT | SHIPMENT_ID | CORE.SHIPMENT | Physical delivery associated with an order |
| SHIPMENT_EVENT | EVENT_ID | CORE.SHIPMENT_EVENT | Timestamped shipment tracking observation |
| DELIVERY_ISSUE | ISSUE_ID | CORE.DELIVERY_ISSUE | Recorded delivery issue classification |

All physical sources belong to ECOM_ONTOLOGY_LIGHTHOUSE_DB.

## 4. Canonical Attributes

The model contains 20 mapped business attributes.

### CUSTOMER

| Attribute | Semantic Kind |
|---|---|
| CUSTOMER_ID | IDENTIFIER |
| CUSTOMER_NAME | BUSINESS_ATTRIBUTE |

### CUSTOMER_ORDER

| Attribute | Semantic Kind |
|---|---|
| ORDER_ID | IDENTIFIER |
| CUSTOMER_ID | ENTITY_REFERENCE |
| ORDER_DATE | BUSINESS_DATE |
| ORDER_AMOUNT | MONETARY_AMOUNT |

### SHIPMENT

| Attribute | Semantic Kind |
|---|---|
| SHIPMENT_ID | IDENTIFIER |
| ORDER_ID | ENTITY_REFERENCE |
| ISSUE_ID | OPTIONAL_ENTITY_REFERENCE |
| SHIPMENT_STATUS | OPERATIONAL_STATE |
| EXPECTED_DELIVERY_DATE | BUSINESS_DATE |

### SHIPMENT_EVENT

| Attribute | Semantic Kind |
|---|---|
| EVENT_ID | IDENTIFIER |
| SHIPMENT_ID | ENTITY_REFERENCE |
| EVENT_TIMESTAMP | EVENT_TIMESTAMP |
| EVENT_STATUS | OBSERVED_STATE |
| EVENT_ISSUE_CODE | EVIDENCE_CODE |
| EVENT_DESCRIPTION | EVIDENCE_DESCRIPTION |

### DELIVERY_ISSUE

| Attribute | Semantic Kind |
|---|---|
| ISSUE_ID | IDENTIFIER |
| ISSUE_CATEGORY_NAME | BUSINESS_CLASSIFICATION |
| ISSUE_DESCRIPTION | BUSINESS_DESCRIPTION |

These semantic kinds are represented in the JSON stored in
ONTOLOGY.CLASS_DEFINITION.PROPERTIES.

There is no separately deployed PROPERTY_DEFINITION table.

## 5. Canonical Relationships

| Relationship | Source | Target | Source Cardinality | Target Cardinality | Optional | Inverse |
|---|---|---|---|---|---|---|
| PLACED | CUSTOMER | CUSTOMER_ORDER | 1 | 0..N | TRUE | PLACED_BY |
| FULFILLED_BY | CUSTOMER_ORDER | SHIPMENT | 1 | 1 | FALSE | FULFILLS |
| HAS_EVENT | SHIPMENT | SHIPMENT_EVENT | 1 | 1..N | FALSE | EVENT_OF |
| CLASSIFIED_AS | SHIPMENT | DELIVERY_ISSUE | 0..N | 0..1 | TRUE | CLASSIFIES |
| SUBCATEGORY_OF | DELIVERY_ISSUE | DELIVERY_ISSUE | 0..N | 0..1 | TRUE | HAS_SUBCATEGORY |

Cardinality, optionality, and inverse names reproduce the
values in ONTOLOGY.RELATIONSHIP_DEFINITION.

The FULFILLED_BY relationship uses a simplified 1:1
order-to-shipment contract.

Standard Snowflake primary-key, foreign-key, and unique
constraints are not assumed to enforce these contracts.

## 6. Delivery Issue Taxonomy

The issue hierarchy contains four SUBCATEGORY_OF mappings:

| Child Issue | Child Category | Parent Issue | Parent Category |
|---|---|---|---|
| ISS_002 | Warehouse Dispatch Delay | ISS_001 | Delivery Delay |
| ISS_003 | Carrier Delay | ISS_001 | Delivery Delay |
| ISS_004 | Weather Delay | ISS_001 | Delivery Delay |
| ISS_005 | Warehouse Inactivity | ISS_001 | Delivery Delay |

Taxonomy represents classification, not causal inference.

A Warehouse Inactivity classification does not prove that
warehouse dispatch failure is the root cause.

## 7. Physical and Ontology Alignment

Each canonical entity maps to one existing CORE table and
one ontology class.

Each canonical attribute maps to an existing CORE column
and its corresponding property metadata where defined.

Each canonical relationship aligns with an existing entry
in ONTOLOGY.RELATIONSHIP_DEFINITION.

The canonical layer introduces no additional physical
persistence or materialization requirement.

## 8. Validation Summary

| Validation | Result |
|---|---|
| Canonical entities | 5 |
| Canonical relationships | 5 |
| Canonical attribute mappings | 20/20 |
| Ontology class alignment | PASS |
| Relationship alignment | PASS |
| Knowledge Graph node traceability | 20/20 |
| Knowledge Graph edge traceability | 19/19 |
| Provenance validation | PASS |
| CP05 reasoning continuity | PASS |

These results describe the validated demonstration baseline,
not continuous enforcement for future source changes.

## 9. Implementation Boundaries

- No new CANONICAL Snowflake schema or tables.
- No changes to existing CORE tables.
- No changes to existing ontology metadata or KG tables.
- No changes to CP04 graph materialization.
- No changes to CP05 business reasoning.
- No automatic KG synchronization is introduced.
- No new Cortex Agent, LLM, Semantic View, or MCP integration.
- EVENT_TIMESTAMP uses TIMESTAMP_NTZ; UTC interpretation
  remains a demonstration assumption.

## 10. Source of Truth

- sql/cp01_core_schema.sql
- sql/cp03_ontology_definitions.sql
- sql/cp04_kg_materialization.sql
- sql/cp05_investigation.sql

This specification documents the CAN2–CAN5 validated
canonical model retrofit without modifying CP01–CP05.