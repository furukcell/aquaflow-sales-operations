# AquaFlow — Product & Engineering Roadmap

This roadmap is the working plan for building AquaFlow from a prototype into a dependable sales and operations platform. Items are **planned** unless explicitly marked complete.

## Delivery strategy

Build a reliable end-to-end path before expanding sideways. The first target is to make the customer → contract → shipment plan → actual shipment → documents workflow usable. Finance, tasks and analytics are layered on top of these dependable records.

---

## Phase 0 — Product definition and repository foundation
**Status: In progress**

### Work
- [x] Define product vision and initial scope
- [x] Map the main operational modules
- [x] Prepare a static dashboard prototype
- [x] Create repository and initial documentation
- [ ] Confirm application stack and deployment approach
- [ ] Establish folder structure and development conventions
- [ ] Set up environment configuration and secrets handling
- [ ] Set up linting, formatting and baseline tests where supported
- [ ] Establish issue/commit conventions

### Exit criteria
- Stack and deployment decisions documented.
- Development environment can be reproduced.
- Project structure is established.
- Prototype and product scope are represented in the repository.

## Phase 1 — Secure application foundation
**Priority: Critical**

### Work
- [ ] Authentication and session handling
- [ ] Company/tenant data model
- [ ] User model and company membership
- [ ] Initial role and permission model
- [ ] Server-side authorization enforcement
- [ ] Tenant isolation rules and tests
- [ ] Application shell, navigation and responsive layout
- [ ] Error handling and logging foundation
- [ ] Database schema/migration strategy
- [ ] Storage architecture for documents

### Initial roles (adjustable)
- Company administrator
- Manager
- Staff/member
- Read-only (optional)

### Exit criteria
- Users can authenticate.
- Users belong to an explicitly defined company context.
- Access to company data is enforced server-side.
- Basic application shell is functional.
- Tenant boundary tests pass.

## Phase 2 — Customer management
**Priority: High**

### Work
- [ ] Customer list, search and filters
- [ ] Customer create/edit/view
- [ ] Customer contacts
- [ ] Country and customer categorization
- [ ] Customer notes
- [ ] Activity timeline foundation
- [ ] Customer profile sections for commercial, operations, documents and finance
- [ ] Import customers from Excel/CSV
- [ ] Export customer data

### Exit criteria
- Customer records can be created, edited, searched and imported.
- Customer profile serves as the central navigation point for connected records.
- Import errors are visible and actionable.

## Phase 3 — Product catalogue and commercial records
**Priority: High**

### Work
- [ ] Product/specification catalogue
- [ ] Species and size/grade fields (configurable as needed)
- [ ] Units and quantity validation
- [ ] Currency and price fields
- [ ] Offers and offer status
- [ ] Offer follow-up
- [ ] Orders
- [ ] Offer-to-order conversion
- [ ] Commercial record history

### Exit criteria
- Offers and orders are linked to customers and products.
- Commercial details are reusable when creating contracts.
- Currency and quantity values are stored consistently.

## Phase 4 — Contract management and shipment scheduling
**Priority: Critical — first end-to-end business workflow**

### Work
- [ ] Contract creation and editing
- [ ] Contract number and status
- [ ] Contract parties and commercial terms
- [ ] Product/size/quantity and price
- [ ] Currency
- [ ] Contract dates and relevant terms
- [ ] Shipment schedule embedded in the contract
- [ ] Multiple planned shipment rows per contract
- [ ] Contract attachments
- [ ] Contract overview and fulfilment summary
- [ ] Automatically create/link shipment planning records from contract schedule
- [ ] Prevent accidental duplicate shipment-plan creation
- [ ] Preserve contract schedule history where dates or quantities change

### Exit criteria
- A contract can be entered with multiple planned shipments.
- Planned shipment entries are reflected in shipment planning without duplicate manual entry.
- Contract totals and planned fulfilment summaries are consistent.
- Changes to schedules are traceable.

## Phase 5 — Shipment operations
**Priority: Critical**

### Work
- [ ] Shipment planning list/calendar
- [ ] Filters for customer, date, status and country
- [ ] Shipment detail page
- [ ] Shipment checklist
- [ ] Shipment preparation statuses
- [ ] Actual shipment date and quantity
- [ ] Planned-versus-actual comparison
- [ ] Shipment notes
- [ ] Shipment documents and attachments
- [ ] Shipment activity log
- [ ] Contract shipment fulfilment summary
- [ ] Overdue, upcoming and completed shipment indicators

### Suggested initial status flow
Planned → Preparing → Ready → Shipped → Completed

Status names should be validated against the real workflow.

### Exit criteria
- Each shipment is connected to a customer and, where applicable, a contract.
- Planned and actual values remain distinct.
- Documents and checklist are accessible from the shipment.
- Shipment status and history can be followed.

## Phase 6 — Document management
**Priority: High**

### Work
- [ ] Central document listing
- [ ] Document categories
- [ ] Attach files to customers, contracts and shipments
- [ ] Document metadata (date, category, owner, related records)
- [ ] Search/filter
- [ ] Protected file access
- [ ] Document checklist per shipment/contract
- [ ] File versioning strategy
- [ ] Download and preview where supported
- [ ] Document templates
- [ ] Generate basic proforma/document output (after template requirements are validated)

