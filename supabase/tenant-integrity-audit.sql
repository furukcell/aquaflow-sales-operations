-- Read-only audit for cross-tenant or customer-mismatched references.
-- Returns only offending rows. Run before VALIDATE CONSTRAINT on the migration.
select 'offers.customer_company' as issue, o.id as record_id, o.company_id as record_company, c.company_id as related_company from public.offers o join public.customers c on c.id=o.customer_id where o.company_id<>c.company_id
union all
select 'orders.customer_company',o.id,o.company_id,c.company_id from public.orders o join public.customers c on c.id=o.customer_id where o.company_id<>c.company_id
union all
select 'orders.offer_company_or_customer',o.id,o.company_id,ofr.company_id from public.orders o join public.offers ofr on ofr.id=o.offer_id where o.company_id<>ofr.company_id or o.customer_id<>ofr.customer_id
union all
select 'contracts.customer_company',ct.id,ct.company_id,c.company_id from public.contracts ct join public.customers c on c.id=ct.customer_id where ct.company_id<>c.company_id
union all
select 'contracts.order_company_or_customer',ct.id,ct.company_id,o.company_id from public.contracts ct join public.orders o on o.id=ct.order_id where ct.company_id<>o.company_id or ct.customer_id<>o.customer_id
union all
select 'shipments.customer_company',s.id,s.company_id,c.company_id from public.shipments s join public.customers c on c.id=s.customer_id where s.company_id<>c.company_id
union all
select 'shipments.order_company_or_customer',s.id,s.company_id,o.company_id from public.shipments s join public.orders o on o.id=s.order_id where s.company_id<>o.company_id or s.customer_id<>o.customer_id
union all
select 'shipments.contract_company_or_customer',s.id,s.company_id,ct.company_id from public.shipments s join public.contracts ct on ct.id=s.contract_id where s.company_id<>ct.company_id or s.customer_id<>ct.customer_id
union all
select 'payments.customer_company',p.id,p.company_id,c.company_id from public.payments p join public.customers c on c.id=p.customer_id where p.company_id<>c.company_id
union all
select 'payments.order_company_or_customer',p.id,p.company_id,o.company_id from public.payments p join public.orders o on o.id=p.order_id where p.company_id<>o.company_id or p.customer_id<>o.customer_id
union all
select 'documents.customer_company',d.id,d.company_id,c.company_id from public.documents d join public.customers c on c.id=d.customer_id where d.company_id<>c.company_id
union all
select 'documents.offer_company_or_customer',d.id,d.company_id,o.company_id from public.documents d join public.offers o on o.id=d.offer_id where d.company_id<>o.company_id or (d.customer_id is not null and d.customer_id<>o.customer_id)
union all
select 'documents.order_company_or_customer',d.id,d.company_id,o.company_id from public.documents d join public.orders o on o.id=d.order_id where d.company_id<>o.company_id or (d.customer_id is not null and d.customer_id<>o.customer_id)
union all
select 'documents.contract_company_or_customer',d.id,d.company_id,ct.company_id from public.documents d join public.contracts ct on ct.id=d.contract_id where d.company_id<>ct.company_id or (d.customer_id is not null and d.customer_id<>ct.customer_id)
union all
select 'documents.shipment_company_or_customer',d.id,d.company_id,s.company_id from public.documents d join public.shipments s on s.id=d.shipment_id where d.company_id<>s.company_id or (d.customer_id is not null and d.customer_id<>s.customer_id)
union all
select 'offer_items.offer_company',i.id,i.company_id,o.company_id from public.offer_items i join public.offers o on o.id=i.offer_id where i.company_id<>o.company_id
union all
select 'order_items.order_company',i.id,i.company_id,o.company_id from public.order_items i join public.orders o on o.id=i.order_id where i.company_id<>o.company_id
union all
select 'contract_files.contract_company',f.id,f.company_id,c.company_id from public.contract_files f join public.contracts c on c.id=f.contract_id where f.company_id<>c.company_id
order by issue,record_id;
