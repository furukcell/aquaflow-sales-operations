-- Read-only audit: task assignees must belong to the task's tenant.
-- Rows returned need manual review before VALIDATE CONSTRAINT.
select
  t.id as task_id,
  t.company_id as task_company_id,
  t.assigned_to,
  p.company_id as assignee_company_id
from public.tasks t
join public.profiles p on p.id=t.assigned_to
where t.assigned_to is not null
  and t.company_id is distinct from p.company_id
order by t.created_at, t.id;
