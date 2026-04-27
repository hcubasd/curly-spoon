# curly-spoon

Database migrations for the **modest-galois** project. Manages schema evolution for the Postgres database using [golang-migrate/migrate](https://github.com/golang-migrate/migrate).

## Structure

```
src/migrations/
  000001_sales_schema.up.sql                                         # create the sales schema
  000001_sales_schema.down.sql
  000002_sales_core_tables.up.sql                                    # crm_campaigns, crm_loss_reasons, crm_pipelines, crm_products, crm_industries, crm_sources, crm_teams, crm_users
  000002_sales_core_tables.down.sql
  000003_sales_pipeline_stages_orgs_contacts_deals_tasks.up.sql      # crm_pipeline_stages, crm_organizations, crm_contacts, crm_deals, crm_tasks
  000003_sales_pipeline_stages_orgs_contacts_deals_tasks.down.sql
  000004_sales_deal_products_notes_and_bridge_tables.up.sql          # crm_deal_products, crm_deal_contacts, crm_organization_industries, crm_organization_users, crm_team_users, crm_task_users
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

Every push to any branch triggers the `integration` workflow (`.github/workflows/integration.yaml`), which runs `docker compose up --exit-code-from migrations` to verify all migrations apply cleanly against a fresh Postgres instance.

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
    CRM_CAMPAIGN {
        text id
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_LOSS_REASON {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_PIPELINE {
        text id
        text name
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_PIPELINE_STAGE {
        text id
        text name
        text description
        text objective
        integer display_order
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_PRODUCT {
        text id
        text name
        text description
        numeric price
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_INDUSTRY {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_SOURCE {
        text id
        text name
        text description
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_TEAM {
        text id
        text name
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_USER {
        text id
        text name
        text email
        text phone
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_ORGANIZATION {
        text id
        text name
        text description
        text url
        jsonb address
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_CONTACT {
        text id
        text name
        text job_title
        jsonb emails
        jsonb phones
        jsonb social_profiles
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_DEAL {
        text id
        text name
        date expected_close_date
        integer rating
        text status
        timestamptz closed_at
        jsonb distribution_settings
        timestamptz created_at
        timestamptz updated_at
    }

    CRM_DEAL_PRODUCT {
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

    CRM_TASK {
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

    CRM_PIPELINE ||--o{ CRM_PIPELINE_STAGE : "has"
    CRM_PIPELINE_STAGE ||--o{ CRM_DEAL : "current_stage"
    CRM_USER o|--o{ CRM_ORGANIZATION : "owns"
    CRM_USER o|--o{ CRM_DEAL : "owns"
    CRM_USER ||--o{ CRM_TASK : "created"
    CRM_USER o|--o{ CRM_TASK : "completed"
    CRM_SOURCE o|--o{ CRM_DEAL : "sourced_from"
    CRM_CAMPAIGN o|--o{ CRM_DEAL : "attributed_to"
    CRM_LOSS_REASON o|--o{ CRM_DEAL : "lost_by"
    CRM_ORGANIZATION o|--o{ CRM_CONTACT : "has"
    CRM_ORGANIZATION o|--o{ CRM_DEAL : "belongs_to"
    CRM_DEAL ||--o{ CRM_DEAL_PRODUCT : "has"
    CRM_PRODUCT ||--o{ CRM_DEAL_PRODUCT : "references"
    CRM_DEAL o|--o{ CRM_TASK : "has"
    CRM_DEAL }o--o{ CRM_CONTACT : "links"
    CRM_ORGANIZATION }o--o{ CRM_INDUSTRY : "classified_as"
    CRM_ORGANIZATION }o--o{ CRM_USER : "followed_by"
    CRM_TEAM }o--o{ CRM_USER : "includes"
    CRM_TASK }o--o{ CRM_USER : "assigned_to"
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
