FROM amsterdam/python:3.9-buster-minimal as app
MAINTAINER datapunt@amsterdam.nl

RUN apt-get update \
    && apt-get autoremove -y \
    && apt-get install --no-install-recommends -y \
           libgdal20 \
    && rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old

RUN wget -q https://raw.githubusercontent.com/dapr/cli/v1.5.0/install/install.sh -O - | /bin/bash

WORKDIR /app/install
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

WORKDIR /app
COPY deploy deploy
COPY src src

WORKDIR /app/src
ARG SECRET_KEY=not-used
ARG CORS_DEFAULT_ALLOWED_ORIGIN=not-used
RUN python manage.py collectstatic --no-input

USER datapunt

# Build metadata
ARG BUILD_DATE
ARG BUILD_REVISION
ARG BUILD_VERSION
ENV BUILD_DATE=$BUILD_DATE
ENV BUILD_REVISION=$BUILD_REVISION
ENV BUILD_VERSION=$BUILD_VERSION

CMD ["/app/deploy/run.sh"]

# stage 2, dev
FROM app as dev

USER root
WORKDIR /app/install
COPY requirements_dev.txt requirements_dev.txt
RUN pip install -r requirements_dev.txt
COPY pyproject.toml /app

WORKDIR /app/src
USER datapunt

# Any process that requires to write in the home dir
# we write to /tmp since we have no home dir
ENV HOME /tmp

CMD ["./manage.py", "runserver", "0.0.0.0:8000"]

# stage 3, tests
FROM dev as tests

USER datapunt
WORKDIR /app/tests
COPY tests .

ENV COVERAGE_FILE=/tmp/.coverage
ENV PYTHONPATH=/app/src

CMD ["pytest"]
