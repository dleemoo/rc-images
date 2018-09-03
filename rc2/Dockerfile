FROM ruby:2.5.1-stretch

MAINTAINER Leonardo Lobo Lima <dleemoo@gmail.com>

ENV PG_DOWNLOAD_SHA256=69ec0f7414748b268b98f49653861c53125f0e2acddf931676902073e21975f5 \
    GEM_HOME=/home/app/gems \
    BUNDLE_PATH=/home/app/gems \
    BUNDLE_BIN=/home/app/gems/bin \
    BUNDLE_APP_CONFIG=/home/app/gems \
    PATH=/home/app/gems/bin:$PATH \
    LANG=C.UTF-8

ARG USER_ID
ARG GROUP=100
ARG APP_DIR=/usr/src/app

RUN set -ex \
  # update debian and install dependencies
  && DEBIAN_FRONTEND=noninteractive apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    autoconf \
    bison \
    build-essential \
    curl \
    git \
    imagemagick \
    libffi-dev \
    libgdbm3 \
    libgdbm-dev \
    libncurses5-dev \
    libreadline6-dev \
    libssl-dev \
    libyaml-dev \
    python \
    zlib1g-dev \
  # adds nodejs and yarn debian repository
  && echo 'deb https://deb.nodesource.com/node_8.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
  && curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && DEBIAN_FRONTEND=noninteractive apt-get update -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nodejs \
    yarn \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  # remove apt files
  && DEBIAN_FRONTEND=noninteractive apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  # setup postgres client libs and headers
  && curl -sL http://ftp.postgresql.org/pub/source/v9.6.9/postgresql-9.6.9.tar.gz -o /tmp/postgresql.tar.gz \
  && echo "$PG_DOWNLOAD_SHA256 /tmp/postgresql.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/postgresql \
  && tar -xzf /tmp/postgresql.tar.gz -C /tmp/postgresql --strip-components=1 \
  && cd /tmp/postgresql \
  && echo "Building postgresql ..." \
  && CFLAGS="-O3 -pipe" ./configure --prefix=/usr/local 1>/dev/null \
  && make -j"$(getconf _NPROCESSORS_ONLN)" install 1>/dev/null 2>/dev/null \
  && cd /tmp \
  && rm -rf /tmp/postgresql* \
  # user setup
  && echo "gem: --no-rdoc --no-ri" >> /etc/gemrc \
  && useradd --uid $USER_ID --groups $GROUP -m app \
  && mkdir -p $APP_DIR \
  && chown -R $USER_ID.$GROUP $APP_DIR

WORKDIR $APP_DIR

USER $USER_ID
