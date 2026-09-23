-- Approved at activation: every call still validates auth.uid(), auth.users and aprobado.
grant execute on function public.dea_code_for_station(text) to authenticated;
