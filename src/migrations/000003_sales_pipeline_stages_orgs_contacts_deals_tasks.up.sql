CREATE TABLE sales.crm_pipeline_stages (
    id text PRIMARY KEY,
    pipeline_id text NOT NULL REFERENCES sales.crm_pipelines,
    title text NOT NULL,
    description text,
    objective text,
    display_order integer NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    synced_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ON sales.crm_pipeline_stages (pipeline_id);
CREATE INDEX ON sales.crm_pipeline_stages (synced_at);

CREATE TABLE sales.crm_organizations (
    id text PRIMARY KEY,
    owner_id text REFERENCES sales.crm_users,
    title text NOT NULL,
    description text,
    website text,
    address jsonb,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    synced_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ON sales.crm_organizations (owner_id);
CREATE INDEX ON sales.crm_organizations (synced_at);

CREATE TABLE sales.crm_contacts (
    id text PRIMARY KEY,
    organization_id text REFERENCES sales.crm_organizations ON DELETE CASCADE,
    full_name text NOT NULL,
    job_title text,
    emails jsonb NOT NULL DEFAULT '[]'::jsonb,
    phones jsonb NOT NULL DEFAULT '[]'::jsonb,
    social_profiles jsonb NOT NULL DEFAULT '[]'::jsonb,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    synced_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ON sales.crm_contacts (organization_id);
CREATE INDEX ON sales.crm_contacts (synced_at);

CREATE TABLE sales.crm_deals (
    id text PRIMARY KEY,
    stage_id text NOT NULL REFERENCES sales.crm_pipeline_stages,
    owner_id text REFERENCES sales.crm_users,
    source_id text REFERENCES sales.crm_sources,
    campaign_id text REFERENCES sales.crm_campaigns,
    loss_reason_id text REFERENCES sales.crm_loss_reasons,
    organization_id text REFERENCES sales.crm_organizations ON DELETE CASCADE,
    title text NOT NULL,
    expected_close_date date,
    rating integer,
    status text NOT NULL,
    amount numeric(14, 2),
    closed_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    synced_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ON sales.crm_deals (stage_id);
CREATE INDEX ON sales.crm_deals (owner_id);
CREATE INDEX ON sales.crm_deals (source_id);
CREATE INDEX ON sales.crm_deals (campaign_id);
CREATE INDEX ON sales.crm_deals (loss_reason_id);
CREATE INDEX ON sales.crm_deals (organization_id);
CREATE INDEX ON sales.crm_deals (status);
CREATE INDEX ON sales.crm_deals (synced_at);
CREATE INDEX ON sales.crm_deals (expected_close_date);

CREATE TABLE sales.crm_tasks (
    id text PRIMARY KEY,
    created_by_id text NOT NULL REFERENCES sales.crm_users,
    completed_by_id text REFERENCES sales.crm_users,
    deal_id text REFERENCES sales.crm_deals ON DELETE CASCADE,
    title text NOT NULL,
    description text,
    task_type text NOT NULL,
    status text NOT NULL,
    due_date timestamptz,
    completed_at timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    synced_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX ON sales.crm_tasks (created_by_id);
CREATE INDEX ON sales.crm_tasks (completed_by_id);
CREATE INDEX ON sales.crm_tasks (deal_id);
CREATE INDEX ON sales.crm_tasks (status);
CREATE INDEX ON sales.crm_tasks (due_date);
CREATE INDEX ON sales.crm_tasks (synced_at);
