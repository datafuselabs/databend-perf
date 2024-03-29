#!/bin/bash

set -e

cat <<SQL | bendsql
select version();
SQL

cat <<SQL | bendsql
DROP TABLE IF EXISTS customer;
SQL

cat <<SQL | bendsql
CREATE TABLE IF NOT EXISTS customer (
    c_custkey     BIGINT not null,
    c_name        STRING not null,
    c_address     STRING not null,
    c_nationkey   INTEGER not null,
    c_phone       STRING not null,
    c_acctbal     DOUBLE   not null,
    c_mktsegment  STRING not null,
    c_comment     STRING not null
);
SQL

cat <<SQL | bendsql
COPY INTO customer FROM 's3://repo.databend.rs/tpch100/customer/'
credentials=(aws_key_id='$AWS_KEY_ID' aws_secret_key='$AWS_SECRET_KEY') pattern ='customer.tbl.*'
file_format=(type='CSV' field_delimiter='|' record_delimiter='\\n' skip_header=1);
SQL

cat <<SQL | bendsql
SELECT count(*) FROM customer;
SQL
