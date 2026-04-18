# curly-spoon

Database migrations for the **modest-galois** project. Manages schema evolution for the Postgres database using [golang-migrate/migrate](https://github.com/golang-migrate/migrate).

## Structure

```
src/migrations/
  000001_sales_schema.up.sql                                         # initial sales schema: campaigns, lost_reasons, pipelines, products, segments, sources, teams, users
  000001_sales_schema.down.sql
  000002_sales_pipeline_stages_orgs_contacts_deals_tasks.up.sql     # pipeline_stages, organizations, contacts, deals, tasks
  000002_sales_pipeline_stages_orgs_contacts_deals_tasks.down.sql
  000003_sales_deal_products_notes_and_bridge_tables.up.sql         # deal_products, deal_notes, deal_contacts, organization_segments, organization_followers, team_users, task_owners
  000003_sales_deal_products_notes_and_bridge_tables.down.sql
```

## Local development

Spin up Postgres and run all migrations:

```bash
docker compose up
```

The `migrate/migrate` container waits for Postgres to be healthy, then applies all pending migrations. A clean run exits with code 0 and logs something like:

```
1/u sales_schema (12ms)
2/u sales_pipeline_stages_orgs_contacts_deals_tasks (18ms)
3/u sales_deal_products_notes_and_bridge_tables (22ms)
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

    pipeline_stages {
        text id PK
        text pipeline_id FK
        text name
        text description
        text objective
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    organizations {
        text id PK
        text owner_id FK
        text name
        text description
        text url
        jsonb address
        timestamptz created_at
        timestamptz updated_at
    }

    contacts {
        text id PK
        text organization_id FK
        text name
        text job_title
        jsonb emails
        jsonb phones
        jsonb social_profiles
        jsonb legal_bases
        timestamptz created_at
        timestamptz updated_at
    }

    deals {
        text id PK
        text pipeline_id FK
        text stage_id FK
        text owner_id FK
        text source_id FK
        text campaign_id FK
        text lost_reason_id FK
        text organization_id FK
        text name
        numeric recurrence_price
        numeric one_time_price
        numeric total_price
        date expected_close_date
        integer rating
        text status
        timestamptz closed_at
        jsonb distribution_settings
        timestamptz created_at
        timestamptz updated_at
    }

    tasks {
        text id PK
        text created_by_id FK
        text completed_by_id FK
        text deal_id FK
        text name
        text description
        text type
        text status
        timestamptz due_date
        timestamptz completed_at
        timestamptz created_at
        timestamptz updated_at
    }

    deal_products {
        text id PK
        text deal_id FK
        text product_id FK
        numeric price
        numeric quantity
        text discount_type
        numeric discount
        numeric total_price
        text billing_frequency
        timestamptz created_at
        timestamptz updated_at
    }

    deal_notes {
        text id PK
        text deal_id FK
        text user_id FK
        text description
        timestamptz registered_at
        timestamptz pinned_at
        text edited_by_id FK
        timestamptz edited_at
    }

    deal_contacts {
        text deal_id FK
        text contact_id FK
    }

    organization_segments {
        text organization_id FK
        text segment_id FK
    }

    organization_followers {
        text organization_id FK
        text user_id FK
    }

    team_users {
        text team_id FK
        text user_id FK
    }

    task_owners {
        text task_id FK
        text user_id FK
    }

    pipelines ||--o{ pipeline_stages : "has"
    pipelines ||--o{ deals : "has"
    pipeline_stages ||--o{ deals : "has"
    users ||--o{ organizations : "owns"
    users ||--o{ deals : "owns"
    users ||--o{ tasks : "created_by"
    users ||--o{ tasks : "completed_by"
    sources ||--o{ deals : "source"
    campaigns ||--o{ deals : "campaign"
    lost_reasons ||--o{ deals : "lost_reason"
    organizations ||--o{ contacts : "has"
    organizations ||--o{ deals : "has"
    deals ||--o{ tasks : "has"
    deals ||--o{ deal_products : "has"
    products ||--o{ deal_products : "in"
    deals ||--o{ deal_notes : "has"
    users ||--o{ deal_notes : "authored"
    users ||--o{ deal_notes : "edited"
    deals }o--o{ contacts : "deal_contacts"
    organizations }o--o{ segments : "organization_segments"
    organizations }o--o{ users : "organization_followers"
    teams }o--o{ users : "team_users"
    tasks }o--o{ users : "task_owners"
```

> All tables live in the `sales` schema. IDs are `text` — the CRM's own IDs are used as internal primary keys.
