create table sales.deal_products (
  id text primary key,
  deal_id text not null references sales.deals(id),
  product_id text not null references sales.products(id),
  price numeric(14, 2) not null,
  quantity numeric(14, 4) not null,
  discount_type text,
  discount numeric(14, 4) not null default 0,
  total_price numeric(14, 2) not null,
  billing_frequency text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.deal_products (deal_id);
create index on sales.deal_products (product_id);
create index on sales.deal_products (updated_at);

create table sales.deal_notes (
  id text primary key,
  deal_id text not null references sales.deals(id),
  author_id text not null references sales.users(id),
  description text not null,
  created_at timestamptz not null,
  pinned_at timestamptz,
  edited_by_id text references sales.users(id),
  edited_at timestamptz
);

create index on sales.deal_notes (deal_id);
create index on sales.deal_notes (author_id);
create index on sales.deal_notes (edited_by_id);
create index on sales.deal_notes (created_at);

create table sales.deal_contacts (
  deal_id text not null references sales.deals(id),
  contact_id text not null references sales.contacts(id),
  primary key (deal_id, contact_id)
);

create index on sales.deal_contacts (contact_id);

create table sales.organization_segments (
  organization_id text not null references sales.organizations(id),
  segment_id text not null references sales.segments(id),
  primary key (organization_id, segment_id)
);

create index on sales.organization_segments (segment_id);

create table sales.organization_followers (
  organization_id text not null references sales.organizations(id),
  user_id text not null references sales.users(id),
  primary key (organization_id, user_id)
);

create index on sales.organization_followers (user_id);

create table sales.team_users (
  team_id text not null references sales.teams(id),
  user_id text not null references sales.users(id),
  primary key (team_id, user_id)
);

create index on sales.team_users (user_id);

create table sales.task_owners (
  task_id text not null references sales.tasks(id),
  user_id text not null references sales.users(id),
  primary key (task_id, user_id)
);

create index on sales.task_owners (user_id);
