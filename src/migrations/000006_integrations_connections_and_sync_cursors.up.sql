CREATE TABLE integrations.connections (
    id uuid PRIMARY KEY,
    provider text NOT NULL,
    account_name text NOT NULL,
    status text NOT NULL,
    client_id text,
    client_secret text,
    access_token text,
    refresh_token text,
    token_type text,
    expires_at timestamptz,
    reauth_required boolean NOT NULL DEFAULT false,
    redirect_uri text,
    config jsonb NOT NULL DEFAULT '{}'::jsonb,
    last_refresh_at timestamptz,
    last_refresh_error text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);

CREATE INDEX ON integrations.connections (provider);
CREATE INDEX ON integrations.connections (status);
CREATE INDEX ON integrations.connections (expires_at);
CREATE INDEX ON integrations.connections (reauth_required);
CREATE INDEX ON integrations.connections (updated_at);

CREATE TABLE integrations.sync_cursors (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    connection_id uuid NOT NULL REFERENCES integrations.connections,
    resource text NOT NULL,
    cursor_type text NOT NULL,
    cursor jsonb NOT NULL DEFAULT '{}'::jsonb,
    last_sync_at timestamptz,
    last_sync_status text,
    last_error text,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    UNIQUE (connection_id, resource)
);

CREATE INDEX ON integrations.sync_cursors (connection_id);
CREATE INDEX ON integrations.sync_cursors (resource);
CREATE INDEX ON integrations.sync_cursors (last_sync_at);
CREATE INDEX ON integrations.sync_cursors (last_sync_status);
CREATE INDEX ON integrations.sync_cursors (updated_at);
