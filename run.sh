#!/bin/bash
# Moves VibraVid's state out of the container layer into Supervisor-managed storage, then hands
# off to the upstream entrypoint (migrations, then runserver as appuser via gosu).
set -euo pipefail

TZ="$(python3 -c 'import json; print(json.load(open("/data/options.json")).get("timezone") or "UTC")')"
export TZ

# Conf/ (config.json, login.json with the TMDB key and provider logins, domains.json) ->
# /config, i.e. the add-on's addon_config folder: editable from HA and included in its backup.
# Seeded from the image defaults on first start only.
if [ -z "$(ls -A /config 2>/dev/null)" ]; then
  echo "VibraVid: seeding /config from image defaults"
  cp -a /app/Conf.defaults/. /config/
fi
rm -rf /app/Conf
ln -s /config /app/Conf

# Django DB + its secret key -> /data/django (persists across updates/rebuilds).
mkdir -p /data/django
export DJANGO_DB_DIR=/data/django

chown -R appuser:appuser /config /data/django

exec /usr/local/bin/entrypoint.sh
