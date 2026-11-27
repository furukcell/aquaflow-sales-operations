-- Restore explicit client read privileges and tenant-scoped dashboard read policies.
-- These grants are paired with RLS; they do not permit cross-company access.
grant select on public.shipments, public.audit_logs to authenticated;

alter table public.shipments enable row level security;
alter table public.audit_logs enable row level security;

drop policy if exists dashboard_shipments_read on public.shipments;
create policy dashboard_shipments_read on public.shipments
  for select to authenticated using (company_id = public.current_company_id());

drop policy if exists dashboard_audit_logs_read on public.audit_logs;
create policy dashboard_audit_logs_read on public.audit_logs
  for select to authenticated using (company_id = public.current_company_id());
