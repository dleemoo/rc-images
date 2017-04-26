FROM dleemoo/app-2.3.1:0.0.1

MAINTAINER Leonardo Lobo Lima <dleemoo@gmail.com>

ENV BUNDLER_VERSION=1.14.6 \
    PG_DOWNLOAD_SHA256=b85275da86e23981591865ce184ea5911f77506888215b334929b818eb6bfb61

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
  && apt-get install nodejs yarn git -y \
  # setup postgres client libs and headers
  && curl -sL http://ftp.postgresql.org/pub/source/v9.6.1/postgresql-9.6.1.tar.gz -o /tmp/postgresql.tar.gz \
  && echo "$PG_DOWNLOAD_SHA256 /tmp/postgresql.tar.gz" | sha256sum -c - \
  && mkdir -p /tmp/postgresql \
  && tar -xzf /tmp/postgresql.tar.gz -C /tmp/postgresql --strip-components=1 \
  && cd /tmp/postgresql \
  && echo "Building postgresql ..." \
  && CFLAGS="-O3 -pipe" ./configure --prefix=/usr/local 1>/dev/null \
  && make -j"$(getconf _NPROCESSORS_ONLN)" install 1>/dev/null 2>/dev/null \
  && cd / \
  # install phantomjs binary
  && apt-get install -y \
  && mkdir -p /tmp/phantom \
  && curl -sL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -o /tmp/phantom.tar.bz2 \
  && tar xjf /tmp/phantom.tar.bz2 -C /tmp/phantom --strip-components=1 \
  && mv /tmp/phantom/bin/phantomjs /usr/local/bin/ \
  # install bundler
  && gem install bundler -v $BUNDLER_VERSION \
  # remove apt cache and temporary files
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/phantom* /tmp/postgresql*

# If you need root access to container use following command:
# docker run --rm -it --entrypoint=/bin/bash dleemoo/rc2
