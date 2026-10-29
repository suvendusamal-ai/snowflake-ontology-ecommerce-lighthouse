# Snowflake Ontology E-commerce Lighthouse — Part 2 (CP06–CP10)

**Status:** CP06–CP10 technical implementation and seven CP10 regression checks validated on 2026-10-29. Repository packaging is a documentation handoff, not a fresh deployment verification.

## Architecture

See [docs/architecture.md](docs/architecture.md), [docs/implementation.md](docs/implementation.md), and [docs/acceptance.md](docs/acceptance.md).

- Database: `ECOM_ONTOLOGY_LIGHTHOUSE_DB`
- Warehouse: `SNOWFLAKE_LEARNING_WH`
- Governed investigation: `ONTOLOGY.V_ORDER_DELIVERY_INVESTIGATION`
- Semantic view: `ONTOLOGY.SV_ORDER_DELIVERY_INVESTIGATION`
- Evidence view: `ONTOLOGY.V_KG_EDGE_EVIDENCE`
- Evidence function: `ONTOLOGY.GET_ORDER_KG_EVIDENCE(VARCHAR)` (returns ARRAY)
- Published Cortex Agent: `ONTOLOGY.ORDER_DELIVERY_AGENT_V2`, default `VERSION$3`

## Quick validation

Run statements in [sql/cp10_read_only_validation.sql](sql/cp10_read_only_validation.sql) **individually**, following the project's one-statement-at-a-time protocol. The script contains read-only queries and a published-agent invocation; agent calls incur model/query usage.

## Important guardrails

- Graph tables `KG_NODE` and `KG_EDGE` are materialized snapshots, **not** automatically synchronized with CORE.
- `SUBCATEGORY_OF` is an issue classification relationship, **not** proof of causation.
- Escalation is based on the deterministic CP05 policy, not an LLM decision.
- Evaluation baseline: 2026-10-12 12:00 UTC; strict inactivity threshold >48 hours; latest event must be `AT_WAREHOUSE` and unambiguous, with shipment `AT_WAREHOUSE`.
- Root cause remains `NOT_ESTABLISHED` for all three demonstration orders.
- The custom KG function returns edge IDs, node IDs, relationship types and provenance; it does **not** return event timestamps or issue names.

## Repository integration

Copy this package's files into the existing repository, preserving existing Part 1 and canonical model files. Review the existing root README before merging this README; it should be incorporated as a Part 2 section rather than overwriting the root document.
