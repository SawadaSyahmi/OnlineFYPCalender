-- FYP1 Coordination Command Centre — Supabase cloud sync setup
-- Run once in Supabase Dashboard > SQL Editor.

create table if not exists public.fyp1_planner_state (
  user_id uuid not null references auth.users(id) on delete cascade,
  planner_key text not null,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, planner_key)
);

alter table public.fyp1_planner_state enable row level security;

-- Re-running this setup is safe.
drop policy if exists "Users manage own FYP1 planner" on public.fyp1_planner_state;
create policy "Users manage own FYP1 planner"
on public.fyp1_planner_state
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.fyp1_planner_state to authenticated;
