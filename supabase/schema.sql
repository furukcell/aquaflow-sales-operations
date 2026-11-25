-- AquaFlow foundational schema (Supabase/Postgres)
create extension if not exists pgcrypto;
create table if not exists public.companies (
 id uuid primary key default gen_random_uuid(), name text not null, created_at timestamptz not null default now()
);
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 company_id uuid references public.companies(id) on delete restrict,
 full_name text not null default '', job_title text, role text not null default 'read_only' check(role in ('company_admin','sales','operations','finance','documents','read_only')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create or replace function public.current_company_id() returns uuid language sql stable security definer set search_path=public as $$ select company_id from public.profiles where id=auth.uid() $$;
create or replace function public.current_role() returns text language sql stable security definer set search_path=public as $$ select role from public.profiles where id=auth.uid() $$;
create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_code text, company_name text not null, country text, city text, address text,
 contact_name text, email text, phone text, tax_number text, notes text,
 status text not null default 'active' check(status in ('active','inactive','prospect')),
 created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists customers_company_idx on public.customers(company_id);
create index if not exists customers_name_idx on public.customers(company_name);
create table if not exists public.offers (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid not null references public.customers(id), offer_number text not null, currency text not null default 'EUR', amount numeric(14,2) not null default 0,
 status text not null default 'draft' check(status in ('draft','sent','accepted','rejected','expired')), valid_until date, notes text,
 created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(company_id,offer_number)
);
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid not null references public.customers(id), offer_id uuid references public.offers(id), order_number text not null,
 currency text not null default 'EUR', amount numeric(14,2) not null default 0, status text not null default 'open' check(status in ('open','confirmed','in_progress','completed','cancelled')),
 order_date date, notes text, created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(company_id,order_number)
);
create table if not exists public.contracts (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid not null references public.customers(id), order_id uuid references public.orders(id), contract_number text not null,
 status text not null default 'draft' check(status in ('draft','sent','signed','cancelled')), signed_at date, file_path text, notes text,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(company_id,contract_number)
);
create table if not exists public.shipments (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid not null references public.customers(id), order_id uuid references public.orders(id), contract_id uuid references public.contracts(id), shipment_number text not null,
 planned_date date, actual_date date, species text, quantity integer, unit text not null default 'pcs', destination text, status text not null default 'planned' check(status in ('planned','preparing','shipped','delivered','cancelled')),
 notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(company_id,shipment_number)
);
create table if not exists public.documents (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid references public.customers(id), offer_id uuid references public.offers(id), order_id uuid references public.orders(id), contract_id uuid references public.contracts(id), shipment_id uuid references public.shipments(id),
 document_name text not null, document_type text, storage_path text not null, created_by uuid references auth.users(id), created_at timestamptz not null default now()
);
create table if not exists public.payments (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 customer_id uuid not null references public.customers(id), order_id uuid references public.orders(id), payment_date date, due_date date,
 amount numeric(14,2) not null, currency text not null default 'EUR', status text not null default 'pending' check(status in ('pending','paid','overdue','cancelled')),
 reference text, notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 title text not null, description text, due_at timestamptz, assigned_to uuid references auth.users(id), status text not null default 'open' check(status in ('open','in_progress','completed','cancelled')),
 created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.audit_logs (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 actor_id uuid references auth.users(id), entity_type text not null, entity_id uuid, action text not null, details jsonb not null default '{}', created_at timestamptz not null default now()
);
-- Enable RLS and tenant isolation on all company data
alter table public.profiles enable row level security;
alter table public.customers enable row level security; alter table public.offers enable row level security; alter table public.orders enable row level security;
alter table public.contracts enable row level security; alter table public.shipments enable row level security; alter table public.documents enable row level security;
alter table public.payments enable row level security; alter table public.tasks enable row level security; alter table public.audit_logs enable row level security;
drop policy if exists profile_read_same_company on public.profiles; create policy profile_read_same_company on public.profiles for select to authenticated using(company_id=public.current_company_id());
drop policy if exists profile_update_self on public.profiles; create policy profile_update_self on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid());
-- Tenant-scoped CRUD policies. Writes are role-gated; admin, sales, operations, finance/doc roles are progressively scoped.
drop policy if exists customers_tenant_select on public.customers; create policy customers_tenant_select on public.customers for select to authenticated using(company_id=public.current_company_id());
drop policy if exists customers_tenant_insert on public.customers; create policy customers_tenant_insert on public.customers for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations'));
drop policy if exists customers_tenant_update on public.customers; create policy customers_tenant_update on public.customers for update to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations')) with check(company_id=public.current_company_id());
drop policy if exists customers_tenant_delete on public.customers; create policy customers_tenant_delete on public.customers for delete to authenticated using(company_id=public.current_company_id() and public.current_role()='company_admin');
-- Scoped policies on related entities, using company membership and role permissions
DO $$ declare t text; begin foreach t in array array['offers','orders','contracts','shipments','documents','payments','tasks','audit_logs'] loop execute format('drop policy if exists tenant_select on public.%I',t); execute format('create policy tenant_select on public.%I for select to authenticated using(company_id=public.current_company_id())',t); end loop; end $$;
DO $$ declare t text; begin foreach t in array array['offers','orders','contracts','shipments','documents','payments','tasks'] loop execute format('drop policy if exists tenant_insert on public.%I',t); execute format('create policy tenant_insert on public.%I for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in (''company_admin'',''sales'',''operations'',''finance'',''documents''))',t); execute format('drop policy if exists tenant_update on public.%I',t); execute format('create policy tenant_update on public.%I for update to authenticated using(company_id=public.current_company_id() and public.current_role() in (''company_admin'',''sales'',''operations'',''finance'',''documents'')) with check(company_id=public.current_company_id())',t); end loop; end $$;
drop policy if exists audit_insert on public.audit_logs; create policy audit_insert on public.audit_logs for insert to authenticated with check(company_id=public.current_company_id());

