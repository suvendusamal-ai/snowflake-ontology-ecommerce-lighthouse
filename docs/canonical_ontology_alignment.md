# Canonical-to-Ontology Alignment

## 1. Purpose

This document explains how the Canonical Business Model
aligns with the existing Snowflake ontology metadata.

Database: ECOM_ONTOLOGY_LIGHTHOUSE_DB
Schema: ONTOLOGY

The canonical model is a logical business contract.
Ontology metadata represents its business semantics.

No new ontology objects or runtime transformations are
introduced by this documentation.

## 2. Architecture Alignment

CORE Physical Data Model
    |
    v
Canonical Business Model (Logical)
    |
    v
ONTOLOGY Semantic Metadata
    |
    v
Materialized Knowledge Graph
    |
    v
CP05 Business Reasoning

The architecture represents logical alignment.

The existing CP04/CP05 SQL implementations continue
to access CORE and ONTOLOGY objects directly.

## 3. Canonical Entity-to-Ontology Class Mapping

| Canonical Entity | Ontology Class ID | Physical Source | Identifier |
|---|---|---|---|
| CUSTOMER | CUSTOMER | CORE.CUSTOMER | CUSTOMER_ID |
| CUSTOMER_ORDER | CUSTOMER_ORDER | CORE.CUSTOMER_ORDER | ORDER_ID |
| SHIPMENT | SHIPMENT | CORE.SHIPMENT | SHIPMENT_ID |
| SHIPMENT_EVENT | SHIPMENT_EVENT | CORE.SHIPMENT_EVENT | EVENT_ID |
| DELIVERY_ISSUE | DELIVERY_ISSUE | CORE.DELIVERY_ISSUE | ISSUE_ID |

The mappings are represented in
ONTOLOGY.CLASS_DEFINITION using:

- CLASS_ID
- CLASS_NAME
- CLASS_DESCRIPTION
- SOURCE_DATABASE
- SOURCE_SCHEMA
- SOURCE_TABLE
- IDENTIFIER_COLUMN
- PROPERTIES

All five classes reference ECOM_ONTOLOGY_LIGHTHOUSE_DB
as the source database and CORE as the source schema.

## 4. Canonical Attribute-to-Ontology Property Mapping

The 20 canonical attributes are represented through
the PROPERTIES VARIANT column of CLASS_DEFINITION.

Each property contains a name and semantic kind.

| Canonical Entity | Property | Semantic Kind |
|---|---|---|
| CUSTOMER | CUSTOMER_ID | IDENTIFIER |
| CUSTOMER | CUSTOMER_NAME | BUSINESS_ATTRIBUTE |
| CUSTOMER_ORDER | ORDER_ID | IDENTIFIER |
| CUSTOMER_ORDER | CUSTOMER_ID | ENTITY_REFERENCE |
| CUSTOMER_ORDER | ORDER_DATE | BUSINESS_DATE |
| CUSTOMER_ORDER | ORDER_AMOUNT | MONETARY_AMOUNT |
| SHIPMENT | SHIPMENT_ID | IDENTIFIER |
| SHIPMENT | ORDER_ID | ENTITY_REFERENCE |
| SHIPMENT | ISSUE_ID | OPTIONAL_ENTITY_REFERENCE |
| SHIPMENT | SHIPMENT_STATUS | OPERATIONAL_STATE |
| SHIPMENT | EXPECTED_DELIVERY_DATE | BUSINESS_DATE |
| SHIPMENT_EVENT | EVENT_ID | IDENTIFIER |
| SHIPMENT_EVENT | SHIPMENT_ID | ENTITY_REFERENCE |
| SHIPMENT_EVENT | EVENT_TIMESTAMP | EVENT_TIMESTAMP |
| SHIPMENT_EVENT | EVENT_STATUS | OBSERVED_STATE |
| SHIPMENT_EVENT | EVENT_ISSUE_CODE | EVIDENCE_CODE |
| SHIPMENT_EVENT | EVENT_DESCRIPTION | EVIDENCE_DESCRIPTION |
| DELIVERY_ISSUE | ISSUE_ID | IDENTIFIER |
| DELIVERY_ISSUE | ISSUE_CATEGORY_NAME | BUSINESS_CLASSIFICATION |
| DELIVERY_ISSUE | ISSUE_DESCRIPTION | BUSINESS_DESCRIPTION |

