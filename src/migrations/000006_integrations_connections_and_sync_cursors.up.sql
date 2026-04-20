create table integrations.connections (
  id uuid primary key,
  provider text not null,
  account_name text not null,
  status text not null,
  client_id text,
  client_secret text,
  access_token text,
  refresh_token text,
  token_type text,
  expires_at timestamptz,
  reauth_required boolean not null default false,
  redirect_uri text,
  config jsonb not null default '{}'::jsonb,
  last_refresh_at timestamptz,
  last_refresh_error text,
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create index on integrations.connections (provider);
create index on integrations.connections (status);
create index on integrations.connections (expires_at);
create index on integrations.connections (reauth_required);
create index on integrations.connections (updated_at);

create table integrations.sync_cursors (
  id bigint generated always as identity primary key,
  connection_id uuid not null references integrations.connections(id),
  resource text not null,
  cursor_type text not null,
  cursor jsonb not null default '{}'::jsonb,
  last_sync_at timestamptz,
  last_sync_status text,
  last_error text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  unique (connection_id, resource)
);

create index on integrations.sync_cursors (connection_id);
create index on integrations.sync_cursors (resource);
create index on integrations.sync_cursors (last_sync_at);
create index on integrations.sync_cursors (last_sync_status);
create index on integrations.sync_cursors (updated_at);
