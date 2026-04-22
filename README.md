# curly-spoon

Database migrations for the **modest-galois** project. Manages schema evolution for the Postgres database using [golang-migrate/migrate](https://github.com/golang-migrate/migrate).

## Structure

```
src/migrations/
  000001_sales_schema.up.sql                                         # create the sales schema
  000001_sales_schema.down.sql
  000002_sales_core_tables.up.sql                                    # campaigns, lost_reasons, pipelines, products, segments, sources, teams, users
  000002_sales_core_tables.down.sql
  000003_sales_pipeline_stages_orgs_contacts_deals_tasks.up.sql      # pipeline_stages, organizations, contacts, deals, tasks
  000003_sales_pipeline_stages_orgs_contacts_deals_tasks.down.sql
  000004_sales_deal_products_notes_and_bridge_tables.up.sql          # deal_products, deal_notes, deal_contacts, organization_segments, organization_followers, team_users, task_owners
  000004_sales_deal_products_notes_and_bridge_tables.down.sql
  000005_integrations_schema.up.sql                                  # create the integrations schema
  000005_integrations_schema.down.sql
  000006_integrations_connections_and_sync_cursors.up.sql            # connections and sync_cursors
  000006_integrations_connections_and_sync_cursors.down.sql
```

## Local development

Spin up Postgres and run all migrations:

```bash
docker compose up
```

The `migrate/migrate` container waits for Postgres to be healthy, then applies all pending migrations. A clean run exits with code 0 and logs something like:

```
1/u sales_schema (4ms)
2/u sales_core_tables (12ms)
3/u sales_pipeline_stages_orgs_contacts_deals_tasks (18ms)
4/u sales_deal_products_notes_and_bridge_tables (22ms)
5/u integrations_schema (3ms)
6/u integrations_connections_and_sync_cursors (8ms)
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

## Schemas

### sales

```mermaid
erDiagram
    CAMPAIGN {
        text id
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    LOST_REASON {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    PIPELINE {
        text id
        text name
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    PIPELINE_STAGE {
        text id
        text name
        text description
        text objective
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    PRODUCT {
        text id
        text name
        text description
        numeric price
        boolean visible
        timestamptz created_at
        timestamptz updated_at
    }

    SEGMENT {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    SOURCE {
        text id
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    TEAM {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    USER {
        text id
        text name
        text email
        text phone
        timestamptz created_at
        timestamptz updated_at
    }

    ORGANIZATION {
        text id
        text name
        text description
        text url
        jsonb address
        timestamptz created_at
        timestamptz updated_at
    }

    CONTACT {
        text id
        text name
        text job_title
        jsonb emails
        jsonb phones
        jsonb social_profiles
        jsonb legal_bases
        timestamptz created_at
        timestamptz updated_at
    }

    DEAL {
        text id
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

    DEAL_PRODUCT {
        text id
        numeric price
        numeric quantity
        text discount_type
        numeric discount
        numeric total_price
        text billing_frequency
        timestamptz created_at
        timestamptz updated_at
    }

    DEAL_NOTE {
        text id
        text description
        timestamptz created_at
        timestamptz pinned_at
        timestamptz edited_at
    }

    TASK {
        text id
        text name
        text description
        text type
        text status
        timestamptz due_date
        timestamptz completed_at
        timestamptz created_at
        timestamptz updated_at
    }

    PIPELINE ||--o{ PIPELINE_STAGE : "has"
    PIPELINE_STAGE ||--o{ DEAL : "current_stage"
    USER o|--o{ ORGANIZATION : "owns"
    USER o|--o{ DEAL : "owns"
    USER ||--o{ DEAL_NOTE : "author"
    USER o|--o{ DEAL_NOTE : "edited"
    USER ||--o{ TASK : "created"
    USER o|--o{ TASK : "completed"
    SOURCE o|--o{ DEAL : "sourced_from"
    CAMPAIGN o|--o{ DEAL : "attributed_to"
    LOST_REASON o|--o{ DEAL : "lost_by"
    ORGANIZATION o|--o{ CONTACT : "has"
    ORGANIZATION o|--o{ DEAL : "belongs_to"
    DEAL ||--o{ DEAL_PRODUCT : "has"
    PRODUCT ||--o{ DEAL_PRODUCT : "references"
    DEAL ||--o{ DEAL_NOTE : "has"
    DEAL o|--o{ TASK : "has"
    DEAL }o--o{ CONTACT : "links"
    ORGANIZATION }o--o{ SEGMENT : "classified_as"
    ORGANIZATION }o--o{ USER : "followed_by"
    TEAM }o--o{ USER : "includes"
    TASK }o--o{ USER : "assigned_to"
```

> All tables in this diagram live in the `sales` schema. IDs are `text` — the CRM's own IDs are used as internal primary keys.

### integrations

```mermaid
erDiagram
    CONNECTION {
        uuid id
        text provider
        text account_name
        text status
        text client_id
        text client_secret
        text access_token
        text refresh_token
        text token_type
        timestamptz expires_at
        boolean reauth_required
        text redirect_uri
        jsonb config
        timestamptz last_refresh_at
        text last_refresh_error
        timestamptz created_at
        timestamptz updated_at
    }

    SYNC_CURSOR {
        bigint id
        text resource
        text cursor_type
        jsonb cursor
        timestamptz last_sync_at
        text last_sync_status
        text last_error
        timestamptz created_at
        timestamptz updated_at
    }

    CONNECTION ||--o{ SYNC_CURSOR : "tracks"
```

> All tables in this diagram live in the `integrations` schema. `connections` stores provider auth state, including access and refresh token lifecycle fields, and `sync_cursors` stores per-resource sync progress for each connection.
