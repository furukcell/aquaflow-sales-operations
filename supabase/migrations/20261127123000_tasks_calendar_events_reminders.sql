alter table public.tasks add column if not exists event_type text not null default 'task';
alter table public.tasks add column if not exists description text;
alter table public.tasks add column if not exists reminder_minutes integer not null default 30;
