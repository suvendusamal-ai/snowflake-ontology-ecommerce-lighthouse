# CP10 Acceptance Report — 2026-10-29

| Checkpoint | Observed evidence | Result |
|---|---|---|
| CP10.1 | 7 ontology objects in inventory | PASS |
| CP10.2 | 20 unique nodes, 19 unique edges, 5 relationship types, 0 dangling endpoints | PASS |
| CP10.3 | Order 7821: 74h eligible; 7822: 27h not eligible; 7823: 21h not eligible; all root causes NOT_ESTABLISHED | PASS |
| CP10.4 | Semantic metrics: 3 investigated, 1 eligible, 2 not eligible | PASS |
| CP10.5 | Published agent: Analyst SQL successful; KG custom tool returned five provenance-bearing edges | PASS |
| CP10.6 | Default `VERSION$3`, Analyst and custom tool configured with warehouse and 120s timeout | PASS |
| CP10.7 | Source/KG count parity: CUSTOMER 2, CUSTOMER_ORDER 3, DELIVERY_ISSUE 5, SHIPMENT 3, SHIPMENT_EVENT 7 | PASS |

## Tested KG relationships for order 7821

1. `CUSTOMER_ORDER:7821` — `FULFILLED_BY` → `SHIPMENT:SHP_7821`; provenance `CORE.SHIPMENT` / `SHP_7821`.
2. `SHIPMENT:SHP_7821` — `HAS_EVENT` → `SHIPMENT_EVENT:EVT_001`; provenance `CORE.SHIPMENT_EVENT` / `EVT_001`.
3. `SHIPMENT:SHP_7821` — `HAS_EVENT` → `SHIPMENT_EVENT:EVT_002`; provenance `CORE.SHIPMENT_EVENT` / `EVT_002`.
4. `SHIPMENT:SHP_7821` — `CLASSIFIED_AS` → `DELIVERY_ISSUE:ISS_005`; provenance `CORE.SHIPMENT` / `SHP_7821`.
5. `DELIVERY_ISSUE:ISS_005` — `SUBCATEGORY_OF` → `DELIVERY_ISSUE:ISS_001`; provenance `ONTOLOGY.ISSUE_TAXONOMY` / `ISS_005`.

## Limits of acceptance

- CP10.7 verifies count parity, not full key-by-key source-to-KG parity or automatic synchronization.
- These tests validate the demonstration dataset and the published agent at the time tested; they are not a production SLA, load test, or adversarial safety evaluation.
- Agent response accurately declined to infer a root cause from issue taxonomy.
