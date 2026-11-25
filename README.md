# AquaFlow — Sales & Operations Platform

AquaFlow is a multi-tenant sales, customer, commercial-document, logistics and finance operations platform under active development. It centralizes business records, connects commercial stages, and aims to provide company-scoped dashboards and reporting.

> **Development status:** Code is committed and development is ongoing. Full production deployment, end-to-end tests, and validation of every SQL migration against a live Supabase project have not yet been completed. This is an implementation snapshot, not a production-readiness claim.

## Product purpose and workflow

The planned commercial lifecycle connects the following modules:

1. **Customers / CRM** — company records, contact information and customer history.
2. **Offers** — offers, currencies, amounts, validity, line items and status.
3. **Orders** — accepted offers converted to orders, order details and progress.
4. **Contracts** — contract records, status and files.
5. **Shipments** — shipment planning, quantities, product/species, destination, dates and status, linked to customer/order/contract records where applicable.
6. **Documents** — company-scoped archive for files linked to business records.
7. **Finance & receivables** — payment records, due dates, currencies, paid amounts, remaining balance, payment methods and references.
8. **Tasks and activity** — follow-up tasks and audit activity for operational tracking.
9. **Dashboard and reports** — aggregate operational and financial information from stored records.

The goal is to follow customer context through offers, orders, contracts, shipments, documents and receivables rather than managing each stage in disconnected spreadsheets.

## Company isolation and permissions

AquaFlow is designed as a multi-tenant SaaS application. Each company has scoped records, and users are linked to a company through their profile. Role-based access is intended to govern actions. PostgreSQL row-level security (RLS) policies are included in the schema. Supabase Auth provides authentication, PostgreSQL stores data, and Supabase Storage stores files. Private storage policies are intended to restrict access to each company's folder. Review and test the schema and policies in the target environment before use.

## Technology

- Next.js App Router, React and TypeScript
- Supabase Auth
- Supabase PostgreSQL / Row Level Security
- Supabase Storage
- XLSX parsing for spreadsheet import

## Current implementation snapshot

Application code exists for:

- Customer management (app/customers)
- Offers and offer line item schema (app/offers and database schema)
- Orders and order line items / offer conversion (app/orders and schema)
- Contracts (app/contracts)
- Shipment records (app/shipments)
- Document archive (app/documents)
- Finance & receivables (app/finance)
- User administration and profile/setup flows
- Dashboard with Supabase-derived counts, upcoming shipments, open balances by currency, tasks and audit log display
- Customer spreadsheet import (app/import)

### Customer import — current scope

The import page currently supports customer import from Excel (.xlsx, .xls) and CSV files:

1. Select a spreadsheet or CSV file.
2. Excel files are read from the first worksheet.
3. Match source headers to AquaFlow customer fields.
4. Preview the rows before importing.
5. Rows without a company name are excluded.
6. Existing company names are checked and skipped as duplicates within the company.
7. Valid records are inserted into the authenticated user's company in Supabase.

The downloadable CSV template can be opened in Excel. Importing offers, orders, contracts, shipments, payments and other records is planned but is **not yet implemented**. Linked imports need relationship validation and an appropriate import sequence.

## Planned import architecture

- Parse file and detect headers.
- Provide column mapping.
- Validate required fields, formats and references.
- Preview rows and warnings.
- Resolve linked records (such as customer/order identifiers).
- Import in dependency order, using transactional or rollback-aware processing where possible.
- Report inserted, skipped and failed rows.

File upload does not guarantee that arbitrary workbook layouts will import automatically; source columns may need mapping or normalization.

## Run locally

Requirements: Node.js 20+.

```bash
npm install
```

Create `.env.local` with your Supabase project configuration:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

Then run:

```bash
npm run dev
```

Open http://localhost:3000.

## Supabase setup

- Review and apply SQL from `supabase/schema.sql` to the intended Supabase project.
- Configure Supabase Auth and company/profile setup.
- Configure private storage and verify its policies.
- Configure environment variables.
- Test company isolation and role permissions with separate accounts before loading real data.

## Development roadmap

- [x] Application shell and navigation
- [x] Supabase authentication and company/profile foundation
- [x] Customer management
- [x] Offers, order workflow and line-item schema
- [x] Contracts and shipments
- [x] Document archive foundation
- [x] Finance/receivables foundation
- [x] Dashboard data connected to Supabase queries
- [x] Customer CSV import with mapping, preview and duplicate checks
- [x] Excel reading on customer import page
- [ ] Build and end-to-end validation in target environment
- [ ] Import offers, orders, contracts, shipments and payments
- [ ] Relationship mapping and import error reports
- [ ] Complete task/calendar workflow and audit logging across actions
- [ ] Reports, exports and advanced filtering
- [ ] Automated tests, security review and production deployment

## Repository structure

- `app/` — Next.js route pages and modules
- `components/` — shared application UI, including dashboard
- `lib/` — shared client/configuration utilities
- `supabase/schema.sql` — schema, functions and policies

README status aims to distinguish committed code from unverified deployment or testing.