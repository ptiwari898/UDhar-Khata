-- Udhar Khata: initial multi-tenant schema with RLS, soft deletes, and
-- server-stamped updated_at for offline-first sync.
--
-- Run this once in the Supabase SQL Editor on a fresh project, then
-- configure Auth providers (Phone/Twilio and Google) in the dashboard
-- as described in README-supabase.md.

create extension if not exists pgcrypto;

-- Generic "stamp updated_at" trigger function, shared by every table.
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- SHOPS ----------------------------------------------------------------
create table public.shops (
  id          uuid primary key default gen_random_uuid(),
  owner_id    uuid not null unique references auth.users(id) on delete cascade,
  shop_name   text not null default 'My Shop',
  owner_name  text not null default '',
  phone       text not null default '',
  location    text not null default '',
  address     text not null default '',
  upi_id      text not null default '',
  gstin       text not null default '',
  email       text not null default '',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  deleted_at  timestamptz
);
create trigger trg_shops_updated before update on public.shops
  for each row execute function public.set_updated_at();

-- Auto-provision a shop row the moment a user signs up (phone OR google).
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.shops (owner_id, email, phone)
  values (new.id, coalesce(new.email, ''), coalesce(new.phone, ''));
  return new;
end;
$$;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- CUSTOMERS --------------------------------------------------------------
create table public.customers (
  id            uuid primary key default gen_random_uuid(),
  shop_id       uuid not null references public.shops(id) on delete cascade,
  name          text not null,
  phone         text not null default '',
  location      text not null default '',
  risk_level    text not null default 'Low' check (risk_level in ('High','Medium','Low')),
  credit_limit  numeric(12,2) not null default 15000,
  notes         text not null default '',
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz
);
create index idx_customers_shop on public.customers(shop_id);
create trigger trg_customers_updated before update on public.customers
  for each row execute function public.set_updated_at();

-- TRANSACTIONS -------------------------------------------------------------
create table public.transactions (
  id              uuid primary key default gen_random_uuid(),
  shop_id         uuid not null references public.shops(id) on delete cascade,
  customer_id     uuid not null references public.customers(id) on delete cascade,
  type            text not null check (type in ('UDHAAR','PAYMENT','ADVANCE','REFUND','ADJUSTMENT')),
  amount          numeric(12,2) not null check (amount >= 0),
  note            text not null default '',
  txn_date        timestamptz not null,
  payment_method  text not null default 'Cash' check (payment_method in ('Cash','UPI','Bank Transfer','Other')),
  reference       text not null default '',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz
);
create index idx_transactions_shop on public.transactions(shop_id);
create index idx_transactions_customer on public.transactions(customer_id);
create index idx_transactions_shop_date on public.transactions(shop_id, txn_date desc);
create trigger trg_transactions_updated before update on public.transactions
  for each row execute function public.set_updated_at();

-- ORDERS --------------------------------------------------------------------
create table public.orders (
  id             uuid primary key default gen_random_uuid(),
  shop_id        uuid not null references public.shops(id) on delete cascade,
  customer_id    uuid not null references public.customers(id) on delete cascade,
  items_summary  text not null default '',
  total_amount   numeric(12,2) not null,
  advance_paid   numeric(12,2) not null default 0,
  status         text not null default 'CONFIRMED' check (status in ('CONFIRMED','READY','DELIVERED','COMPLETED')),
  order_date     timestamptz not null,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  deleted_at     timestamptz
);
create index idx_orders_shop on public.orders(shop_id);
create index idx_orders_customer on public.orders(customer_id);
create trigger trg_orders_updated before update on public.orders
  for each row execute function public.set_updated_at();

-- CHAT MESSAGES ---------------------------------------------------------------
create table public.chat_messages (
  id            uuid primary key default gen_random_uuid(),
  shop_id       uuid not null references public.shops(id) on delete cascade,
  customer_id   uuid not null references public.customers(id) on delete cascade,
  sender        text not null check (sender in ('SHOP','CUSTOMER')),
  message       text not null,
  message_type  text not null default 'TEXT' check (message_type in ('TEXT','BILL','PAYMENT')),
  sent_at       timestamptz not null,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz
);
create index idx_chat_shop on public.chat_messages(shop_id);
create index idx_chat_customer_sent on public.chat_messages(customer_id, sent_at);
create trigger trg_chat_updated before update on public.chat_messages
  for each row execute function public.set_updated_at();

-- REMINDERS -------------------------------------------------------------------
create table public.reminders (
  id             uuid primary key default gen_random_uuid(),
  shop_id        uuid not null references public.shops(id) on delete cascade,
  -- Nullable: a 'PAY_SUPPLIER' reminder isn't tied to any customer row.
  customer_id    uuid references public.customers(id) on delete cascade,
  title          text not null,
  amount         numeric(12,2) not null default 0,
  due_date       timestamptz not null,
  reminder_type  text not null default 'RECOVER_UDHAR' check (reminder_type in ('RECOVER_UDHAR','PAY_SUPPLIER')),
  alert_option   text not null default 'sameDay' check (alert_option in ('sameDay','oneDayBefore','threeDaysBefore')),
  is_settled     boolean not null default false,
  note           text not null default '',
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  deleted_at     timestamptz
);
create index idx_reminders_shop_due on public.reminders(shop_id, due_date);
create index idx_reminders_shop_settled on public.reminders(shop_id, is_settled);
create trigger trg_reminders_updated before update on public.reminders
  for each row execute function public.set_updated_at();

-- ROW LEVEL SECURITY ------------------------------------------------------------
alter table public.shops enable row level security;
alter table public.customers enable row level security;
alter table public.transactions enable row level security;
alter table public.orders enable row level security;
alter table public.chat_messages enable row level security;
alter table public.reminders enable row level security;

create policy "owner can manage own shop" on public.shops
  for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());

create policy "owner can manage own customers" on public.customers
  for all
  using (shop_id in (select id from public.shops where owner_id = auth.uid()))
  with check (shop_id in (select id from public.shops where owner_id = auth.uid()));

create policy "owner can manage own transactions" on public.transactions
  for all
  using (shop_id in (select id from public.shops where owner_id = auth.uid()))
  with check (shop_id in (select id from public.shops where owner_id = auth.uid()));

create policy "owner can manage own orders" on public.orders
  for all
  using (shop_id in (select id from public.shops where owner_id = auth.uid()))
  with check (shop_id in (select id from public.shops where owner_id = auth.uid()));

create policy "owner can manage own chat_messages" on public.chat_messages
  for all
  using (shop_id in (select id from public.shops where owner_id = auth.uid()))
  with check (shop_id in (select id from public.shops where owner_id = auth.uid()));

create policy "owner can manage own reminders" on public.reminders
  for all
  using (shop_id in (select id from public.shops where owner_id = auth.uid()))
  with check (shop_id in (select id from public.shops where owner_id = auth.uid()));
