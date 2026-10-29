# Canonical-to-Knowledge-Graph Traceability

## 1. Purpose

This document describes how the Canonical Business Model
is represented by the existing materialized Knowledge Graph.

Database: ECOM_ONTOLOGY_LIGHTHOUSE_DB
Schema: ONTOLOGY

The traceability analysis was validated during CAN5.

No new graph materialization or graph redesign is required.

## 2. Architecture Alignment

CORE Physical Model
    |
    v
Canonical Business Model (Logical)
    |
    v
Ontology Semantic Metadata
    |
    v
KG_NODE and KG_EDGE
    |
    v
CP05 Business Reasoning

This is a logical architecture representation.

The actual CP04 SQL materializes graph records directly
from CORE tables and ONTOLOGY.ISSUE_TAXONOMY.

## 3. Canonical Entity-to-KG Node Mapping

| Canonical Entity | KG Node Type | Source Table | Verified Nodes |
|---|---|---|---:|
| CUSTOMER | CUSTOMER | CORE.CUSTOMER | 2 |
| CUSTOMER_ORDER | CUSTOMER_ORDER | CORE.CUSTOMER_ORDER | 3 |
| SHIPMENT | SHIPMENT | CORE.SHIPMENT | 3 |
| SHIPMENT_EVENT | SHIPMENT_EVENT | CORE.SHIPMENT_EVENT | 7 |
| DELIVERY_ISSUE | DELIVERY_ISSUE | CORE.DELIVERY_ISSUE | 5 |
| TOTAL | | | 20 |

KG_NODE stores:

- NODE_ID
- NODE_TYPE
- SOURCE_TABLE
- SOURCE_ID

NODE_ID is constructed as:

NODE_TYPE || ':' || SOURCE_ID

Numeric ORDER_ID values are converted to VARCHAR.

SOURCE_TABLE contains the fully qualified physical
source-table name.

CAN5 validated all 20 nodes against their source records.

No missing source records or duplicate node identifiers
were identified in the validated demonstration baseline.

## 4. Canonical Relationship-to-KG Edge Mapping

| Canonical Relationship | Source Node | Target Node | Provenance Source | Provenance ID | Edges |
|---|---|---|---|---|---:|
| PLACED | CUSTOMER | CUSTOMER_ORDER | CORE.CUSTOMER_ORDER | ORDER_ID | 3 |
| FULFILLED_BY | CUSTOMER_ORDER | SHIPMENT | CORE.SHIPMENT | SHIPMENT_ID | 3 |
| HAS_EVENT | SHIPMENT | SHIPMENT_EVENT | CORE.SHIPMENT_EVENT | EVENT_ID | 7 |
| CLASSIFIED_AS | SHIPMENT | DELIVERY_ISSUE | CORE.SHIPMENT | SHIPMENT_ID | 2 |
| SUBCATEGORY_OF | DELIVERY_ISSUE | DELIVERY_ISSUE | ONTOLOGY.ISSUE_TAXONOMY | CHILD_ISSUE_ID | 4 |
| TOTAL | | | | | 19 |

KG_EDGE stores:

- EDGE_ID
- EDGE_TYPE
- SOURCE_NODE_ID
- TARGET_NODE_ID
- PROVENANCE_SOURCE
- PROVENANCE_ID

The relationship direction follows the existing
ONTOLOGY.RELATIONSHIP_DEFINITION metadata.

Inverse relationship names are metadata only.
No additional inverse edges are materialized.

## 5. Deterministic Edge Identity

CP04 generates EDGE_ID using SHA2 with 256-bit output.

The hash input is constructed from length-prefixed
values for:

1. EDGE_TYPE
2. SOURCE_NODE_ID
3. TARGET_NODE_ID

This supports deterministic identity for a particular
relationship type and endpoint pair.

The edge ID does not include provenance fields.

Therefore, changing provenance without changing the
relationship type or endpoints does not produce a new
edge identifier.

## 6. Provenance Validation

CAN5 validated the following conditions:

| Validation | Result |
|---|---|
| Edge provenance fields populated | PASS |
| Provenance references resolve | PASS |
| Source and target node classes correct | PASS |
| Physical relationship endpoints agree | PASS |
| Missing source nodes | 0 |
| Missing target nodes | 0 |
| Missing source relationships in KG | 0 |
| Stale relationships in validated baseline | 0 |

The provenance source is a fully qualified table name.

For SUBCATEGORY_OF, the provenance source is
ONTOLOGY.ISSUE_TAXONOMY rather than a CORE table.

## 7. Graph Coverage

CAN5 confirmed:

| Measure | Result |
|---|---:|
| KG nodes | 20 |
| Unique KG nodes | 20 |
| KG node types | 5 |
| KG edges | 19 |
| Unique KG edges | 19 |
| KG edge types | 5 |
| Dangling edge endpoints | 0 |

These measurements describe the validated dataset.

They are not guarantees for future source changes.

## 8. CP05 Business Reasoning Continuity

The existing investigation reads KG_NODE and KG_EDGE
to recover order, shipment, issue, taxonomy, and event
relationships.

It then evaluates operational evidence using
CORE.SHIPMENT and CORE.SHIPMENT_EVENT.

The canonical model does not change the CP05 query.

Validated demonstration results:

| Order | Inactive Hours | Decision | Root Cause |
|---|---:|---|---|
| 7821 | 74 | ELIGIBLE | NOT_ESTABLISHED |
| 7822 | 27 | NOT_ELIGIBLE | NOT_ESTABLISHED |
| 7823 | 21 | NOT_ELIGIBLE | NOT_ESTABLISHED |

Evaluation timestamp: 2026-10-12 12:00:00.

The inactivity policy requires a latest AT_WAREHOUSE
event, shipment status AT_WAREHOUSE, recorded issue
ISS_005, and inactivity strictly greater than 48 hours.

The CP05 SQL selects the latest event overall and
requires its status to be AT_WAREHOUSE for eligibility.

A recorded classification is not proof of root cause.

## 9. Materialization Limitations

The existing CP04 implementation uses insert-only MERGE.

It inserts missing nodes and edges but does not:

- Delete graph records removed from source data.
- Update existing node source attributes.
- Update provenance for an existing edge identifier.
- Automatically remove edges after relationship changes.
- Continuously enforce canonical cardinality rules.

The graph is not automatically synchronized with
operational source changes.

## 10. Validation Boundary

CAN5 confirmed bidirectional traceability for the
existing demonstration baseline:

- Canonical entity to CORE source to KG node.
- Canonical relationship to source relationship to KG edge.
- KG node back to CORE source record.
- KG edge back to provenance and source relationship.
- KG traversal continuity with CP05 reasoning.

No new KG nodes, KG edges, physical schemas,
runtime transformations, or CP05 SQL changes were
introduced by the canonical retrofit.

## 11. Source of Truth

- sql/cp03_ontology_definitions.sql
- sql/cp04_kg_materialization.sql
- sql/cp05_investigation.sql
- docs/canonical_business_model.md
- docs/canonical_ontology_alignment.md