FROM dleemoo/app-2.3.0:latest

MAINTAINER Leonardo Lobo Lima <dleemoo@gmail.com>

ENV BUNDLER_VERSION=1.13.7 \
    PG_DOWNLOAD_SHA256=b85275da86e23981591865ce184ea5911f77506888215b334929b818eb6bfb61

RUN set -ex \
  # setup nodejs repository
  && echo 'deb https://deb.nodesource.com/node_6.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
  && curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
  # sync debian and install app dependencies
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install git nodejs imagemagick file -y \
  # setup postgres client libs and headers
  && curl -sL http://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz -o /tmp/postgresql.tar.gz \
  && echo "$PG_DOWNLOAD_SHA256 /tmp/postgresql.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/postgresql \
  && tar -xzf /tmp/postgresql.tar.gz -C /tmp/postgresql --strip-components=1 \
  && cd /tmp/postgresql \
  && CFLAGS="-O3 -pipe" ./configure --prefix=/usr/local 1>/dev/null \
  && make -j"$(getconf _NPROCESSORS_ONLN)" install 1>/dev/null 2>/dev/null \
  && cd / \
  # install bundler
  && gem install bundler -v $BUNDLER_VERSION \
  && gem uninstall bundler -xav "> $BUNDLER_VERSION" 2>/dev/null || true \
  # remove apt cache and temporary files
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/postgresql*

# If you need root access to container use following command:
# docker run --rm -it --entrypoint=/bin/bash dleemoo/rc1
