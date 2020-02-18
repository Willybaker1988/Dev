-- change role to ACCOUNTADMIN
use role ACCOUNTADMIN;

-- create role for looker
create role if not exists looker_role;
grant role looker_role to role SYSADMIN;
    -- Note that we are not making the looker_role a SYSADMIN,
    -- but rather granting users with the SYSADMIN role to modify the looker_role

-- create a user for looker
create user if not exists looker_user
password = '<enter password here>';
grant role looker_role to user looker_user;
alter user looker_user
set default_role = looker_role
default_warehouse = 'looker_wh';

-- change role
use role SYSADMIN;

-- create a warehouse for looker (optional)
create warehouse if not exists looker_wh

-- set the size based on your dataset
warehouse_size = medium
warehouse_type = standard
auto_suspend = 1800
auto_resume = true
initially_suspended = true;
grant all privileges
on warehouse looker_wh
to role looker_role;

-- grant read only database access (repeat for all database/schemas)
grant usage on database <database> to role looker_role;
grant usage on schema <database>.<schema> to role looker_role;

-- rerun the following any time a table is added to the schema
grant select on all tables in schema <database>.<schema> to role looker_role;
-- or
grant select on future tables in schema <database>.<schema> to role looker_role;

-- create schema for looker to write back to
use database <database>;
create schema if not exists looker_scratch;
use role ACCOUNTADMIN;
grant ownership on schema looker_scratch to role SYSADMIN revoke current grants;
grant all on schema looker_scratch to role looker_role;