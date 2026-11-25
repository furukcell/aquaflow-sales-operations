# AquaFlow — Sales & Operations Management Platform

> Development codename: AquaFlow. Product vision: a connected sales, contract, shipment, documentation, finance and operational workspace for seafood export operations — initially built around the young-fish sales workflow.

AquaFlow aims to replace fragmented Excel files, folders and manual follow-ups with a single structured operational system. It starts with the day-to-day needs of a small sales and operations team, while its foundations are designed to support multiple companies, teams and users in the future.

## Vision

Provide one reliable place to manage the commercial and operational lifecycle of a customer and an order:

**Customer → Offer → Order → Contract → Planned shipments → Actual shipments → Documents → Payments → Reporting**

The platform should reduce duplicate data entry, make upcoming commitments visible, keep documents connected to the right records and help the team act on important dates and outstanding work.

## Initial users and use case

- Designed initially for a small sales/operations team.
- First deployment will support the internal young-fish sales and operations workflow.
- The first implementation should be practical, fast to use and easy to maintain.
- Multi-company (tenant) and role-based foundations are planned, but unnecessary enterprise complexity should not block the initial product.

## Core principles

- **Single source of truth:** customer, contract, shipment and payment information should be connected rather than copied between files.
- **Workflow-driven:** a record should move through understandable stages.
- **Planned vs. actual:** preserve original plans and record actual outcomes separately.
- **Traceability:** important changes and actions should be auditable.
- **Document-first practicality:** users should be able to find and open the relevant document from the record they are working on.
- **Secure by design:** company boundaries, access control and file security must be built into the architecture.
- **Incremental delivery:** ship usable modules in small, testable steps.
- **No premature AI:** first establish reliable data and workflows; AI/OCR features can be added later.

## Planned modules

### Dashboard / Work Center
Operational overview and key indicators; upcoming shipments and due dates; outstanding payments and overdue items; tasks, reminders and recent activity; alerts and shortcuts.

### Customers
Customer/company profiles, contacts, country/market classification, customer history, notes and communication history, and connected offers, contracts, shipments, documents and financial records.

### Products and Pricing
Product catalogue and configurable attributes, fish species, size/grade and specifications, units, customer/deal-specific pricing where appropriate, and currency support.

### Offers and Orders
Offers and commercial proposals, offer status and follow-up, offer-to-order conversion, order details and status, and links to customer/products/prices/quantities.

### Contracts
Contract records and status, dates and terms, products, quantities, pricing and currency, planned shipment schedule, attachments, shipment relationships and fulfilment tracking.

### Shipment Planning and Execution
Planned shipments calendar/list, shipment records linked to contracts/customers, planned versus actual quantity/date, status and checklist, shipment-specific documents, and history.

### Documents
Central document hub, linked documents, proformas and signed contracts, operational and quality/quantity documents, file metadata/categories/dates, templates and versioning in later phases, search and access control.

### Finance and Receivables
Contract/shipment-related financial tracking, payment records and dates, advances, outstanding balances and due dates, currencies, overdue visibility, customer balance summaries and exportable reports. This is operational finance tracking, not a replacement for statutory accounting software.

### Tasks, Agenda and Reminders
Personal/shared tasks, assignments, status, due dates, reminders, customer/contract/shipment-related tasks, calendar and follow-up tracking.

### Reporting and Analytics
Sales by period/customer/product/country, shipment performance and fulfilment, planned versus actual shipment analysis, contract performance, receivables and payment status, and exportable reports.

### Platform Administration
Company accounts/tenant management, users, roles and permissions, activity/audit log, company settings, import/export, backup/recovery strategy and application configuration.

## Example workflow

1. Create or select a customer.
2. Create an offer, if required.
3. Convert accepted commercial terms into an order.
4. Create the contract and enter its planned shipment schedule.
5. Scheduled shipments automatically appear in shipment planning and the dashboard — no duplicate entry.
6. Update shipments as prepared and completed; preserve the original plan and record actual shipment information.
7. Attach relevant documents to the contract or shipment.
8. Record payment events and track outstanding amounts.
9. Review customer history and operational/financial reports.

## Development approach

Development is staged in the roadmap (ROADMAP.md). The first milestones focus on the foundation, customers, shipment planning, contract linkage and documents. Finance, automation, reporting and advanced integrations follow after the core workflow is reliable.

Architecture and technology decisions will be documented as they are made. The project should avoid locking business logic into the UI and should keep tenant, permission, data and file-access boundaries explicit.

## Security requirements

Security is a release requirement, not a later enhancement: tenant/company isolation, authentication, role-based access control, server-side authorization, protected document access, audit logging, validation, secure secrets management, backup and recovery planning. Never commit credentials or secrets.

## Out of initial scope

- Full ERP or accounting system
- Farm/production management
- Inventory/manufacturing planning
- AI contract interpretation and OCR (later optional capability)
- Complex integrations before the core workflow is proven

## Roadmap

See [ROADMAP.md](./ROADMAP.md) for milestones, priorities, acceptance criteria and sequence.

## Project status

- [x] Project repository created
- [x] Initial product concept and module map defined
- [x] Static UI prototype prepared
- [ ] Production architecture and stack confirmed
- [ ] Authentication and company/tenant foundation implemented
- [ ] Core data model and migrations established
- [ ] First end-to-end workflow implemented

Roadmap statuses will be updated as work is delivered. Milestones describe planned work, not claims that features already exist.

## Development and contribution

At this early stage, development decisions and changes should be documented in issues, commits or project notes. Prefer small changes with clear scope and acceptance criteria.

*AquaFlow is a working project name; naming and trademark availability have not been verified.*