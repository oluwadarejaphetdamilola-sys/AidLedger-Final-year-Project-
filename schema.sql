-- Run once in Supabase > SQL Editor
create table beneficiaries(id uuid primary key default gen_random_uuid(),code text unique not null,full_name text not null,nin text unique not null,phone text,state text,status text default 'Pending',created_at timestamptz default now());
create table aid_packages(id uuid primary key default gen_random_uuid(),name text not null,category text,stock int default 0,created_at timestamptz default now());
create table distributions(id uuid primary key default gen_random_uuid(),beneficiary_id uuid references beneficiaries(id),package_id uuid references aid_packages(id),quantity int not null,status text default 'Pending',block_hash text,created_at timestamptz default now());
create table blocks(id uuid primary key default gen_random_uuid(),idx int unique not null,prev_hash text not null,hash text not null,data text not null,created_at timestamptz default now());
create table admins(email text primary key);

alter table beneficiaries enable row level security; alter table aid_packages enable row level security;
alter table distributions enable row level security; alter table blocks enable row level security; alter table admins enable row level security;

create function is_admin() returns boolean language sql security definer as $$ select exists(select 1 from admins where email = auth.jwt()->>'email') $$;
create policy a on beneficiaries for all using(is_admin()) with check(is_admin());
create policy a on aid_packages for all using(is_admin()) with check(is_admin());
create policy a on distributions for all using(is_admin()) with check(is_admin());
create policy a on blocks for all using(is_admin()) with check(is_admin());
create policy pub on blocks for select using(true);   -- public audit trail

-- Public lookup: masked name, no phone, no NIN returned
create function lookup(q text) returns table(code text,name text,status text,package text,quantity int,dist_status text,block_hash text)
language sql security definer as $$
 select b.code,left(b.full_name,1)||'***',b.status,p.name,d.quantity,d.status,d.block_hash
 from beneficiaries b left join distributions d on d.beneficiary_id=b.id left join aid_packages p on p.id=d.package_id
 where b.code=q or b.nin=q or d.block_hash=q $$;
grant execute on function lookup(text) to anon,authenticated;

-- After creating your admin user in Authentication > Users, run:
-- insert into admins values('your-admin-email@example.com');
