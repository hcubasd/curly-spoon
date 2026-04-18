# curly-spoon

Database migrations for the **modest-galois** project. Manages schema evolution for the Postgres database using [golang-migrate/migrate](https://github.com/golang-migrate/migrate).

## Structure

```
src/migrations/
  000001_sales_schema.up.sql    # creates sales schema and all initial tables
  000001_sales_schema.down.sql  # drops sales schema
```

## Local development

Spin up Postgres and run all migrations:

```bash
docker compose up
```

The `migrate/migrate` container waits for Postgres to be healthy, then applies all pending migrations. A clean run exits with code 0 and logs something like:

```
1/u sales_schema (12ms)
```

## CI

Every push to any branch triggers the `integration` workflow (`.github/workflows/integration.yaml`), which runs `docker compose up --exit-code-from migrate` to verify all migrations apply cleanly against a fresh Postgres instance.

## Migration files

Files follow the `{version}_{title}.{up|down}.sql` convention expected by `golang-migrate/migrate`.

To apply manually:

```bash
migrate -path src/migrations -database "postgres://..." up
```

To rollback one step:

```bash
migrate -path src/migrations -database "postgres://..." down 1
```

## Schema

```mermaid
erDiagram
    campaigns {
        text id PK
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    lost_reasons {
        text id PK
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    pipelines {
        text id PK
        text name
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    products {
        text id PK
        text name
        text description
        numeric price
        boolean visible
        timestamptz created_at
        timestamptz updated_at
    }

    segments {
        text id PK
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    sources {
        text id PK
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    teams {
        text id PK
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    users {
        text id PK
        text name
        text email
        text phone
        timestamptz created_at
        timestamptz updated_at
    }
```

> All tables live in the `sales` schema. IDs are `text` — the CRM's own IDs are used as internal primary keys.
