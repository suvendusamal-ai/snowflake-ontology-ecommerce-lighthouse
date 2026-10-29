# CP06–CP10 Implementation Record

## CP06 — Semantic investigation

Created `ONTOLOGY.V_ORDER_DELIVERY_INVESTIGATION` over the CP05 ontology/KG-grounded deterministic investigation, then `ONTOLOGY.SV_ORDER_DELIVERY_INVESTIGATION`. Governed metrics: `investigations.order_count`, `investigations.eligible_order_count`, `investigations.not_eligible_order_count`.

## CP07 — KG evidence

Validated order 7821 traversal: `CUSTOMER_ORDER:7821` → `SHIPMENT:SHP_7821` → events `EVT_001`/`EVT_002`, issue `ISS_005` → taxonomy parent `ISS_001`. Created `ONTOLOGY.V_KG_EDGE_EVIDENCE` exposing source and target node IDs/types, edge type, source table/record and provenance.

## CP08 — Cortex Agent

The initial agent encountered Analyst execution environment errors. A replacement `ONTOLOGY.ORDER_DELIVERY_AGENT_V2` was created in Snowsight with Analyst tool `order-delivery-analyst`, semantic view `SV_ORDER_DELIVERY_INVESTIGATION`, warehouse `SNOWFLAKE_LEARNING_WH`, query timeout 120 seconds. Analyst Preview succeeded. The published agent was subsequently tested using `SNOWFLAKE.CORTEX.DATA_AGENT_RUN`.

## CP09 — Custom KG evidence function

Created read-only SQL UDF `ONTOLOGY.GET_ORDER_KG_EVIDENCE(P_ORDER_ID VARCHAR) RETURNS ARRAY`. Registered as custom function tool `get_order_kg_evidence` with required string parameter `p_order_id`, execution warehouse `SNOWFLAKE_LEARNING_WH`, timeout 120 seconds. Published `VERSION$3` contains both tools. The published agent successfully called this tool for order 7821, returning five relationships and their provenance.

## CP10 — Technical acceptance

See [acceptance.md](acceptance.md). All seven checks passed. Final packaging and operational handoff remain separate from technical acceptance.

## Reproducibility note

This package documents the validated objects and provides **read-only validation SQL**. It does not pretend to reconstruct exact CREATE VIEW, CREATE SEMANTIC VIEW, UDF bodies, or CREATE AGENT specifications without source-controlled definitions. Export or reconcile those definitions from the existing repo and Snowflake before claiming fully reproducible deployment.
