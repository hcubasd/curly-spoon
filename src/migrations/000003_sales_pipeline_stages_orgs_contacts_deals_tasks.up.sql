CREATE TABLE sales.crm_pipeline_stages (
  id text PRIMARY KEY,
  pipeline_id text NOT NULL REFERENCES sales.crm_pipelines,
  name text NOT NULL,
  description text,
  objective text,
  display_order integer NOT NULL,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_pipeline_stages (pipeline_id);
CREATE INDEX ON sales.crm_pipeline_stages (updated_at);

CREATE TABLE sales.crm_organizations (
  id text PRIMARY KEY,
  owner_id text REFERENCES sales.crm_users,
  name text NOT NULL,
  description text,
  url text,
  address jsonb,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_organizations (owner_id);
CREATE INDEX ON sales.crm_organizations (updated_at);

CREATE TABLE sales.crm_contacts (
  id text PRIMARY KEY,
  organization_id text REFERENCES sales.crm_organizations,
  name text NOT NULL,
  job_title text,
  emails jsonb NOT NULL DEFAULT '[]'::jsonb,
  phones jsonb NOT NULL DEFAULT '[]'::jsonb,
  social_profiles jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_contacts (organization_id);
CREATE INDEX ON sales.crm_contacts (updated_at);

CREATE TABLE sales.crm_deals (
  id text PRIMARY KEY,
  stage_id text NOT NULL REFERENCES sales.crm_pipeline_stages,
  owner_id text REFERENCES sales.crm_users,
  source_id text REFERENCES sales.crm_sources,
  campaign_id text REFERENCES sales.crm_campaigns,
  loss_reason_id text REFERENCES sales.crm_loss_reasons,
  organization_id text REFERENCES sales.crm_organizations,
  name text NOT NULL,
  expected_close_date date,
  rating integer,
  status text NOT NULL,
  value numeric(14, 2),
  closed_at timestamptz,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_deals (stage_id);
CREATE INDEX ON sales.crm_deals (owner_id);
CREATE INDEX ON sales.crm_deals (source_id);
CREATE INDEX ON sales.crm_deals (campaign_id);
CREATE INDEX ON sales.crm_deals (loss_reason_id);
CREATE INDEX ON sales.crm_deals (organization_id);
CREATE INDEX ON sales.crm_deals (status);
CREATE INDEX ON sales.crm_deals (updated_at);
CREATE INDEX ON sales.crm_deals (expected_close_date);

CREATE TABLE sales.crm_tasks (
  id text PRIMARY KEY,
  created_by_id text NOT NULL REFERENCES sales.crm_users,
  completed_by_id text REFERENCES sales.crm_users,
  deal_id text REFERENCES sales.crm_deals,
  name text NOT NULL,
  description text,
  type text NOT NULL,
  status text NOT NULL,
  due_date timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL,
  updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_tasks (created_by_id);
CREATE INDEX ON sales.crm_tasks (completed_by_id);
CREATE INDEX ON sales.crm_tasks (deal_id);
CREATE INDEX ON sales.crm_tasks (status);
CREATE INDEX ON sales.crm_tasks (due_date);
CREATE INDEX ON sales.crm_tasks (updated_at);
