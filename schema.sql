-- Polli Game: una fila por sala. Pegar una vez en Supabase → SQL Editor → Run.
create table if not exists public.polli_rooms (
  code        text primary key check (code ~ '^[A-Z]{4}$'),
  state       jsonb not null,
  version     integer not null default 1,
  updated_at  timestamptz not null default now()
);

alter table public.polli_rooms enable row level security;

-- Cualquiera con el código puede ver, crear y jugar una sala. Nadie puede borrar desde la app.
create policy "polli_select" on public.polli_rooms for select to anon, authenticated using (true);
create policy "polli_insert" on public.polli_rooms for insert to anon, authenticated with check (true);
create policy "polli_update" on public.polli_rooms for update to anon, authenticated using (true) with check (true);

-- Avisos en tiempo real cuando cambia una sala
alter publication supabase_realtime add table public.polli_rooms;
