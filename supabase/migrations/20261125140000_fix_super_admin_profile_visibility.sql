-- Fix profile visibility for platform super-admins whose company_id is NULL.
-- Also retain tenant-scoped profile visibility for normal company users.
drop policy if exists profile_read_same_company on public.profiles;
create policy profile_read_same_company on public.profiles
  for select to authenticated
  using (id = auth.uid() or company_id = public.current_company_id());
