#!/bin/bash

check_health() {
  # Check if the Keycloak database exists
  KC_DB_EXISTS=$(mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="SHOW DATABASES LIKE '$SCHEMA_KC';" 2>/dev/null)

  # Check if the App database exists
  APP_DB_EXISTS=$(mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="SHOW DATABASES LIKE '$SCHEMA_APP';" 2>/dev/null)

  # Check if the Keycloak user exists
  KC_USER_EXISTS=$(mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="SELECT User FROM mysql.user WHERE User = '$SCHEMA_KC_USER';" 2>/dev/null)

  # Check if the App user exists
  APP_USER_EXISTS=$(mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute="SELECT User FROM mysql.user WHERE User = '$SCHEMA_APP_USER';" 2>/dev/null)

  # Validate health checks
  if [ -z "$KC_DB_EXISTS" ]; then
    echo "Keycloak database '$SCHEMA_KC' does not exist."
    return 1
  fi

  if [ -z "$APP_DB_EXISTS" ]; then
    echo "App database '$SCHEMA_APP' does not exist."
    return 1
  fi

  if [ -z "$KC_USER_EXISTS" ]; then
    echo "User '$SCHEMA_KC_USER' does not exist."
    return 1
  fi

  if [ -z "$APP_USER_EXISTS" ]; then
    echo "User '$SCHEMA_APP_USER' does not exist."
    return 1
  fi

  return 0
}

if check_health; then
  echo "Both Keycloak and App databases and users are healthy!"
else
  echo "Health check failed."
  exit 1
fi