### Exit criteria
- Users can reliably find documents through a document hub and linked records.
- File access respects company and user permissions.
- Documents can be categorized and linked without creating unstructured duplicate copies.

## Phase 7 — Finance and receivables
**Priority: High**

### Work
- [ ] Financial tracking records
- [ ] Contract/shipment amount summaries
- [ ] Payments and payment dates
- [ ] Payment allocation/relationship to contracts where applicable
- [ ] Advances
- [ ] Outstanding balance calculation
- [ ] Due dates
- [ ] Overdue status and alerts
- [ ] Multi-currency support and explicit exchange-rate handling where required
- [ ] Customer balance view
- [ ] Payment history
- [ ] Finance export

### Exit criteria
- Payment records and outstanding balances are understandable and traceable.
- Due and overdue items are visible.
- Currency handling rules are documented.
- The module is clearly operational tracking, not statutory accounting.

## Phase 8 — Agenda, tasks, reminders and communication history
**Priority: Medium-High**

### Work
- [ ] Tasks
- [ ] Assignments
- [ ] Task priorities and statuses
- [ ] Due dates and reminders
- [ ] Shared/personal agenda
- [ ] Customer follow-up records
- [ ] Communication notes
- [ ] Tasks linked to customers, contracts and shipments
- [ ] Notifications center
- [ ] Activity timeline

### Exit criteria
- Follow-ups can be assigned and tracked.
- Tasks are connected to the records they concern.
- Upcoming actions and overdue tasks are visible.

## Phase 9 — Dashboard and reporting
**Priority: Medium-High**

### Work
- [ ] Dashboard connected to real data
- [ ] Sales overview and trend
- [ ] Shipment overview
- [ ] Upcoming shipment panel
- [ ] Shipment fulfilment and variance analysis
- [ ] Customer performance
- [ ] Country/market reporting
- [ ] Product/size reporting
- [ ] Receivables and overdue summaries
- [ ] Date filters
- [ ] Exportable report formats

### Exit criteria
- Dashboard metrics are computed from operational records.
- Reports have clear definitions and filter criteria.
- Export results match displayed data.

## Phase 10 — Import/export and operational quality
**Priority: Medium**

### Work
- [ ] Excel/CSV import framework
- [ ] Import mapping and validation
- [ ] Duplicate detection rules
- [ ] Import preview and error report
- [ ] Excel/CSV exports
- [ ] PDF/print-friendly reports
- [ ] Empty, loading and error states
- [ ] Responsive layouts
- [ ] Accessibility and usability pass
- [ ] Performance review

### Exit criteria
- Users can safely migrate and export operational data.
- Import errors do not silently corrupt or partially duplicate records.
- Core screens work on desktop and mobile-sized layouts.

## Phase 11 — Automation and integrations
**Priority: Later**

### Candidate capabilities
- [ ] Automated reminders
- [ ] Notifications based on shipment/payment deadlines
- [ ] Email integration (evaluate)
- [ ] Calendar integration (evaluate)
- [ ] Messaging integrations (evaluate)
- [ ] Automated document generation
- [ ] Workflow rules

### Exit criteria
- Each automation is reliable, configurable and auditable.
- Failures are visible and can be retried.
- Integrations do not bypass authorization controls.

## Phase 12 — AI-assisted workflows
**Priority: Later; not part of the initial build**

### Candidate capabilities
- [ ] Contract PDF extraction/OCR
- [ ] Suggested structured contract data
- [ ] Document classification
- [ ] Search using natural language
- [ ] Report summaries
- [ ] Assisted data entry

### Guardrails
- AI output must be reviewable before it changes authoritative records.
- Extraction confidence and source-document traceability should be retained where feasible.
- AI should not silently overwrite contract, shipment or financial data.

## Phase 13 — SaaS readiness
**Priority: Later, after internal workflow validation**

### Work
- [ ] Tenant onboarding
- [ ] Company settings
- [ ] User invitations and management
- [ ] Permission customization
- [ ] Subscription/billing model evaluation
- [ ] Tenant-specific configurations
- [ ] Operational monitoring
- [ ] Backup/recovery drills
- [ ] Security review
- [ ] Documentation and support workflow

### Exit criteria
- A new company can be onboarded without manual database manipulation.
- Tenant isolation is independently tested.
- Operational and security procedures are documented.

## Cross-cutting requirements (every phase)

- [ ] Security and authorization review
- [ ] Tenant isolation review
- [ ] Validation and error states
- [ ] Activity/audit considerations
- [ ] Responsive design
- [ ] Test coverage for critical business logic
- [ ] Documentation updated
- [ ] No secrets committed
- [ ] Keep business logic separate from presentation where possible

## Immediate next steps

1. Confirm the stack and deployment constraints.
2. Establish the repository's working structure and baseline.
3. Implement secure company/user foundations.
4. Build customer management.
5. Implement contract creation with shipment schedule linkage.
6. Build shipment planning and execution.
7. Connect documents to these records.

**Roadmap maintenance:** mark items complete only when implementation exists and acceptance criteria are met. Reorder based on validated operational needs, not speculative features.
