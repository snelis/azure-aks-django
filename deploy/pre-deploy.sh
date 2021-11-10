# check deploy settings to ensure we are deploying a correctly configured app
python manage.py check --deploy --fail-level ERROR

# migrate the db
python manage.py migrate --noinput

# create caching table
python manage.py createcachetable
