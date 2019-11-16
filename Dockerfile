# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile
# https://github.com/kiccho1101/kaggle-base/blob/master/docker/kaggle-base/Dockerfile

FROM gcr.io/kaggle-images/python@sha256:bbbc8e8218940423b3c59b5cb67fede5e414c3295256d2bd60b1f4dd3a74d505

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

# Install jupyterlab
RUN pip install jupyterlab \
    && jupyter serverextension enable --py jupyterlab

# Install Jupyter Notebook Extensions
RUN jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user

# Install Jupyter Black
RUN jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && jupyter nbextension enable jupyter-black-master/jupyter-black

# Install Jupyter Isort
RUN jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user \
    && jupyter nbextension enable jupyter-isort-master/jupyter-isort

# Enable Nbextensions (Reference URL: https://qiita.com/simonritchie/items/88161c806197a0b84174)
RUN jupyter nbextension enable table_beautifier/main \
    && jupyter nbextension enable toc2/main \
    && jupyter nbextension enable toggle_all_line_numbers/main \
    && jupyter nbextension enable autosavetime/main \
    && jupyter nbextension enable collapsible_headings/main \
    && jupyter nbextension enable execute_time/ExecuteTime \
    && jupyter nbextension enable codefolding/main \
    && jupyter nbextension enable varInspector/main \
    && jupyter nbextension enable notify/notify 

# Setup jupyter-vim
RUN mkdir -p $(jupyter --data-dir)/nbextensions \
    && cd $(jupyter --data-dir)/nbextensions \
    && git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding \
    && jupyter nbextension enable vim_binding/vim_binding

# # Change Theme
RUN jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8 -cellw 99% \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused:not(.cm-fat-cursor) { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused.cm-fat-cursor { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css
