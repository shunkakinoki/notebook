FROM ubuntu:18.04

# Install Basic Utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    build-essential \
    libzmq3-dev && \
    rm -rf /var/lib/apt/lists/*

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