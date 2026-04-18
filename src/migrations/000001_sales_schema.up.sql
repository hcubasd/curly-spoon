create schema if not exists sales;

create table sales.campaigns (
    id          text        primary key,
    name        text        not null,
    description text,
    created_at  timestamptz not null,
    updated_at  timestamptz not null
);

create table sales.lost_reasons (
    id         text        primary key,
    name       text        not null,
    created_at timestamptz not null,
    updated_at timestamptz not null
);

create table sales.pipelines (
    id            text        primary key,
    name          text        not null,
    display_order integer     not null,
    created_at    timestamptz not null,
    updated_at    timestamptz not null
);

create table sales.products (
    id          text           primary key,
    name        text           not null,
    description text,
    price       numeric(14, 2) not null,
    visible     boolean        not null,
    created_at  timestamptz    not null,
    updated_at  timestamptz    not null
);

create table sales.segments (
    id         text        primary key,
    name       text        not null,
    created_at timestamptz not null,
    updated_at timestamptz not null
);

create table sales.sources (
    id          text        primary key,
    name        text        not null,
    description text,
    created_at  timestamptz not null,
    updated_at  timestamptz not null
);

create table sales.teams (
    id         text        primary key,
    name       text        not null,
    created_at timestamptz not null,
    updated_at timestamptz not null
);

create table sales.users (
    id         text        primary key,
    name       text        not null,
    email      text,
    phone      text,
    created_at timestamptz not null,
    updated_at timestamptz not null
);

create index on sales.campaigns  (updated_at);
create index on sales.lost_reasons (updated_at);
create index on sales.pipelines  (updated_at);
create index on sales.products   (updated_at);
create index on sales.segments   (updated_at);
create index on sales.sources    (updated_at);
create index on sales.teams      (updated_at);
create index on sales.users      (updated_at);
