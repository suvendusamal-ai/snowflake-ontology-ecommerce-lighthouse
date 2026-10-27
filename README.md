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
│   └── implementation_guide.md
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
    └── cp05_acceptance_tests.txt
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
