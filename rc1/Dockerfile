FROM ruby:2.3.7-alpine3.7

MAINTAINER Leonardo Lobo Lima <dleemoo@gmail.com>

ENV PG_DOWNLOAD_SHA256=b85275da86e23981591865ce184ea5911f77506888215b334929b818eb6bfb61 \
    GEM_HOME=/home/app/gems \
    BUNDLE_PATH=/home/app/gems \
    BUNDLE_BIN=/home/app/gems/bin \
    BUNDLE_APP_CONFIG=/home/app/gems \
    PATH=/home/app/gems/bin:$PATH

ARG USER_ID
ARG GROUP=100
ARG APP_DIR=/usr/src/app

RUN set -ex \
  && apk add --no-cache \
      build-base \
      curl \
      file \
      git \
      imagemagick \
      less \
      libxml2-dev \
      libxslt-dev \
      nodejs \
      postgresql-dev \
      readline \
      readline-dev \
      tzdata \
  # setup postgres client libs and headers
  && curl -sL http://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz -o /tmp/postgresql.tar.gz \
  && echo "$PG_DOWNLOAD_SHA256  /tmp/postgresql.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/postgresql \
  && tar -xzf /tmp/postgresql.tar.gz -C /tmp/postgresql --strip-components=1 \
  && cd /tmp/postgresql \
  && CFLAGS="-O3 -pipe" ./configure --prefix=/usr/local 1>/dev/null \
  && make -j"$(getconf _NPROCESSORS_ONLN)" install 1>/dev/null 2>/dev/null \
  && rm -rf /tmp/postgresql* \
  # user setup
  && echo "gem: --no-rdoc --no-ri" >> /etc/gemrc \
  && adduser -u $USER_ID -D app \
  && mkdir -p $APP_DIR \
  && chown -R $USER_ID.$GROUP $APP_DIR

WORKDIR $APP_DIR

USER $USER_ID