-- Bootstrap company setup and account provisioning support
alter table public.profiles add column if not exists must_change_password boolean not null default false;
create or replace function public.bootstrap_company(company_name text, full_name text)
returns uuid language plpgsql security definer set search_path=public as $$
declare cid uuid;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 if exists(select 1 from public.profiles where id=auth.uid()) then raise exception 'Profile already initialized'; end if;
 if length(trim(company_name))<2 then raise exception 'Company name is required'; end if;
 insert into public.companies(name) values(trim(company_name)) returning id into cid;
 insert into public.profiles(id,company_id,full_name,role) values(auth.uid(),cid,trim(full_name),'company_admin');
 return cid;
end; $$;
revoke all on function public.bootstrap_company(text,text) from public;
grant execute on function public.bootstrap_company(text,text) to authenticated;
drop policy if exists profile_update_self on public.profiles;
create policy profile_update_self on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid() and company_id=public.current_company_id() and role=public.current_role());
drop policy if exists profile_admin_manage on public.profiles;
create policy profile_admin_manage on public.profiles for all to authenticated using(company_id=public.current_company_id() and public.current_role()='company_admin') with check(company_id=public.current_company_id() and public.current_role()='company_admin');

-- Offer line items
create table if not exists public.offer_items (id uuid primary key default gen_random_uuid(),company_id uuid not null references public.companies(id) on delete cascade,offer_id uuid not null references public.offers(id) on delete cascade,description text not null,quantity numeric(14,3) not null default 1 check(quantity>0),unit text not null default 'pcs',unit_price numeric(14,2) not null default 0 check(unit_price>=0),tax_rate numeric(5,2) not null default 0 check(tax_rate>=0 and tax_rate<=100),sort_order integer not null default 0,created_at timestamptz not null default now());
create index if not exists offer_items_offer_idx on public.offer_items(offer_id); alter table public.offer_items enable row level security;
drop policy if exists offer_items_tenant_select on public.offer_items; create policy offer_items_tenant_select on public.offer_items for select to authenticated using(company_id=public.current_company_id());
drop policy if exists offer_items_tenant_insert on public.offer_items; create policy offer_items_tenant_insert on public.offer_items for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations'));
drop policy if exists offer_items_tenant_update on public.offer_items; create policy offer_items_tenant_update on public.offer_items for update to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations')) with check(company_id=public.current_company_id());
drop policy if exists offer_items_tenant_delete on public.offer_items; create policy offer_items_tenant_delete on public.offer_items for delete to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations'));
create or replace function public.next_offer_number() returns text language plpgsql security definer set search_path=public as $$ declare prefix text; n integer; begin if auth.uid() is null then raise exception 'Authentication required'; end if; prefix := 'OF-'||to_char(now(),'YYYY')||'-'; perform pg_advisory_xact_lock(hashtext(public.current_company_id()::text)); select coalesce(max((substring(offer_number from length(prefix)+1))::integer),0)+1 into n from public.offers where company_id=public.current_company_id() and offer_number like prefix||'%'; return prefix||lpad(n::text,5,'0'); end; $$;
revoke all on function public.next_offer_number() from public; grant execute on function public.next_offer_number() to authenticated;

