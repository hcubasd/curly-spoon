CREATE TABLE sales.crm_campaigns (
    id text PRIMARY KEY,
    title text NOT NULL,
    description text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_loss_reasons (
    id text PRIMARY KEY,
    reason text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_pipelines (
    id text PRIMARY KEY,
    title text NOT NULL,
    display_order integer NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_products (
    id text PRIMARY KEY,
    title text NOT NULL,
    description text,
    price numeric(14, 2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_industries (
    id text PRIMARY KEY,
    title text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_sources (
    id text PRIMARY KEY,
    title text NOT NULL,
    description text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_teams (
    id text PRIMARY KEY,
    title text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE TABLE sales.crm_users (
    id text PRIMARY KEY,
    full_name text NOT NULL,
    email text,
    phone text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);
