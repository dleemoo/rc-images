FROM dleemoo/app-2.3.1:latest

MAINTAINER Leonardo Lobo Lima <dleemoo@gmail.com>

ENV BUNDLER_VERSION=1.15.1 \
    PG_DOWNLOAD_SHA256=a6856099959bfff7cf0889b0e637b0f04642e8a9e8cbfa3f92555a03ef3b2448

ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
  # adds nodejs and yarn debian repository
  && echo 'deb https://deb.nodesource.com/node_6.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
  && curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  # sync debian and install app dependencies
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install nodejs yarn git python -y \
  # setup postgres client libs and headers
  && curl -sL http://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz -o /tmp/postgresql.tar.gz \
  && echo "$PG_DOWNLOAD_SHA256 /tmp/postgresql.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/postgresql \
  && tar -xzf /tmp/postgresql.tar.gz -C /tmp/postgresql --strip-components=1 \
  && cd /tmp/postgresql \
  && echo "Building postgresql ..." \
  && CFLAGS="-O3 -pipe" ./configure --prefix=/usr/local 1>/dev/null \
  && make -j"$(getconf _NPROCESSORS_ONLN)" install 1>/dev/null 2>/dev/null \
  && cd / \
  # install bundler
  && gem install bundler -v $BUNDLER_VERSION \
  # remove apt cache and temporary files
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/postgresql*

# If you need root access to container use following command:
# docker run --rm -it --entrypoint=/bin/bash dleemoo/rc2
