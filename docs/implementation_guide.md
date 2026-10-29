# Implementation Guide — Part 1 (CP01–CP05)

## Objective

Reproduce an ontology-driven e-commerce delivery investigation
using Snowflake SQL, materialized graph relationships, and
deterministic decision policies.

## Environment

- Snowflake CLI connection: `hol`
- Database: `ECOM_ONTOLOGY_LIGHTHOUSE_DB`
- Schemas: `CORE`, `ONTOLOGY`
- Warehouse: `SNOWFLAKE_LEARNING_WH`
- Execution role used in the demonstration: `ACCOUNTADMIN`
- Operating system: Windows PowerShell

Use an appropriately authorized deployment role in other environments.

## Prerequisites

1. Install and configure Snowflake CLI.
2. Configure a connection with permission to create the required objects.
3. Confirm the target account, role, and warehouse.
4. Review every SQL script before execution.
5. Use an isolated demonstration database.

The packaged SQL uses fully qualified object references.

## Canonical Business Model — Logical Architecture Retrofit

The Canonical Business Model was documented retrospectively
after the original CP01–CP05 implementation.

It defines:
- 5 canonical business entities
- 20 canonical attributes
- 5 canonical business relationships

The model provides a logical business contract between
the existing CORE physical tables and ONTOLOGY metadata.

It does not introduce a CANONICAL schema, additional tables,
transformation jobs, or a new execution checkpoint.

The implementation remains unchanged:

- CP01–CP02 establish and populate CORE business data.
- CP03 defines ontology classes, relationships, and taxonomy.
- CP04 materializes KG_NODE and KG_EDGE from existing sources.
- CP05 performs graph traversal and deterministic reasoning.

The canonical model documents how these existing components
align. It is not an additional runtime processing stage.

The 20 ontology semantic properties reside in
`ONTOLOGY.CLASS_DEFINITION.PROPERTIES` (VARIANT).
There is no separate PROPERTY_DEFINITION table.

Canonical documentation:

- [Canonical Business Model](canonical_business_model.md)
- [Canonical-to-Physical Mapping](canonical_physical_mapping.md)
- [Canonical-to-Ontology Alignment](canonical_ontology_alignment.md)
- [Canonical-to-KG Traceability](canonical_kg_traceability.md)
## Execution Sequence

Run from the repository root.

### CP01 — Core Schema

```powershell
snow sql -c hol -f .\sql\cp01_core_schema.sql
```

Creates the database, schemas, and five business tables.

### CP02 — Seed Data

```powershell
snow sql -c hol -f .\sql\cp02_seed_data.sql
```

Loads the synthetic customer, order, shipment, issue,
and shipment-event records using insert-only MERGE statements.

### CP03 — Ontology Definitions

```powershell
snow sql -c hol -f .\sql\cp03_ontology_definitions.sql
```

Creates ontology metadata tables and registers:
- 5 classes
- 5 relationship definitions
- 4 taxonomy mappings

### CP04 — Knowledge Graph Materialization

```powershell
snow sql -c hol -f .\sql\cp04_kg_materialization.sql
```

Creates and populates:
- ONTOLOGY.KG_NODE
- ONTOLOGY.KG_EDGE

Expected demonstration baseline:
- 20 unique nodes
- 19 unique edges
- No orphan graph endpoints

### CP05 — Investigation

```powershell
snow sql -c hol -f .\sql\cp05_investigation.sql
```

Expected results at the fixed evaluation timestamp:

| Order | Decision | Root Cause |
|---|---|---|
| 7821 | ELIGIBLE | NOT_ESTABLISHED |
| 7822 | NOT_ELIGIBLE | NOT_ESTABLISHED |
| 7823 | NOT_ELIGIBLE | NOT_ESTABLISHED |

### CP05 — Boundary Acceptance Tests

```powershell
snow sql -c hol -f .\sql\cp05_acceptance_tests.sql
```

Expected: 4/4 PASS.

Test coverage:
- Ambiguous latest timestamp
- Exactly 48 hours
- Future event timestamp
- Greater than 48 hours

These tests validate boundary logic, not every
shipment-status and issue-classification safeguard.

## Decision Policy

Evaluation timestamp: `2026-10-12 12:00:00` (TIMESTAMP_NTZ).

An order is eligible only when its shipment is at the warehouse,
the recorded issue is Warehouse Inactivity (ISS_005),
the latest event is AT_WAREHOUSE, and inactivity exceeds 48 hours.

Missing, ambiguous, and future latest-event evidence are
handled explicitly. Classification alone does not prove root cause.

## Reproducibility and Limitations

- CP01–CP04 scripts were packaged and source-verified.
- The packaged CP01–CP04 sequence has not yet been independently
  executed against a clean environment.
- CP05 investigation executed successfully for three orders.
- CP05 boundary tests passed 4/4.
- Insert-only MERGE does not synchronize deletions or updates.
- Snowflake key constraints may be informational; validate
  uniqueness and referential integrity explicitly.
- The demonstration assumes UTC interpretation for
  TIMESTAMP_NTZ shipment events.
- The fixed evaluation timestamp makes results reproducible.
- This is a deterministic SQL demonstration, not an LLM-based
  root-cause inference system.

## Architecture References

- `docs/L0_conceptual_architecture.md`
- `docs/L1_technical_architecture.md`

## Future Scope

CP06–CP10 will introduce semantic access, Cortex Agent
integration, and applicable tools/MCP capabilities.
