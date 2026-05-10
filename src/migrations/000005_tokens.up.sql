CREATE TABLE tokens (
    provider text PRIMARY KEY,
    access_token text NOT NULL,
    refresh_token text,
    updated_at timestamptz NOT NULL DEFAULT now()
);
