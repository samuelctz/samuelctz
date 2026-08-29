-- Starbucks Card Collector v2
alter table public.cards add column if not exists city text;
alter table public.cards add column if not exists added_by text;

drop policy if exists "Public can read cards" on public.cards;
drop policy if exists "Public can add cards" on public.cards;
drop policy if exists "Authenticated users can read cards" on public.cards;
drop policy if exists "Authenticated users can add cards" on public.cards;
drop policy if exists "Public can edit cards" on public.cards;
drop policy if exists "Public can delete cards" on public.cards;
drop policy if exists "Authenticated users can edit cards" on public.cards;
drop policy if exists "Authenticated users can delete cards" on public.cards;

alter table public.cards enable row level security;
create policy "Anyone can read cards" on public.cards for select to anon, authenticated using (true);
create policy "Guests can add cards" on public.cards for insert to anon with check (true);
create policy "Authenticated users can add cards" on public.cards for insert to authenticated with check (true);
create policy "Authenticated users can edit cards" on public.cards for update to authenticated using (true) with check (true);
create policy "Authenticated users can delete cards" on public.cards for delete to authenticated using (true);

insert into storage.buckets (id,name,public) values ('card-photos','card-photos',true)
on conflict (id) do update set public=true;

drop policy if exists "Public can upload card photos" on storage.objects;
drop policy if exists "Public can update card photos" on storage.objects;
drop policy if exists "Public can delete card photos" on storage.objects;
drop policy if exists "Authenticated users can upload card photos" on storage.objects;
drop policy if exists "Authenticated users can update card photos" on storage.objects;
drop policy if exists "Authenticated users can delete card photos" on storage.objects;

create policy "Guests can upload card photos" on storage.objects for insert to anon with check (bucket_id='card-photos');
create policy "Authenticated users can upload card photos" on storage.objects for insert to authenticated with check (bucket_id='card-photos');
create policy "Authenticated users can update card photos" on storage.objects for update to authenticated using (bucket_id='card-photos') with check (bucket_id='card-photos');
create policy "Authenticated users can delete card photos" on storage.objects for delete to authenticated using (bucket_id='card-photos');
