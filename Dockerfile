# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-python-docker/blob/master/Dockerfile

FROM gcr.io/kaggle-images/python:v69

# Install Basic Utilities
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    libffi-dev \
    software-properties-common \
    python3.7 \
    python3.7-dev \
    python3-pip \
    && add-apt-repository ppa:jonathonf/python-3.7 \
    && rm -rf /var/lib/apt/lists/*

# Add Backwards Compatibility
RUN rm -rf /usr/bin/python3 && ln /usr/bin/python3.7 /usr/bin/python3

# Set Env Variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install Pip3 Pipenv
RUN pip3 install pipenv==2018.11.26

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# Install Dependencies
RUN set -ex && pipenv install --dev --system --ignore-pipfile --deploy

# Install Jupyter Lab Extensions
RUN jupyter labextension install jupyterlab_bokeh
RUN jupyter labextension install jupyterlab_vim
RUN jupyter labextension install jupyterlab-flake8
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install @jupyterlab/git
RUN jupyter labextension install @jupyterlab/plotly-extension
RUN jupyter labextension install @jupyterlab/toc
RUN jupyter labextension install @krassowski/jupyterlab-lsp
RUN jupyter labextension install @lckr/jupyterlab_variableinspector
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter
