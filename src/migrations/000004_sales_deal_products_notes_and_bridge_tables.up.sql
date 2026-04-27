create table sales.crm_deals_products (
  deal_id text not null references sales.crm_deals(id),
  product_id text not null references sales.crm_products(id),
  primary key (deal_id, product_id)
);

create index on sales.crm_deals_products (product_id);

create table sales.crm_deals_contacts (
  deal_id text not null references sales.crm_deals(id),
  contact_id text not null references sales.crm_contacts(id),
  primary key (deal_id, contact_id)
);

create index on sales.crm_deals_contacts (contact_id);

create table sales.crm_organizations_industries (
  organization_id text not null references sales.crm_organizations(id),
  industry_id text not null references sales.crm_industries(id),
  primary key (organization_id, industry_id)
);

create index on sales.crm_organizations_industries (industry_id);

create table sales.crm_organizations_users (
  organization_id text not null references sales.crm_organizations(id),
  user_id text not null references sales.crm_users(id),
  primary key (organization_id, user_id)
);

create index on sales.crm_organizations_users (user_id);

create table sales.crm_teams_users (
  team_id text not null references sales.crm_teams(id),
  user_id text not null references sales.crm_users(id),
  primary key (team_id, user_id)
);

create index on sales.crm_teams_users (user_id);

create table sales.crm_tasks_users (
  task_id text not null references sales.crm_tasks(id),
  user_id text not null references sales.crm_users(id),
  primary key (task_id, user_id)
);

create index on sales.crm_tasks_users (user_id);
