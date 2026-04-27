create table sales.crm_pipeline_stages (
  id text primary key,
  pipeline_id text not null references sales.crm_pipelines(id),
  name text not null,
  description text,
  objective text,
  display_order integer not null,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_pipeline_stages (pipeline_id);
create index on sales.crm_pipeline_stages (updated_at);

create table sales.crm_organizations (
  id text primary key,
  owner_id text references sales.crm_users(id),
  name text not null,
  description text,
  url text,
  address jsonb,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_organizations (owner_id);
create index on sales.crm_organizations (updated_at);

create table sales.crm_contacts (
  id text primary key,
  organization_id text references sales.crm_organizations(id),
  name text not null,
  job_title text,
  emails jsonb not null default '[]'::jsonb,
  phones jsonb not null default '[]'::jsonb,
  social_profiles jsonb not null default '[]'::jsonb,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_contacts (organization_id);
create index on sales.crm_contacts (updated_at);

create table sales.crm_deals (
  id text primary key,
  stage_id text not null references sales.crm_pipeline_stages(id),
  owner_id text references sales.crm_users(id),
  source_id text references sales.crm_sources(id),
  campaign_id text references sales.crm_campaigns(id),
  loss_reason_id text references sales.crm_loss_reasons(id),
  organization_id text references sales.crm_organizations(id),
  name text not null,
  expected_close_date date,
  rating integer,
  status text not null,
  closed_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_deals (stage_id);
create index on sales.crm_deals (owner_id);
create index on sales.crm_deals (source_id);
create index on sales.crm_deals (campaign_id);
create index on sales.crm_deals (loss_reason_id);
create index on sales.crm_deals (organization_id);
create index on sales.crm_deals (status);
create index on sales.crm_deals (updated_at);
create index on sales.crm_deals (expected_close_date);

create table sales.crm_tasks (
  id text primary key,
  created_by_id text not null references sales.crm_users(id),
  completed_by_id text references sales.crm_users(id),
  deal_id text references sales.crm_deals(id),
  name text not null,
  description text,
  type text not null,
  status text not null,
  due_date timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on sales.crm_tasks (created_by_id);
create index on sales.crm_tasks (completed_by_id);
create index on sales.crm_tasks (deal_id);
create index on sales.crm_tasks (status);
create index on sales.crm_tasks (due_date);
create index on sales.crm_tasks (updated_at);
