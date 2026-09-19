#!/bin/sh
# Rewrite the JNDI datasource host + password from the env vars the platform
# injects (DB_HOST / DB_PORT / DB_PASSWORD), then hand off to Tomcat. The
# image ships with the local-compose defaults (container-mysql / db_password);
# in any real environment these get replaced at boot.
set -e

CTX=/usr/local/tomcat/conf/context.xml

if [ -n "${DB_HOST:-}" ]; then
  sed -i "s#container-mysql:3306#${DB_HOST}:${DB_PORT:-3306}#g" "$CTX"
fi

if [ -n "${DB_PASSWORD:-}" ]; then
  sed -i "s#password=\"db_password\"#password=\"${DB_PASSWORD}\"#g" "$CTX"
fi

exec catalina.sh run
