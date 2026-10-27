-- CP02: Synthetic E-commerce Delivery Data
-- Idempotent seed loading: existing business records are preserved.
-- Run after cp01_core_schema.sql.

MERGE INTO ECOM_ONTOLOGY_LIGHTHOUSE_DB.CORE.CUSTOMER t
USING (
    SELECT column1 AS CUSTOMER_ID, column2 AS CUSTOMER_NAME
    FROM VALUES
        ('CUST_001', 'James'),
        ('CUST_002', 'Neha')
) s
ON t.CUSTOMER_ID = s.CUSTOMER_ID
WHEN NOT MATCHED THEN
    INSERT (CUSTOMER_ID, CUSTOMER_NAME)
    VALUES (s.CUSTOMER_ID, s.CUSTOMER_NAME);

MERGE INTO ECOM_ONTOLOGY_LIGHTHOUSE_DB.CORE.CUSTOMER_ORDER t
USING (
    SELECT column1 AS ORDER_ID,
           column2 AS CUSTOMER_ID,
           TO_DATE(column3) AS ORDER_DATE,
           column4 AS ORDER_AMOUNT
    FROM VALUES
        (7821, 'CUST_001', '2026-10-08', 2500.00),
        (7822, 'CUST_002', '2026-10-10', 1800.00),
        (7823, 'CUST_001', '2026-10-09', 3200.00)
) s
ON t.ORDER_ID = s.ORDER_ID
WHEN NOT MATCHED THEN
    INSERT (ORDER_ID, CUSTOMER_ID, ORDER_DATE, ORDER_AMOUNT)
    VALUES (s.ORDER_ID, s.CUSTOMER_ID, s.ORDER_DATE, s.ORDER_AMOUNT);

MERGE INTO ECOM_ONTOLOGY_LIGHTHOUSE_DB.CORE.DELIVERY_ISSUE t
USING (
    SELECT column1 AS ISSUE_ID,
           column2 AS ISSUE_CATEGORY_NAME,
           column3 AS ISSUE_DESCRIPTION
    FROM VALUES
        ('ISS_001', 'Delivery Delay',
         'Parent category for delivery-related delays'),
        ('ISS_002', 'Warehouse Dispatch Delay',
         'Confirmed delay in dispatching a shipment from the warehouse'),
        ('ISS_003', 'Carrier Delay',
         'Confirmed delay during carrier transportation'),
        ('ISS_004', 'Weather Delay',
         'Delivery disruption associated with adverse weather conditions'),
        ('ISS_005', 'Warehouse Inactivity',
         'Shipment remains at warehouse beyond an approved inactivity threshold')
) s
ON t.ISSUE_ID = s.ISSUE_ID
WHEN NOT MATCHED THEN
    INSERT (ISSUE_ID, ISSUE_CATEGORY_NAME, ISSUE_DESCRIPTION)
    VALUES (s.ISSUE_ID, s.ISSUE_CATEGORY_NAME, s.ISSUE_DESCRIPTION);

MERGE INTO ECOM_ONTOLOGY_LIGHTHOUSE_DB.CORE.SHIPMENT t
USING (
    SELECT column1 AS SHIPMENT_ID,
           column2 AS ORDER_ID,
           column3 AS ISSUE_ID,
           column4 AS SHIPMENT_STATUS,
           TO_DATE(column5) AS EXPECTED_DELIVERY_DATE
    FROM VALUES
        ('SHP_7821', 7821, 'ISS_005', 'AT_WAREHOUSE', '2026-10-11'),
        ('SHP_7822', 7822, 'ISS_004', 'IN_TRANSIT', '2026-10-12'),
        ('SHP_7823', 7823, NULL, 'DELIVERED', '2026-10-12')
) s
ON t.SHIPMENT_ID = s.SHIPMENT_ID
WHEN NOT MATCHED THEN
    INSERT (SHIPMENT_ID, ORDER_ID, ISSUE_ID,
            SHIPMENT_STATUS, EXPECTED_DELIVERY_DATE)
    VALUES (s.SHIPMENT_ID, s.ORDER_ID, s.ISSUE_ID,
            s.SHIPMENT_STATUS, s.EXPECTED_DELIVERY_DATE);

MERGE INTO ECOM_ONTOLOGY_LIGHTHOUSE_DB.CORE.SHIPMENT_EVENT t
USING (
    SELECT column1 AS EVENT_ID,
           column2 AS SHIPMENT_ID,
           TO_TIMESTAMP_NTZ(column3) AS EVENT_TIMESTAMP,
           column4 AS EVENT_STATUS,
           column5 AS EVENT_ISSUE_CODE,
           column6 AS EVENT_DESCRIPTION
    FROM VALUES
        ('EVT_001', 'SHP_7821', '2026-10-08 09:00:00',
         'PACKED', NULL, 'Order packed at warehouse'),
        ('EVT_002', 'SHP_7821', '2026-10-09 10:00:00',
         'AT_WAREHOUSE', NULL, 'Shipment awaiting dispatch'),
        ('EVT_003', 'SHP_7822', '2026-10-10 08:00:00',
         'PACKED', NULL, 'Order packed'),
        ('EVT_004', 'SHP_7822', '2026-10-11 09:00:00',
         'IN_TRANSIT', 'WEATHER_DISRUPTION',
         'Carrier reported weather disruption'),
        ('EVT_005', 'SHP_7823', '2026-10-09 08:00:00',
         'PACKED', NULL, 'Order packed'),
        ('EVT_006', 'SHP_7823', '2026-10-10 12:00:00',
         'IN_TRANSIT', NULL, 'Shipment handed to carrier'),
        ('EVT_007', 'SHP_7823', '2026-10-11 15:00:00',
         'DELIVERED', NULL, 'Shipment delivered successfully')
) s
ON t.EVENT_ID = s.EVENT_ID
WHEN NOT MATCHED THEN
    INSERT (EVENT_ID, SHIPMENT_ID, EVENT_TIMESTAMP,
            EVENT_STATUS, EVENT_ISSUE_CODE, EVENT_DESCRIPTION)
    VALUES (s.EVENT_ID, s.SHIPMENT_ID, s.EVENT_TIMESTAMP,
            s.EVENT_STATUS, s.EVENT_ISSUE_CODE, s.EVENT_DESCRIPTION);
