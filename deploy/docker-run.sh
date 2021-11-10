#!/usr/bin/env bash

set -u   # crash on missing env variables
set -e   # stop on any error
set -x

# check deploy settings to ensure we are deploying a correctly configured app
python manage.py check --deploy --fail-level ERROR

# migrate the db
python manage.py migrate --noinput

# create caching table
python manage.py createcachetable

# Collectstatic
python manage.py collectstatic

# run uwsgi
# exec uwsgi --emperor=.
exec uvicorn \
    --host="0.0.0.0" \
    --port=8000 \
    --workers=4 \
    --no-server-header \
    --log-level=debug \
    ${UVICORN_CMD_ARGS:-} \
    main.asgi:application
    
