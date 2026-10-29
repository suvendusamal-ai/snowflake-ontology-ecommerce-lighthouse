# Snowflake Ontology E-commerce Lighthouse

**Part 1 — Ontology Engineering and Knowledge Graph Investigation (CP01–CP05)**

An explainable e-commerce delivery investigation built using
Snowflake SQL, business ontology definitions, a materialized
knowledge graph, and deterministic decision policies.

## Business Problem

A shipment has remained at a warehouse for an extended period.

Can we determine whether it qualifies for an inactivity
investigation, explain the evidence, and avoid incorrectly
claiming that the underlying root cause has been established?

This lighthouse demonstrates how business relationships,
taxonomy, graph traversal, and operational events can support
an auditable decision.

## Architecture

### L0 — Conceptual Architecture

[View vertical architecture](docs/L0_conceptual_architecture.md)

### L1 — Technical Architecture

[View horizontal architecture](docs/L1_technical_architecture.md)

Both diagrams use Mermaid and are intended for GitHub rendering.

## Canonical Business Model Retrofit

Following the original CP01–CP05 implementation,
a Canonical Business Model was introduced as a
logical business contract between the existing
CORE physical schema and ONTOLOGY semantic metadata.

The resulting conceptual architecture is:

```text
CORE Physical Data Model
          |
          v
Canonical Business Model (Logical)
          |
          v
Ontology Semantic Metadata
          |
          v
Materialized Knowledge Graph
          |
          v
CP05 Business Reasoning
```

The canonical model defines five business entities,
20 attributes, and five relationships, aligned with
the existing ontology and physical source structures.

This is a logical architecture refinement, not an
additional deployed data-processing layer.

The existing CP04 and CP05 SQL scripts continue to read
CORE and ONTOLOGY objects directly.

The CAN2–CAN5 retrofit validated the existing
20 KG nodes, 19 KG edges, provenance relationships,
and CP05 business reasoning continuity.

Detailed documentation:

- [Canonical Business Model](docs/canonical_business_model.md)
- [Canonical-to-Physical Mapping](docs/canonical_physical_mapping.md)
- [Canonical-to-Ontology Alignment](docs/canonical_ontology_alignment.md)
- [Canonical-to-KG Traceability](docs/canonical_kg_traceability.md)
- [Canonical Validation Summary](evidence/canonical_validation_summary.md)

## Implementation Checkpoints

| Checkpoint | Capability | Deliverable |
|---|---|---|
| CP01 | Business data foundation | Five CORE tables |
| CP02 | Synthetic data | Customers, orders, shipments, issues, events |
| CP03 | Ontology engineering | Five classes, five relationships, issue taxonomy |
| CP04 | Knowledge graph | KG_NODE and KG_EDGE materialization |
| CP05 | Explainable investigation | Graph traversal and deterministic decision policy |

## Demonstration Baseline

| Metric | Verified Value |
|---|---:|
| Ontology classes | 5 |
| Relationship definitions | 5 |
| Issue taxonomy mappings | 4 |
| Graph nodes | 20 |
| Graph edges | 19 |
| Orphan graph endpoints | 0 |
| Investigated orders | 3 |
| Passing boundary tests | 4/4 |

Structural metrics were verified in the demonstration
environment. Original structural CLI outputs are not yet
included in the repository evidence package.

## Business Results

Evaluation timestamp: `2026-10-12 12:00:00`.

| Order | Inactive Hours | Decision | Root Cause |
|---|---:|---|---|
| 7821 | 74 | ELIGIBLE | NOT_ESTABLISHED |
| 7822 | 27 | NOT_ELIGIBLE | NOT_ESTABLISHED |
| 7823 | 21 | NOT_ELIGIBLE | NOT_ESTABLISHED |

Eligibility requires warehouse status, the recorded
Warehouse Inactivity issue classification, a latest
AT_WAREHOUSE event, and inactivity strictly greater
than 48 hours.

**Classification is not proof of root cause.**

## Repository Structure

```text
snowflake-ontology/
├── README.md
├── docs/
│   ├── L0_conceptual_architecture.md
│   ├── L1_technical_architecture.md
│   ├── implementation_guide.md
│   ├── canonical_business_model.md
│   ├── canonical_physical_mapping.md
│   ├── canonical_ontology_alignment.md
│   └── canonical_kg_traceability.md
├── sql/
│   ├── cp01_core_schema.sql
│   ├── cp02_seed_data.sql
│   ├── cp03_ontology_definitions.sql
│   ├── cp04_kg_materialization.sql
│   ├── cp05_investigation.sql
│   ├── cp05_acceptance_tests.sql
│   └── cp1_ontology_foundation.sql
└── evidence/
    ├── README.md
    ├── cp05_investigation.txt
    ├── cp05_acceptance_tests.txt
    └── canonical_validation_summary.md
```

The legacy `cp1_ontology_foundation.sql` is preserved for
historical reference and is not part of the deployment sequence.

## Getting Started

Prerequisites:
- Snowflake account and an authorized deployment role
- Snowflake CLI
- An isolated demonstration database
- Windows PowerShell for the documented commands

See the [implementation guide](docs/implementation_guide.md)
for environment configuration, execution sequence,
expected outputs, and limitations.

## Evidence

- [Evidence index](evidence/README.md)
- [Investigation output](evidence/cp05_investigation.txt)
- [Boundary acceptance output](evidence/cp05_acceptance_tests.txt)

CP05 investigation and acceptance tests were executed
successfully against the demonstration environment.

CP01–CP04 scripts have been source-verified but have not
yet undergone an independent clean-environment deployment.

## Design Principles

1. Define business semantics before materializing graph edges.
2. Preserve source provenance for graph relationships.
3. Separate recorded classification from causal inference.
4. Use deterministic policies for reproducible decisions.
5. Handle missing, ambiguous, and future event evidence.
6. Make limitations and validation status explicit.

## Part 2 Roadmap — CP06–CP10

The next phase will explore semantic access and agentic AI
capabilities, including Snowflake Cortex Agent integration,
appropriate tools, and MCP where applicable.

Part 2 is planned and is not included in this implementation.

## Disclaimer

This project uses synthetic data for architecture learning
and demonstration. It is not a production delivery
decisioning system.