-- Order line items and offer-to-order conversion
create table if not exists public.order_items(id uuid primary key default gen_random_uuid(),company_id uuid not null references public.companies(id) on delete cascade,order_id uuid not null references public.orders(id) on delete cascade,description text not null,quantity numeric(14,3) not null default 1 check(quantity>0),unit text not null default 'pcs',unit_price numeric(14,2) not null default 0 check(unit_price>=0),tax_rate numeric(5,2) not null default 0 check(tax_rate>=0 and tax_rate<=100),sort_order integer not null default 0,created_at timestamptz not null default now());
create index if not exists order_items_order_idx on public.order_items(order_id);
alter table public.order_items enable row level security;
drop policy if exists order_items_select on public.order_items;create policy order_items_select on public.order_items for select to authenticated using(company_id=public.current_company_id());
drop policy if exists order_items_insert on public.order_items;create policy order_items_insert on public.order_items for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations'));
drop policy if exists order_items_update on public.order_items;create policy order_items_update on public.order_items for update to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations')) with check(company_id=public.current_company_id());
drop policy if exists order_items_delete on public.order_items;create policy order_items_delete on public.order_items for delete to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations'));
create unique index if not exists orders_offer_once_idx on public.orders(offer_id) where offer_id is not null;
create or replace function public.next_order_number() returns text language plpgsql security definer set search_path=public as $$ declare prefix text;n integer;begin if auth.uid() is null then raise exception 'Authentication required';end if;prefix:='SO-'||to_char(now(),'YYYY')||'-';perform pg_advisory_xact_lock(hashtext(public.current_company_id()::text));select coalesce(max((substring(order_number from length(prefix)+1))::integer),0)+1 into n from public.orders where company_id=public.current_company_id() and order_number like prefix||'%';return prefix||lpad(n::text,5,'0');end;$$;revoke all on function public.next_order_number() from public;grant execute on function public.next_order_number() to authenticated;
create or replace function public.convert_offer_to_order(p_offer_id uuid) returns uuid language plpgsql security definer set search_path=public as $$ declare o public.offers%rowtype;cid uuid;oid uuid;num text;begin if auth.uid() is null then raise exception 'Authentication required';end if;cid:=public.current_company_id();if cid is null or public.current_role() not in ('company_admin','sales','operations') then raise exception 'Permission denied';end if;select * into o from public.offers where id=p_offer_id and company_id=cid for update;if not found then raise exception 'Offer not found';end if;if o.status<>'accepted' then raise exception 'Only accepted offers can be converted';end if;if exists(select 1 from public.orders where offer_id=o.id and company_id=cid) then raise exception 'This offer has already been converted';end if;if not exists(select 1 from public.offer_items where offer_id=o.id and company_id=cid) then raise exception 'Offer has no line items';end if;num:='SO-'||to_char(now(),'YYYY')||'-';perform pg_advisory_xact_lock(hashtext(cid::text));select num||lpad((coalesce(max((substring(order_number from length(num)+1))::integer),0)+1)::text,5,'0') into num from public.orders where company_id=cid and order_number like num||'%';insert into public.orders(company_id,customer_id,offer_id,order_number,currency,amount,status,order_date,notes,created_by) values(cid,o.customer_id,o.id,num,o.currency,o.amount,'open',current_date,o.notes,auth.uid()) returning id into oid;insert into public.order_items(company_id,order_id,description,quantity,unit,unit_price,tax_rate,sort_order) select cid,oid,description,quantity,unit,unit_price,tax_rate,sort_order from public.offer_items where offer_id=o.id and company_id=cid;return oid;end;$$;revoke all on function public.convert_offer_to_order(uuid) from public;grant execute on function public.convert_offer_to_order(uuid) to authenticated;

