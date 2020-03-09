# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-python-docker/blob/master/Dockerfile
# https://github.com/kiccho1101/datascience-docker-light/blob/master/Dockerfile

FROM jupyter/scipy-notebook:e255f1aa00b2

# Install Basic Utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Jq to Parse Json within Bash Scripts
# Reference:
# https://hub.docker.com/r/pindar/jq/dockerfile
RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
    chmod +x /usr/local/bin/jq

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# Generate `requirements.txt`
RUN jq -r '.default | to_entries[] | .key + .value.version' \
    Pipfile.lock >requirements.txt

# Install Libraries
RUN pip install -r requirements.txt

# Install Dependencies
# RUN set -ex && pipenv install --dev --system --ignore-pipfile --deploy
