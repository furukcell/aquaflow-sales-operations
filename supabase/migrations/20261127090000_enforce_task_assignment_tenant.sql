-- Prevent task assignment to a user from another tenant.
-- Existing data is intentionally not validated here; audit it separately first.
begin;
create unique index if not exists profiles_id_company_uq
  on public.profiles(id, company_id);
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname='tasks_assignee_company_fk'
      and conrelid='public.tasks'::regclass
  ) then
    alter table public.tasks
      add constraint tasks_assignee_company_fk
      foreign key (assigned_to, company_id)
      references public.profiles(id, company_id)
      not valid;
  end if;
end $$;
commit;
