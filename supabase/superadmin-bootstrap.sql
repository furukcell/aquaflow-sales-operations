-- AquaFlow platform super-admin bootstrap
-- Run once in Supabase SQL editor before creating the first super-admin Auth user/profile.
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check check(role in ('super_admin','company_admin','sales','operations','finance','documents','read_only'));
-- Company membership remains nullable for platform-level super-admins.
alter table public.profiles alter column company_id drop not null;
-- Prevent a regular user from changing their own company/role; super-admin profile is provisioned manually.
drop policy if exists profile_update_self on public.profiles;
create policy profile_update_self on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid() and company_id is not distinct from (select company_id from public.profiles p where p.id=auth.uid()) and role=(select role from public.profiles p where p.id=auth.uid()));
-- Admins may manage their own tenant profiles; superadmins will use server-side Edge Function.
drop policy if exists profile_admin_manage on public.profiles;
create policy profile_admin_manage on public.profiles for all to authenticated using(company_id=public.current_company_id() and public.current_role()='company_admin') with check(company_id=public.current_company_id() and public.current_role()='company_admin');
