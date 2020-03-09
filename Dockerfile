# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-python-docker/blob/master/Dockerfile
# https://github.com/kiccho1101/datascience-docker-light/blob/master/Dockerfile

FROM jupyter/scipy-notebook:e255f1aa00b2

# Create a working directory
WORKDIR /app

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# Install Libraries
RUN pip install pipenv==2018.11.26

# Install Dependencies
RUN set -ex && pipenv install --dev --system --ignore-pipfile --deploy
