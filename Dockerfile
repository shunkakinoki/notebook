# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-python-docker/blob/master/Dockerfile

FROM gcr.io/kaggle-images/python:v71

# Install Basic Utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        sudo \
        git \
        bzip2 \
        libx11-6 \
        libffi-dev \
        software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Install Jq to Parse Json within Bash Scripts
# Reference:
# https://hub.docker.com/r/pindar/jq/dockerfile
RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
    chmod +x /usr/local/bin/jq

# Install Node JS
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get -y --no-install-recommends install nodejs

# Install Pip3 Pipenv
RUN pip install pipenv==2018.11.26

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

# Install Jupyter Lab Extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install @jupyterlab/git
# RUN jupyter labextension install @jupyterlab/plotly-extension
RUN jupyter labextension install @jupyterlab/toc
RUN jupyter labextension install @krassowski/jupyterlab-lsp
RUN jupyter labextension install @lckr/jupyterlab_variableinspector
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter
RUN jupyter labextension install jupyterlab_bokeh
RUN jupyter labextension install jupyterlab_vim
RUN jupyter labextension install jupyterlab-flake8
RUN jupyter labextension install jupyterlab-nvdashboard
