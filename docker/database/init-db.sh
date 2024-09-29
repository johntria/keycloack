#!/bin/bash
set -e

# Wait for MySQL to start
echo "Waiting for MySQL to start..."
until mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1; do
  sleep 1
done

echo "MySQL is up - executing scripts"
# Execute SQL commands
mysql --protocol=socket -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOSQL
  CREATE DATABASE IF NOT EXISTS $SCHEMA_KC;
  CREATE USER IF NOT EXISTS '$SCHEMA_KC_USER'@'%' IDENTIFIED BY '$SCHEMA_KC_PASSWORD';
  GRANT ALL PRIVILEGES ON $SCHEMA_KC.* TO '$SCHEMA_KC_USER'@'%';

  CREATE DATABASE IF NOT EXISTS $SCHEMA_APP;
  CREATE USER IF NOT EXISTS '$SCHEMA_APP_USER'@'%' IDENTIFIED BY '$SCHEMA_APP_PASSWORD';
  GRANT ALL PRIVILEGES ON $SCHEMA_APP.* TO '$SCHEMA_APP_USER'@'%';

  FLUSH PRIVILEGES;
EOSQL