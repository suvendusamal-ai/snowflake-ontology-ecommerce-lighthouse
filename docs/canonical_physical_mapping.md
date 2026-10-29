# Canonical-to-Physical Mapping

## 1. Purpose

This document maps the Canonical Business Model to the
existing physical Snowflake CORE schema.

Database: ECOM_ONTOLOGY_LIGHTHOUSE_DB
Schema: CORE

The mapping is logical and introduces no new tables,
views, transformations, or materialization processes.

## 2. Canonical Attribute Mapping

### CUSTOMER

Physical table: CORE.CUSTOMER

| Canonical Attribute | Physical Column | Snowflake Type | Nullable | Constraint |
|---|---|---|---|---|
| CUSTOMER_ID | CUSTOMER_ID | VARCHAR(20) | NO | PK |
| CUSTOMER_NAME | CUSTOMER_NAME | VARCHAR(100) | NO | — |

### CUSTOMER_ORDER

Physical table: CORE.CUSTOMER_ORDER

| Canonical Attribute | Physical Column | Snowflake Type | Nullable | Constraint |
|---|---|---|---|---|
| ORDER_ID | ORDER_ID | NUMBER(10,0) | NO | PK |
| CUSTOMER_ID | CUSTOMER_ID | VARCHAR(20) | NO | FK → CUSTOMER.CUSTOMER_ID |
| ORDER_DATE | ORDER_DATE | DATE | NO | — |
| ORDER_AMOUNT | ORDER_AMOUNT | NUMBER(12,2) | NO | — |

### SHIPMENT

Physical table: CORE.SHIPMENT

| Canonical Attribute | Physical Column | Snowflake Type | Nullable | Constraint |
|---|---|---|---|---|
| SHIPMENT_ID | SHIPMENT_ID | VARCHAR(20) | NO | PK |
| ORDER_ID | ORDER_ID | NUMBER(10,0) | NO | UNIQUE, FK → CUSTOMER_ORDER.ORDER_ID |
| ISSUE_ID | ISSUE_ID | VARCHAR(20) | YES | FK → DELIVERY_ISSUE.ISSUE_ID |
| SHIPMENT_STATUS | SHIPMENT_STATUS | VARCHAR(30) | NO | — |
| EXPECTED_DELIVERY_DATE | EXPECTED_DELIVERY_DATE | DATE | NO | — |

### SHIPMENT_EVENT

Physical table: CORE.SHIPMENT_EVENT

| Canonical Attribute | Physical Column | Snowflake Type | Nullable | Constraint |
|---|---|---|---|---|
| EVENT_ID | EVENT_ID | VARCHAR(20) | NO | PK |
| SHIPMENT_ID | SHIPMENT_ID | VARCHAR(20) | NO | FK → SHIPMENT.SHIPMENT_ID |
| EVENT_TIMESTAMP | EVENT_TIMESTAMP | TIMESTAMP_NTZ(9) | NO | — |
| EVENT_STATUS | EVENT_STATUS | VARCHAR(30) | NO | — |
| EVENT_ISSUE_CODE | EVENT_ISSUE_CODE | VARCHAR(50) | YES | — |
| EVENT_DESCRIPTION | EVENT_DESCRIPTION | VARCHAR(500) | YES | — |

### DELIVERY_ISSUE

Physical table: CORE.DELIVERY_ISSUE

| Canonical Attribute | Physical Column | Snowflake Type | Nullable | Constraint |
|---|---|---|---|---|
| ISSUE_ID | ISSUE_ID | VARCHAR(20) | NO | PK |
| ISSUE_CATEGORY_NAME | ISSUE_CATEGORY_NAME | VARCHAR(100) | NO | — |
| ISSUE_DESCRIPTION | ISSUE_DESCRIPTION | VARCHAR(500) | YES | — |

## 3. Relationship Mapping

| Canonical Relationship | Physical Relationship |
|---|---|
| PLACED | CUSTOMER_ORDER.CUSTOMER_ID → CUSTOMER.CUSTOMER_ID |
| FULFILLED_BY | SHIPMENT.ORDER_ID → CUSTOMER_ORDER.ORDER_ID |
| HAS_EVENT | SHIPMENT_EVENT.SHIPMENT_ID → SHIPMENT.SHIPMENT_ID |
| CLASSIFIED_AS | SHIPMENT.ISSUE_ID → DELIVERY_ISSUE.ISSUE_ID |
| SUBCATEGORY_OF | ONTOLOGY.ISSUE_TAXONOMY.CHILD_ISSUE_ID → PARENT_ISSUE_ID |

The SUBCATEGORY_OF hierarchy is stored in ONTOLOGY
metadata rather than as a self-referencing CORE foreign key.

## 4. Cardinality and Enforcement

The ontology defines five business relationship contracts.

The simplified FULFILLED_BY relationship is 1:1.
SHIPMENT.ORDER_ID is declared UNIQUE to represent the
one-shipment-per-order design.

Standard Snowflake tables do not enforce PK, FK, or UNIQUE
constraints. Therefore, these declarations must not be
treated as runtime guarantees.

NOT NULL constraints are enforced by Snowflake.

The existing demonstration dataset was validated for
duplicate identifiers, orphan relationships, and multiple
shipments per order.

The physical schema alone does not enforce the requirement
that every shipment must have at least one tracking event.

## 5. Timestamp Interpretation

SHIPMENT_EVENT.EVENT_TIMESTAMP is TIMESTAMP_NTZ(9).

The demonstration interprets event timestamps as UTC,
but the physical column does not store timezone information.

CP05 uses a fixed evaluation timestamp for reproducibility.

## 6. Validation Summary

| Check | Result |
|---|---|
| Canonical entities mapped | 5/5 |
| Canonical attributes mapped | 20/20 |
| Primary keys declared | 5 |
| Foreign keys declared | 4 |
| Unique shipment-order constraint declared | 1 |
| Physical redesign required | NO |
| New runtime transformation required | NO |

## 7. Implementation Boundary

This document is a logical mapping specification.

It does not alter CORE tables, enforce additional
cardinality constraints, introduce a canonical schema,
or modify CP04/CP05 SQL.

Source of truth:
- sql/cp01_core_schema.sql
- sql/cp03_ontology_definitions.sql