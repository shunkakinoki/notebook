# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-python-docker/blob/master/Dockerfile
# https://github.com/kiccho1101/datascience-docker-light/blob/master/Dockerfile

FROM python:3.7-alpine

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock
COPY generate.py generate.py

# Install Libraries
RUN python3 generate.py > requirements.txt

# Install Dependencies
RUN pip3 install -r requirements.txt