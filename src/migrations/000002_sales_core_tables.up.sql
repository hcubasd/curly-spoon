create table sales.crm_campaigns (
  id text primary key,
  name text not null,
  description text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_loss_reasons (
  id text primary key,
  name text not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_pipelines (
  id text primary key,
  name text not null,
  display_order integer not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_products (
  id text primary key,
  name text not null,
  description text,
  price numeric(14, 2) not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_industries (
  id text primary key,
  name text not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_sources (
  id text primary key,
  name text not null,
  description text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_teams (
  id text primary key,
  name text not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table sales.crm_users (
  id text primary key,
  name text not null,
  email text,
  phone text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_campaigns (updated_at);
create index on sales.crm_loss_reasons (updated_at);
create index on sales.crm_pipelines (updated_at);
create index on sales.crm_products (updated_at);
create index on sales.crm_industries (updated_at);
create index on sales.crm_sources (updated_at);
create index on sales.crm_teams (updated_at);
create index on sales.crm_users (updated_at);
