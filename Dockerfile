# Top level build args
ARG build_for=linux/amd64
# Base image
FROM --platform=$build_for python:3.10.7-slim-bullseye as base
# Create a directory for your app
# Create a directory within the container to mount your local directory
#ENV APP_DIR /app
#RUN mkdir -p $APP_DIR
#WORKDIR $APP_DIR
# Install SSH Server, Git, and LibYAML, then remove the cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server git libyaml-dev && \
    rm -rf /var/lib/apt/lists/*

# Install PyYAML for dbt
RUN python -m pip install --no-cache-dir PyYAML

#dbt 1.6
RUN python -m venv /root/dbt-1.6
RUN . /root/dbt-1.6/bin/activate && python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/dbt-snowflake@v1.6.6#egg=dbt-snowflake"

#dbt 1.7
RUN python -m venv /root/dbt-1.7
RUN . /root/dbt-1.7/bin/activate && python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/dbt-snowflake@v1.7.1#egg=dbt-snowflake"

#dbt 1.8
RUN python -m venv /root/dbt-1.8
RUN . /root/dbt-1.8/bin/activate && python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/dbt-snowflake@v1.8.3#egg=dbt-snowflake"

# Define the environment variables
ENV SSH_PUBLIC_KEY=""

# Exposing port 22
EXPOSE 22

# Add an entry script
COPY entrypoint.sh ./
COPY lineage.py ./
RUN chmod +x entrypoint.sh lineage.py
ENTRYPOINT ["./entrypoint.sh"]
