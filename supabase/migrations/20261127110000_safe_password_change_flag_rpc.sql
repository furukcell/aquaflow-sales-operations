-- Safely clear the forced-password-change flag for the signed-in user only.
-- SECURITY DEFINER avoids needing broad client UPDATE privileges on profiles.
create or replace function public.clear_my_password_change_flag()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;
  update public.profiles
    set must_change_password = false,
        updated_at = now()
    where id = auth.uid();
end;
$$;

revoke all on function public.clear_my_password_change_flag() from public;
revoke all on function public.clear_my_password_change_flag() from anon;
grant execute on function public.clear_my_password_change_flag() to authenticated;
