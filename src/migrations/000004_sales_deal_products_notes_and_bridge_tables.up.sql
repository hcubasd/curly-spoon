create table sales.crm_deal_products (
  id text primary key,
  deal_id text not null references sales.crm_deals(id),
  product_id text not null references sales.crm_products(id),
  price numeric(14, 2) not null,
  quantity numeric(14, 4) not null,
  discount_type text,
  discount numeric(14, 4) not null default 0,
  total_price numeric(14, 2) not null,
  billing_frequency text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_deal_products (deal_id);
create index on sales.crm_deal_products (product_id);
create index on sales.crm_deal_products (updated_at);

create table sales.crm_deal_notes (
  id text primary key,
  deal_id text not null references sales.crm_deals(id),
  author_id text not null references sales.crm_users(id),
  description text not null,
  created_at timestamptz not null,
  pinned_at timestamptz,
  edited_by_id text references sales.crm_users(id),
  edited_at timestamptz
);

create index on sales.crm_deal_notes (deal_id);
create index on sales.crm_deal_notes (author_id);
create index on sales.crm_deal_notes (edited_by_id);
create index on sales.crm_deal_notes (created_at);

create table sales.crm_deal_contacts (
  deal_id text not null references sales.crm_deals(id),
  contact_id text not null references sales.crm_contacts(id),
  primary key (deal_id, contact_id)
);

create index on sales.crm_deal_contacts (contact_id);

create table sales.crm_organization_industries (
  organization_id text not null references sales.crm_organizations(id),
  industry_id text not null references sales.crm_industries(id),
  primary key (organization_id, industry_id)
);

create index on sales.crm_organization_industries (industry_id);

create table sales.crm_organization_users (
  organization_id text not null references sales.crm_organizations(id),
  user_id text not null references sales.crm_users(id),
  primary key (organization_id, user_id)
);

create index on sales.crm_organization_users (user_id);

create table sales.crm_team_users (
  team_id text not null references sales.crm_teams(id),
  user_id text not null references sales.crm_users(id),
  primary key (team_id, user_id)
);

create index on sales.crm_team_users (user_id);

create table sales.crm_task_users (
  task_id text not null references sales.crm_tasks(id),
  user_id text not null references sales.crm_users(id),
  primary key (task_id, user_id)
);

create index on sales.crm_task_users (user_id);
