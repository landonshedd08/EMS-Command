-- EMS Command classroom MVP schema.
-- IMPORTANT: these permissive policies are for fictional demo data only.
-- Do not use them for real patient data or a public production deployment.
create table if not exists public.ems_rooms (
  room_code text primary key check (room_code ~ '^[A-Z0-9]{6,8}$'),
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.ems_rooms enable row level security;

drop policy if exists "MVP anonymous room access" on public.ems_rooms;
create policy "MVP anonymous room access"
on public.ems_rooms for all to anon, authenticated
using (true) with check (true);

-- Enable Postgres change events for realtime updates.
alter table public.ems_rooms replica identity full;
do $$
begin
  alter publication supabase_realtime add table public.ems_rooms;
exception when duplicate_object then
  null;
when undefined_object then
  raise notice 'Publication supabase_realtime not found; enable Realtime for ems_rooms in Supabase Dashboard.';
end $$;
