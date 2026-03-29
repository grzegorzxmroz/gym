-- Uruchom to w Supabase → SQL Editor

-- Tabela ćwiczeń (własne nazwy użytkownika)
create table exercises (
  id         text        primary key,
  user_id    uuid        references auth.users not null,
  name       text        not null,
  created_at timestamptz default now()
);

-- Tabela treningów (ćwiczenia i serie przechowywane jako JSON)
create table workouts (
  id         text        primary key,
  user_id    uuid        references auth.users not null,
  started_at bigint      not null,   -- timestamp w ms (Date.now())
  finished   boolean     not null default false,
  exercises  jsonb       not null default '[]',
  created_at timestamptz default now()
);

-- Row Level Security: każdy widzi tylko swoje dane
alter table exercises enable row level security;
alter table workouts  enable row level security;

create policy "exercises_own" on exercises
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "workouts_own" on workouts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
