-- RPC = Remote Procedure Call, PostgreSQL function that becomes an API endpoint, which can be called with Javascript from frontend.

-- Inserts users info in profiles table when user signs up through auth system
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name, phone_number)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'display_name',
    new.raw_user_meta_data->>'phone_number'
  );

-- Adds fk constraint to profiles table. If profile is deleted from auth --> profile is deleted from profiles table.
alter table public.profiles
add constraint profiles_id_fkey
foreign key (id)
references auth.users(id)
on delete cascade;

  return new;
end;
$$ language plpgsql security definer;

-- Retrieves all information of all chemicals (used in main page chemical list and to view detailes of a chemical)
create or replace function get_chemicals()
returns jsonb
language sql
stable
as $$
  select jsonb_agg(
    jsonb_build_object(
      'id', c.id,
      'name', c.name,
      'created', to_char(c.created_at, 'DD-MM-YYYY'),
      'formula', c.chemical_formula,
      'use_purpose', c.use_purpose,
      'storage', c.storage_information,
      'supplier', c.supplier,
      'safety_data_sheet', c.safety_datasheet,
      'CAS', c."CAS",

      -- H-phrases (codes)
      'h_phrases', (
        select jsonb_agg(h.code order by h.id)
        from unnest(c.h_phrases) as h_id(id)
        join "H_phrases" h on h.id = h_id.id
      ),

      -- H-phrases descriptions
      'h_phrase_desc', (
        select jsonb_agg(h.description order by h.id)
        from unnest(c.h_phrases) as h_id(id)
        join "H_phrases" h on h.id = h_id.id
      ),

      -- P-phrases (codes)
      'p_phrases', (
        select jsonb_agg(p.code order by p.id)
        from unnest(c.p_phrases) as p_id(id)
        join "P_phrases" p on p.id = p_id.id
      ),

      -- P-phrases descriptions
      'p_phrase_desc', (
        select jsonb_agg(p.description order by p.id)
        from unnest(c.p_phrases) as p_id(id)
        join "P_phrases" p on p.id = p_id.id
      ),

      -- Hazard pictograms
      'pictograms', (
        select jsonb_agg(hp.image_path order by hp.id)
        from unnest(c.hazard_pictograms) as hp_id(id)
        join "Hazard_pictograms" hp on hp.id = hp_id.id
      ),

      -- Health info
      'inhaled', c.if_inhaled,
      'digested', c.if_digested,
      'on_skin', c."if_onSkin",
      'on_eyes', c."if_onEyes"
    )
  )
  from chemicals c;
$$;

-- Function to check if users role is 'admin'
create or replace function is_admin()
returns boolean
language sql
security definer
as $$
  select role = 'admin'
  from profiles
  where id = auth.uid();
$$;