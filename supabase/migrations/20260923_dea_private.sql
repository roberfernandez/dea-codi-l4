-- Schema only. Real station codes must NEVER be added to this repository.
begin;
create schema dea_private;
revoke all on schema dea_private from public, anon, authenticated;
create table dea_private.codes (
  station text primary key,
  display_code text not null,
  updated_at timestamptz not null default now()
);
alter table dea_private.codes enable row level security;
alter table dea_private.codes force row level security;
revoke all on table dea_private.codes from public, anon, authenticated;

create function public.dea_code_for_station(p_station text)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := auth.uid();
  result text;
begin
  perform pg_catalog.set_config('response.headers', '[{"Cache-Control":"no-store, private"},{"Pragma":"no-cache"}]', true);
  if caller is null or not exists (select 1 from auth.users u where u.id = caller)
     or not exists (select 1 from public.solicitudes_acceso s where s.user_id = caller and s.estado = 'aprobado') then
    raise exception using errcode = '42501', message = 'DEA access denied';
  end if;
  select c.display_code into result from dea_private.codes c where c.station = p_station;
  if result is null then
    raise exception using errcode = 'P0002', message = 'DEA code unavailable';
  end if;
  return result;
end;
$$;
revoke all on function public.dea_code_for_station(text) from public, anon, authenticated;
-- Enable only after the private import and authorization review:
-- grant execute on function public.dea_code_for_station(text) to authenticated;
commit;
