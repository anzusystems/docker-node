FROM node:${NODE_VERSION}-bookworm-slim

LABEL maintainer="Lubomir Stanko <lubomir.stanko@petitpress.sk>"

# ----------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# ----------------------------------------------------------------------------------------------------------------------
# Common environment variables
ENV CONFIG_OWNER_NAME=node \
    CONFIG_GROUP_NAME=node \
    CONTAINER_STOP_LOG_FILE="/var/www/html/var/log/container_stop.log" \
    COREPACK_HOME="/usr/lib/node/corepack" \
    COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
    MAIN_TERMINATED_FILE="/var/www/html/var/log/main-terminated" \
    NPM_CONFIG_LOGLEVEL=notice \
    YARN_CACHE_FOLDER="/var/cache/yarn" \
    YARN_ENABLE_TELEMETRY=0 \
    # Unset yarn version - it could break CI and we don't need it
    YARN_VERSION=
# Packages
ENV RUN_DEPS="ca-certificates \
              curl \
              g++ \
              gcc \
              gettext-base \
              git \
              gnupg \
              less \
              logrotate \
              lsb-release \
              make \
              openssh-client \
              procps \
              vim \
              wget"

# ----------------------------------------------------------------------------------------------------------------------
# PACKAGES
# ----------------------------------------------------------------------------------------------------------------------
RUN apt-get update && \
    APT_SUPERVISOR_VERSION=$(apt-cache madison supervisor | awk -v ver="${SUPERVISOR_VERSION}" '$3 ~ ver {print $3; exit}') && \
    apt-get install -y \
        ${RUN_DEPS} \
        supervisor=${APT_SUPERVISOR_VERSION} && \
# Cleanup
    apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------------------------------------------------------
# NPM
# Install static npm version
# ----------------------------------------------------------------------------------------------------------------------
RUN npm install --location=global npm@latest && \
    npm install --location=global auditjs@latest && \
    mkdir -p ${COREPACK_HOME} && \
    corepack prepare yarn@stable --activate && \
    corepack enable && \
# Node cache cleanup
    npm cache clean --force && \
    yarn cache clean --all

# ----------------------------------------------------------------------------------------------------------------------
# USER SETUP
# ----------------------------------------------------------------------------------------------------------------------
RUN sed -i 's/^#alias l/alias l/g' /home/node/.bashrc && \
    echo "update-notifier=false" > /home/node/.npmrc && \
    mkdir -p \
        ${YARN_CACHE_FOLDER} \
        /usr/local/lib/node_modules \
        /var/run/supervisor \
        /var/www/html/var && \
    chown node:node -R \
        ${COREPACK_HOME} \
        ${YARN_CACHE_FOLDER} \
        /home/node/.npmrc \
        /usr/local/bin \
        /usr/local/lib/node_modules \
        /var/run/supervisor \
        /var/www/html

##<autogenerated>##
##</autogenerated>##

# ----------------------------------------------------------------------------------------------------------------------
# RUN CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------
COPY --chown=${CONFIG_OWNER_NAME}:${CONFIG_GROUP_NAME} ./etc /etc
COPY --chown=${CONFIG_OWNER_NAME}:${CONFIG_GROUP_NAME} ./usr /usr

# ----------------------------------------------------------------------------------------------------------------------
# RUN
# Run setup and entrypoint start
# ----------------------------------------------------------------------------------------------------------------------
WORKDIR /var/www/html

USER node

ENTRYPOINT ["docker-custom-entrypoint"]
