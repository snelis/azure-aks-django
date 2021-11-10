#!/usr/bin/env bash

set -u   # crash on missing env variables
set -e   # stop on any error
set -x

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
    
