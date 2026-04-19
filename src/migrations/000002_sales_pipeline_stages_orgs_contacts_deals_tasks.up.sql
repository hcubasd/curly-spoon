create table sales.pipeline_stages (
    id            text        primary key,
    pipeline_id   text        not null references sales.pipelines(id),
    name          text        not null,
    description   text,
    objective     text,
    display_order integer     not null,
    created_at    timestamptz not null,
    updated_at    timestamptz not null
);

create index on sales.pipeline_stages (pipeline_id);
create index on sales.pipeline_stages (updated_at);

create table sales.organizations (
    id            text        primary key,
    owner_id      text        references sales.users(id),
    name          text        not null,
    description   text,
    url           text,
    address       jsonb,
    created_at    timestamptz not null,
    updated_at    timestamptz not null
);

create index on sales.organizations (owner_id);
create index on sales.organizations (updated_at);

create table sales.contacts (
    id               text        primary key,
    organization_id  text        references sales.organizations(id),
    name             text        not null,
    job_title        text,
    emails           jsonb       not null default '[]'::jsonb,
    phones           jsonb       not null default '[]'::jsonb,
    social_profiles  jsonb       not null default '[]'::jsonb,
    legal_bases      jsonb       not null default '[]'::jsonb,
    created_at       timestamptz not null,
    updated_at       timestamptz not null
);

create index on sales.contacts (organization_id);
create index on sales.contacts (updated_at);

create table sales.deals (
    id                    text           primary key,
    stage_id              text           not null references sales.pipeline_stages(id),
    owner_id              text           references sales.users(id),
    source_id             text           references sales.sources(id),
    campaign_id           text           references sales.campaigns(id),
    lost_reason_id        text           references sales.lost_reasons(id),
    organization_id       text           references sales.organizations(id),
    name                  text           not null,
    recurrence_price      numeric(14, 2) not null default 0,
    one_time_price        numeric(14, 2) not null default 0,
    total_price           numeric(14, 2) not null default 0,
    expected_close_date   date,
    rating                integer,
    status                text           not null,
    closed_at             timestamptz,
    distribution_settings jsonb,
    created_at            timestamptz    not null,
    updated_at            timestamptz    not null
);

create index on sales.deals (stage_id);
create index on sales.deals (owner_id);
create index on sales.deals (source_id);
create index on sales.deals (campaign_id);
create index on sales.deals (lost_reason_id);
create index on sales.deals (organization_id);
create index on sales.deals (status);
create index on sales.deals (updated_at);
create index on sales.deals (expected_close_date);

create table sales.tasks (
    id               text        primary key,
    created_by_id    text        not null references sales.users(id),
    completed_by_id  text        references sales.users(id),
    deal_id          text        references sales.deals(id),
    name             text        not null,
    description      text,
    type             text        not null,
    status           text        not null,
    due_date         timestamptz,
    completed_at     timestamptz,
    created_at       timestamptz not null,
    updated_at       timestamptz not null
);

create index on sales.tasks (created_by_id);
create index on sales.tasks (completed_by_id);
create index on sales.tasks (deal_id);
create index on sales.tasks (status);
create index on sales.tasks (due_date);
create index on sales.tasks (updated_at);
