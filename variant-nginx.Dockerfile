# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NGINX SETUP START
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------------------------------------------------------------------------------------------------------------
# NGINX ENVIRONMENT VARIABLES
ENV NGINX_ACCESS_LOG="/var/log/nginx/access.log main" \
    NGINX_ACCESS_LOG_HEALTHCHECK_ENABLED="0" \
    NGINX_API_LOCATION=/api \
    NGINX_API_V1_LOCATION=/api/v1 \
    NGINX_API_X_ROBOTS_TAG="noindex, nofollow, noarchive, nosnippet" \
    NGINX_CLIENT_MAX_BODY_SIZE=1m \
    NGINX_DOCUMENTS_X_ROBOTS_TAG="noindex, nofollow, noarchive, nosnippet" \
    NGINX_ERROR_LOG="/var/log/nginx/error.log warn" \
    NGINX_HTML_X_ROBOTS_TAG="noindex, nofollow, noarchive, nosnippet" \
    NGINX_KEEPALIVE_REQUESTS=10000 \
    NGINX_KEEPALIVE_TIMEOUT=650 \
    NGINX_LARGE_CLIENT_HEADER_BUFFERS_SIZE=16k \
    NGINX_PORT=8080 \
    NGINX_PROXYPASS_CONFIG=false \
    NGINX_ROOT=/var/www/html/public \
    NGINX_SERVER_TOKENS="off" \
    NGINX_STATIC_CACHE_CONTROL_HEADER="public, max-age=31557600, s-maxage=31557600" \
    NGINX_STATIC_X_CACHE_CONTROL_TTL_HEADER="604800" \
    NGINX_STATIC_X_ROBOTS_TAG="noindex, nofollow, noarchive, nosnippet" \
    NGINX_UPSTREAM_API_PORT=8085 \
    NGINX_UPSTREAM_API_V1_PORT=8285 \
    NGINX_UPSTREAM_WEBSOCKET_PORT=3005 \
    NGINX_WEBSOCKET_LOCATION=/ws \
    NGINX_WEBSOCKET_X_ROBOTS_TAG="noindex, nofollow, noarchive, nosnippet" \
    NGINX_WORKER_CONNECTIONS=1024 \
    NGINX_WORKER_PROCESSES=1 \
    NGINX_WORKER_RLIMIT_NOFILE=65535 \
    NGINX_X_CONTENT_TYPE_OPTIONS="nosniff" \
    NGINX_X_XSS_PROTECTION="1; mode=block"
# ----------------------------------------------------------------------------------------------------------------------
# NGINX
RUN DEBIAN_FRONTEND=noninteractive && \
    NGINX_KEYRING=/usr/share/keyrings/nginx-archive-keyring.gpg && \
    NGINX_REPO="$(lsb_release -c -s) nginx" && \
    curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o ${NGINX_KEYRING} && \
    echo "deb [signed-by=${NGINX_KEYRING}] http://nginx.org/packages/debian ${NGINX_REPO}" > /etc/apt/sources.list.d/nginx.list && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        nginx=${NGINX_VERSION}-${NGINX_PKG_RELEASE} \
        nginx-module-xslt=${NGINX_VERSION}-${NGINX_PKG_RELEASE} \
        nginx-module-geoip=${NGINX_VERSION}-${NGINX_PKG_RELEASE} \
        nginx-module-image-filter=${NGINX_VERSION}-${NGINX_PKG_RELEASE} \
        nginx-module-njs=${NGINX_VERSION}+${NGINX_NJS_VERSION}-${NGINX_PKG_RELEASE} && \
# Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ----------------------------------------------------------------------------------------------------------------------
# NGINX LOGGING AND USER SETUP
# Create PID folders and forward nginx logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -p \
        /run/nginx && \
    chown node:node -R \
        /etc/nginx \
        /run/nginx \
        /var/log/nginx
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NGINX SETUP END
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
