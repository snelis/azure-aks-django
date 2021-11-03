# This Makefile is based on the Makefile defined in the Python Best Practices repository:
# https://git.datapunt.amsterdam.nl/Datapunt/python-best-practices/blob/master/dependency_management/
#
# VERSION = 2020.01.29
.PHONY = help pip-tools install requirements update test init
UID:=$(shell id --user)
GID:=$(shell id --group)

dc = docker-compose
run = $(dc) run --rm -u ${UID}:${GID}
manage = $(run) dev python manage.py
pytest = $(run) test pytest $(ARGS)

build_version := $(shell git describe --tags --exact-match 2> /dev/null || git symbolic-ref -q --short HEAD)
build_revision := $(shell git rev-parse --short HEAD)
build_date := $(shell date --iso-8601=seconds)

init: clean build migrate           ## Init clean

help:                               ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

pip-tools:
	pip install pip-tools

install: pip-tools                  ## Install requirements and sync venv with expected state as defined in requirements.txt
	pip-sync requirements_dev.txt

requirements: pip-tools             ## Upgrade requirements (in requirements.in) to latest versions and compile requirements.txt
	pip-compile --upgrade --output-file requirements.txt requirements.in
	pip-compile --upgrade --output-file requirements_dev.txt requirements_dev.in

upgrade: requirements install       ## Run 'requirements' and 'install' targets

migrations:                         ## Make migrations
	$(manage) makemigrations $(ARGS)

migrate:                            ## Migrate
	$(manage) migrate

messages:
	$(manage) makemessages -a $(ARGS)
	$(manage) compilemessages

urls:
	$(manage) show_urls

build: export BUILD_DATE=$(build_date)
build: export BUILD_REVISION=$(build_revision)
build: export BUILD_VERSION=$(build_version)
build:                              ## Build docker image
	$(dc) build

push: build                         ## Push docker image to registry
	$(dc) push

push_semver:
	VERSION=$${VERSION} $(MAKE) push
	VERSION=$${VERSION%\.*} $(MAKE) push
	VERSION=$${VERSION%%\.*} $(MAKE) push

app:                                ## Run app
	$(run) --service-ports app

bash:                               ## Run the container and start bash
	$(run) dev bash

shell:
	$(manage) shell_plus --print-sql

dev:                                ## Run the development app (and run extra migrations first)
	$(run) --service-ports dev

lint:                               ## Execute lint checks
	$(run) test isort /app/src /app/tests --check --diff
	$(run) test black /app/src /app/tests --check --diff

lintfix:                            ## Execute lint fixes
	$(run) test isort /app/src/$(APP) /app/tests/$(APP)
	$(run) test black /app/src/$(APP) /app/tests/$(APP)

test: lint                          ## Execute tests
	$(run) test pytest /app/tests $(ARGS)

pdb:
	$(run) test pytest --pdb $(ARGS)

superuser:                          ## Create a superuser (user with admin rights)
	$(manage) createsuperuser

clean:                              ## Clean docker stuff
	$(dc) down -v --remove-orphans

FIXTURE = dump
dumpdata:
	$(run) dev bash -c './manage.py dumpdata -a --format=yaml $(APP) > /app/fixtures/$(FIXTURE).yaml'

loaddata:
	$(run) dev bash -c './manage.py loaddata /app/fixtures/$(FIXTURE).yaml'

env:                                ## Print current env
	env | sort
