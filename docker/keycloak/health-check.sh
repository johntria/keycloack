#!/bin/sh

SERVER_URL="http://localhost:${KC_HTTP_PORT}/"
HEALTH_URL="http://localhost:${KC_HTTP_HEALTH_PORT}/health"

/opt/keycloak/bin/kcadm.sh config credentials --server "$SERVER_URL" --realm master --user "${KEYCLOAK_ADMIN}" --password "${KEYCLOAK_ADMIN_PASSWORD}"

HEALTH_STATUS=$(/opt/keycloak/bin/kcadm.sh get "$HEALTH_URL" 2>/dev/null)

if echo "$HEALTH_STATUS" | grep -q '"status"[[:space:]]*:[[:space:]]*"UP"'; then
    echo "Keycloak is healthy."
    exit 0
else
    echo "Keycloak is not healthy. Exiting..."
    exit 1
fi