There is no separately deployed PROPERTY_DEFINITION
table in the current ONTOLOGY schema.

## 5. Canonical Relationship-to-Ontology Mapping

| Canonical Relationship | Source Class | Target Class | Source Cardinality | Target Cardinality | Optional | Inverse |
|---|---|---|---|---|---|---|
| PLACED | CUSTOMER | CUSTOMER_ORDER | 1 | 0..N | TRUE | PLACED_BY |
| FULFILLED_BY | CUSTOMER_ORDER | SHIPMENT | 1 | 1 | FALSE | FULFILLS |
| HAS_EVENT | SHIPMENT | SHIPMENT_EVENT | 1 | 1..N | FALSE | EVENT_OF |
| CLASSIFIED_AS | SHIPMENT | DELIVERY_ISSUE | 0..N | 0..1 | TRUE | CLASSIFIES |
| SUBCATEGORY_OF | DELIVERY_ISSUE | DELIVERY_ISSUE | 0..N | 0..1 | TRUE | HAS_SUBCATEGORY |

The relationship definitions are stored in
ONTOLOGY.RELATIONSHIP_DEFINITION.

Cardinality, optionality, and inverse names reproduce
the values in sql/cp03_ontology_definitions.sql.

The inverse names are metadata declarations, not
additional materialized KG edge types.

## 6. Delivery Issue Taxonomy

The hierarchy is stored in ONTOLOGY.ISSUE_TAXONOMY.

| Child Issue | Parent Issue | Relationship |
|---|---|---|
| ISS_002 | ISS_001 | SUBCATEGORY_OF |
| ISS_003 | ISS_001 | SUBCATEGORY_OF |
| ISS_004 | ISS_001 | SUBCATEGORY_OF |
| ISS_005 | ISS_001 | SUBCATEGORY_OF |

ISS_001 represents Delivery Delay.

The child categories are:

- ISS_002: Warehouse Dispatch Delay
- ISS_003: Carrier Delay
- ISS_004: Weather Delay
- ISS_005: Warehouse Inactivity

SUBCATEGORY_OF represents a classification hierarchy,
not a causal relationship.

A recorded Warehouse Inactivity classification does
not independently establish operational root cause.

## 7. Ontology-to-Knowledge-Graph Alignment

ONTOLOGY.KG_NODE materializes business entity instances.

ONTOLOGY.KG_EDGE materializes relationship instances.

The validated demonstration baseline contains:

| Component | Count |
|---|---:|
| Ontology classes | 5 |
| Relationship definitions | 5 |
| Property entries | 20 |
| Taxonomy mappings | 4 |
| KG nodes | 20 |
| KG edges | 19 |

KG nodes retain source identity and source-table lineage.

KG edges retain source and target node identifiers,
relationship types, and provenance references.

The canonical model provides the logical interpretation
of these existing graph structures.

## 8. Validation and Implementation Boundary

CAN2-CAN5 validation established alignment across
canonical entities, physical attributes, ontology
metadata, and existing graph structures.

Validated results include:

- Five canonical entities aligned to five ontology classes.
- Twenty canonical attributes aligned to property metadata.
- Five relationships aligned to relationship definitions.
- Four taxonomy mappings aligned to the issue hierarchy.
- Twenty KG nodes traceable to source records.
- Nineteen KG edges traceable to source relationships.
- CP05 business reasoning continuity confirmed.

The validation applies to the existing demonstration
baseline and is not an automatic ongoing enforcement
mechanism.

This documentation does not introduce:

- A physical CANONICAL schema.
- A separate PROPERTY_DEFINITION table.
- Additional KG nodes or edges.
- New inverse relationship edges.
- Changes to CP03 or CP04 SQL.
- Changes to CP05 decision logic.
- Semantic Views, Cortex Agents, or MCP integrations.

## 9. Source of Truth

- sql/cp01_core_schema.sql
- sql/cp03_ontology_definitions.sql
- sql/cp04_kg_materialization.sql
- sql/cp05_investigation.sql
- docs/canonical_business_model.md
- docs/canonical_physical_mapping.md