-- Contract workflow, numbering, and file attachment metadata
alter table public.contracts drop constraint if exists contracts_status_check;
alter table public.contracts add constraint contracts_status_check check(status in ('draft','sent','under_review','signed','expired','cancelled'));
alter table public.contracts add column if not exists currency text not null default 'EUR';
alter table public.contracts add column if not exists title text;
alter table public.contracts add column if not exists updated_by uuid references auth.users(id);
create table if not exists public.contract_files(id uuid primary key default gen_random_uuid(),company_id uuid not null references public.companies(id) on delete cascade,contract_id uuid not null references public.contracts(id) on delete cascade,file_name text not null,storage_path text not null,mime_type text,size_bytes bigint,uploaded_by uuid references auth.users(id),created_at timestamptz not null default now());
create index if not exists contract_files_contract_idx on public.contract_files(contract_id);
alter table public.contract_files enable row level security;
drop policy if exists contract_files_select on public.contract_files;create policy contract_files_select on public.contract_files for select to authenticated using(company_id=public.current_company_id());
drop policy if exists contract_files_insert on public.contract_files;create policy contract_files_insert on public.contract_files for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations','documents'));
drop policy if exists contract_files_delete on public.contract_files;create policy contract_files_delete on public.contract_files for delete to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','sales','operations','documents'));
create or replace function public.next_contract_number() returns text language plpgsql security definer set search_path=public as $$ declare prefix text;n integer;begin if auth.uid() is null then raise exception 'Authentication required';end if;prefix:='CT-'||to_char(now(),'YYYY')||'-';perform pg_advisory_xact_lock(hashtext(public.current_company_id()::text));select coalesce(max((substring(contract_number from length(prefix)+1))::integer),0)+1 into n from public.contracts where company_id=public.current_company_id() and contract_number like prefix||'%';return prefix||lpad(n::text,5,'0');end;$$;revoke all on function public.next_contract_number() from public;grant execute on function public.next_contract_number() to authenticated;
-- Storage bucket is private; paths must be company UUID / contract UUID / filename
insert into storage.buckets(id,name,public,file_size_limit) values('aqua-contract-files','aqua-contract-files',false,52428800) on conflict(id) do update set public=false,file_size_limit=52428800;
drop policy if exists contract_storage_select on storage.objects;create policy contract_storage_select on storage.objects for select to authenticated using(bucket_id='aqua-contract-files' and (storage.foldername(name))[1]=public.current_company_id()::text);
drop policy if exists contract_storage_insert on storage.objects;create policy contract_storage_insert on storage.objects for insert to authenticated with check(bucket_id='aqua-contract-files' and (storage.foldername(name))[1]=public.current_company_id()::text and public.current_role() in ('company_admin','sales','operations','documents'));
drop policy if exists contract_storage_delete on storage.objects;create policy contract_storage_delete on storage.objects for delete to authenticated using(bucket_id='aqua-contract-files' and (storage.foldername(name))[1]=public.current_company_id()::text and public.current_role() in ('company_admin','sales','operations','documents'));

-- Shipment planning and actual execution fields / numbering
alter table public.shipments alter column quantity type numeric(14,3) using quantity::numeric;
alter table public.shipments add column if not exists product_description text;
alter table public.shipments add column if not exists planned_quantity numeric(14,3);
alter table public.shipments add column if not exists actual_quantity numeric(14,3);
alter table public.shipments add column if not exists planned_unit text;
alter table public.shipments add column if not exists actual_unit text;
alter table public.shipments add column if not exists origin text;
alter table public.shipments add column if not exists destination_country text;
alter table public.shipments add column if not exists updated_by uuid references auth.users(id);
create or replace function public.next_shipment_number() returns text language plpgsql security definer set search_path=public as $$ declare prefix text;n integer;begin if auth.uid() is null then raise exception 'Authentication required';end if;prefix:='SH-'||to_char(now(),'YYYY')||'-';perform pg_advisory_xact_lock(hashtext(public.current_company_id()::text));select coalesce(max((substring(shipment_number from length(prefix)+1))::integer),0)+1 into n from public.shipments where company_id=public.current_company_id() and shipment_number like prefix||'%';return prefix||lpad(n::text,5,'0');end;$$;revoke all on function public.next_shipment_number() from public;grant execute on function public.next_shipment_number() to authenticated;

