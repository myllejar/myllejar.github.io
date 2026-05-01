-- Tables to be created in supabase

-- Populate with correct H-phrases
CREATE TABLE public.H_phrases (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL,
  description text NOT NULL,
  CONSTRAINT H_phrases_pkey PRIMARY KEY (id)
);

-- In addition, you have to setup storage for pictograms in Supabase. 
-- After you have pictogams in storage, you can populate Hazard_pictograms table.
CREATE TABLE public.Hazard_pictograms (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL,
  name text NOT NULL,
  description text NOT NULL,
  image_path text NOT NULL,
  CONSTRAINT Hazard_pictograms_pkey PRIMARY KEY (id)
);
-- Populate with correct P-phrases
CREATE TABLE public.P_phrases (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL,
  description text NOT NULL,
  CONSTRAINT P_phrases_pkey PRIMARY KEY (id)
);
CREATE TABLE public.chemicals (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  name text NOT NULL,
  chemical_formula text NOT NULL,
  use_purpose text NOT NULL,
  storage_information text NOT NULL,
  h_phrases ARRAY NOT NULL,
  p_phrases ARRAY NOT NULL,
  hazard_pictograms ARRAY NOT NULL,
  if_inhaled text,
  if_digested text,
  if_onSkin text,
  if_onEyes text,
  safety_datasheet text NOT NULL,
  supplier text NOT NULL,
  CAS text,
  CONSTRAINT chemicals_pkey PRIMARY KEY (id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL DEFAULT auth.uid(),
  email text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT now(),
  role text NOT NULL DEFAULT 'user'::text CHECK (role = ANY (ARRAY['user'::text, 'admin'::text])),
  display_name text,
  phone_number text,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);