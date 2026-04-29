CREATE TABLE sales.crm_deals_products (
    deal_id text NOT NULL REFERENCES sales.crm_deals,
    product_id text NOT NULL REFERENCES sales.crm_products,
    PRIMARY KEY (deal_id, product_id)
);

CREATE INDEX ON sales.crm_deals_products (product_id);

CREATE TABLE sales.crm_deals_contacts (
    deal_id text NOT NULL REFERENCES sales.crm_deals,
    contact_id text NOT NULL REFERENCES sales.crm_contacts,
    PRIMARY KEY (deal_id, contact_id)
);

CREATE INDEX ON sales.crm_deals_contacts (contact_id);

CREATE TABLE sales.crm_organizations_industries (
    organization_id text NOT NULL REFERENCES sales.crm_organizations,
    industry_id text NOT NULL REFERENCES sales.crm_industries,
    PRIMARY KEY (organization_id, industry_id)
);

CREATE INDEX ON sales.crm_organizations_industries (industry_id);

CREATE TABLE sales.crm_organizations_users (
    organization_id text NOT NULL REFERENCES sales.crm_organizations,
    user_id text NOT NULL REFERENCES sales.crm_users,
    PRIMARY KEY (organization_id, user_id)
);

CREATE INDEX ON sales.crm_organizations_users (user_id);

CREATE TABLE sales.crm_teams_users (
    team_id text NOT NULL REFERENCES sales.crm_teams,
    user_id text NOT NULL REFERENCES sales.crm_users,
    PRIMARY KEY (team_id, user_id)
);

CREATE INDEX ON sales.crm_teams_users (user_id);

CREATE TABLE sales.crm_tasks_users (
    task_id text NOT NULL REFERENCES sales.crm_tasks,
    user_id text NOT NULL REFERENCES sales.crm_users,
    PRIMARY KEY (task_id, user_id)
);

CREATE INDEX ON sales.crm_tasks_users (user_id);
