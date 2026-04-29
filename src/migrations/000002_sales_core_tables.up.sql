CREATE TABLE sales.crm_campaigns (
    id text PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_loss_reasons (
    id text PRIMARY KEY,
    name text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_pipelines (
    id text PRIMARY KEY,
    name text NOT NULL,
    display_order integer NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_products (
    id text PRIMARY KEY,
    name text NOT NULL,
    description text,
    price numeric(14, 2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_industries (
    id text PRIMARY KEY,
    name text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_sources (
    id text PRIMARY KEY,
    name text NOT NULL,
    description text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_teams (
    id text PRIMARY KEY,
    name text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_users (
    id text PRIMARY KEY,
    name text NOT NULL,
    email text,
    phone text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE INDEX ON sales.crm_campaigns (updated_at);
CREATE INDEX ON sales.crm_loss_reasons (updated_at);
CREATE INDEX ON sales.crm_pipelines (updated_at);
CREATE INDEX ON sales.crm_products (updated_at);
CREATE INDEX ON sales.crm_industries (updated_at);
CREATE INDEX ON sales.crm_sources (updated_at);
CREATE INDEX ON sales.crm_teams (updated_at);
CREATE INDEX ON sales.crm_users (updated_at);
