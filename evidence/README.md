# Evidence — E-commerce Ontology Lighthouse

## Part 1: CP01–CP05

This directory contains captured Snowflake CLI output supporting
the deterministic ontology-driven delivery investigation.

## Captured Evidence

| File | Purpose | Result |
|---|---|---|
| cp05_investigation.txt | Graph-grounded delivery investigation | 3 expected order decisions |
| cp05_acceptance_tests.txt | Deterministic boundary tests | 4/4 PASS |

## Investigation Results

Evaluation timestamp: 2026-10-12 12:00:00 (TIMESTAMP_NTZ).

| Order | Inactive Hours | Decision | Root Cause |
|---|---:|---|---|
| 7821 | 74 | ELIGIBLE | NOT_ESTABLISHED |
| 7822 | 27 | NOT_ELIGIBLE | NOT_ESTABLISHED |
| 7823 | 21 | NOT_ELIGIBLE | NOT_ESTABLISHED |

Order 7821 meets the warehouse inactivity policy.
This does not establish the operational root cause.

## Boundary Test Results

| Test | Expected Decision | Result |
|---|---|---|
| AMBIGUOUS_TIMESTAMP | AMBIGUOUS_LATEST_EVENT | PASS |
| EXACTLY_48_HOURS | NOT_ELIGIBLE | PASS |
| FUTURE_EVENT | FUTURE_EVENT | PASS |
| OVER_48_HOURS | ELIGIBLE | PASS |

The boundary tests exercise the event-timestamp and threshold
decision logic. They do not independently validate every
shipment-status and issue-classification safeguard.

## Structural Validation

Previously verified in the demonstration environment:

- 5 ontology classes
- 5 relationship definitions
- 4 issue taxonomy mappings
- 20 unique graph nodes
- 19 unique graph edges
- 0 orphan graph endpoints
- 19/19 deterministic edge identifiers validated
- 19/19 edge provenance references resolved

These structural checks were performed during implementation.
Their original CLI outputs have not yet been packaged here.

## Reproducibility Limitations

- CP01–CP04 scripts are source-verified but have not undergone
  an independent clean-environment deployment.
- CP05 investigation and boundary tests were executed successfully.
- Evidence represents synthetic demonstration data.
- Event timestamps are interpreted as UTC.
- Issue classification is not proof of root cause.
- Part 1 does not implement Cortex Agents, LLM inference, or MCP.

## Reproduce the Evidence

From the repository root:

```powershell
snow sql -c hol -f .\sql\cp05_investigation.sql
snow sql -c hol -f .\sql\cp05_acceptance_tests.sql
```

See `docs/implementation_guide.md` for the full deployment sequence.