-- Document archive metadata and private storage bucket
alter table public.documents add column if not exists file_name text;
alter table public.documents add column if not exists mime_type text;
alter table public.documents add column if not exists size_bytes bigint;
alter table public.documents add column if not exists updated_at timestamptz not null default now();
alter table public.documents add column if not exists updated_by uuid references auth.users(id);
alter table public.documents add column if not exists category text;
alter table public.documents add column if not exists notes text;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('aqua-document-archive','aqua-document-archive',false,52428800,array['application/pdf','image/jpeg','image/png','image/webp','application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document','application/vnd.ms-excel','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/vnd.ms-powerpoint','application/vnd.openxmlformats-officedocument.presentationml.presentation','text/plain','application/zip']) on conflict(id) do update set public=false,file_size_limit=52428800,allowed_mime_types=excluded.allowed_mime_types;
drop policy if exists aqua_documents_storage_select on storage.objects;create policy aqua_documents_storage_select on storage.objects for select to authenticated using(bucket_id='aqua-document-archive' and (storage.foldername(name))[1]=public.current_company_id()::text);
drop policy if exists aqua_documents_storage_insert on storage.objects;create policy aqua_documents_storage_insert on storage.objects for insert to authenticated with check(bucket_id='aqua-document-archive' and (storage.foldername(name))[1]=public.current_company_id()::text and public.current_role() in ('company_admin','sales','operations','documents'));
drop policy if exists aqua_documents_storage_delete on storage.objects;create policy aqua_documents_storage_delete on storage.objects for delete to authenticated using(bucket_id='aqua-document-archive' and (storage.foldername(name))[1]=public.current_company_id()::text and public.current_role() in ('company_admin','sales','operations','documents'));

-- Finance / receivables module extension
alter table public.payments add column if not exists payment_number text;
alter table public.payments add column if not exists payment_method text;
alter table public.payments add column if not exists paid_amount numeric(14,2) not null default 0;
alter table public.payments add column if not exists updated_by uuid references auth.users(id);
create index if not exists payments_company_due_idx on public.payments(company_id,due_date);
create index if not exists payments_company_customer_idx on public.payments(company_id,customer_id);
drop policy if exists payments_company_select on public.payments;create policy payments_company_select on public.payments for select to authenticated using(company_id=public.current_company_id());
drop policy if exists payments_company_insert on public.payments;create policy payments_company_insert on public.payments for insert to authenticated with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','finance','sales'));
drop policy if exists payments_company_update on public.payments;create policy payments_company_update on public.payments for update to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','finance','sales')) with check(company_id=public.current_company_id() and public.current_role() in ('company_admin','finance','sales'));
drop policy if exists payments_company_delete on public.payments;create policy payments_company_delete on public.payments for delete to authenticated using(company_id=public.current_company_id() and public.current_role() in ('company_admin','finance'));
create or replace function public.next_payment_number() returns text language plpgsql security definer set search_path=public as $$ declare prefix text;n integer;begin if auth.uid() is null then raise exception 'Authentication required';end if;prefix:='PAY-'||to_char(now(),'YYYY')||'-';perform pg_advisory_xact_lock(hashtext(public.current_company_id()::text));select coalesce(max((substring(payment_number from length(prefix)+1))::integer),0)+1 into n from public.payments where company_id=public.current_company_id() and payment_number like prefix||'%';return prefix||lpad(n::text,5,'0');end;$$;revoke all on function public.next_payment_number() from public;grant execute on function public.next_payment_number() to authenticated;
