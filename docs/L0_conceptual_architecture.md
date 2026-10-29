# L0 — E-commerce Delivery Ontology Lighthouse

## Part 1: CP01–CP05

```mermaid
flowchart TB
    A["E-commerce Delivery Data<br/>Customers | Orders | Shipments | Events | Issues"]
    B["Canonical Business Model (Logical)<br/>5 Entities | 20 Attributes | 5 Relationships"]
    C["Business Ontology<br/>5 Classes | 5 Relationships | Issue Taxonomy"]
    D["Knowledge Graph<br/>20 Nodes | 19 Edges | Provenance"]
    E["Explainable Investigation<br/>Graph Traversal | Event Evidence | 48-Hour Policy"]
    F["Business Decision<br/>ELIGIBLE / NOT_ELIGIBLE<br/>Root Cause: NOT_ESTABLISHED"]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F

    style B stroke:#64748b,stroke-width:2px,stroke-dasharray:5 5
```

The Canonical Business Model is a logical architecture
contract, not a deployed Snowflake schema or an additional
runtime transformation stage. Existing CP04/CP05 SQL
continues to access CORE and ONTOLOGY objects directly.

## Business Objective

Investigate delayed e-commerce deliveries using explicit business
relationships, recorded classifications, and timestamped evidence.

## Architecture Principles

- Canonical Business Model defines the logical business contract
  between CORE physical data and ontology metadata.
- Business ontology defines entities and their relationships.
- Knowledge graph materializes navigable business relationships.
- Graph traversal retrieves delivery context and event evidence.
- Deterministic SQL evaluates the inactivity policy.
- Issue classification does not independently establish root cause.
- Part 1 does not use Cortex Agents, LLM inference, or MCP.

## Demonstration Baseline

- 5 ontology classes
- 5 relationship types
- 4 issue taxonomy mappings
- 20 graph nodes
- 19 graph edges
- 3 investigated orders
- 4 passing boundary tests

## Part 2 — Future Scope

Semantic access, Cortex Agent integration, tools, and MCP
will be addressed in CP06–CP10.
