ARG DEBIAN_FRONTEND=noninteractive
ARG ARTEMIS_GIT_REPOSITORY=https://github.com/ls1intum/Artemis
ARG ARTEMIS_VERSION=develop

####################
# Build stage      #
####################
FROM openjdk:15-jdk-buster AS build

ENV LC_ALL C

RUN echo "Installing prerequisites" \
  && apt-get update && apt-get install -y --no-install-recommends curl \
  && curl -sL https://deb.nodesource.com/setup_15.x | bash - \
  && apt-get update && apt-get install -y --no-install-recommends \
  cron \
  supervisor \
  syslog-ng \
  syslog-ng-core \
  syslog-ng-mod-redis \
  git \
  nodejs \
  && npm install --global yarn

ARG ARTEMIS_VERSION
ARG ARTEMIS_GIT_REPOSITORY

RUN echo "Building frontend from $ARTEMIS_GIT_REPOSITORY" \
  && mkdir /build && cd /build \
  && git clone --depth 1 --branch $ARTEMIS_VERSION $ARTEMIS_GIT_REPOSITORY \
  && cd Artemis \
  && yarn install \
  && yarn run webpack:prod \
  && rm build/resources/main/static/stats.json build/resources/main/static/report.html

####################
# Execution stage  #
####################
FROM nginx

LABEL maintainer "Lucas Alber <lucasd.alber@gmail.com>"

COPY defaults/nginx.conf /etc/nginx/nginx.conf
COPY defaults/proxy.conf /etc/nginx/proxy.conf
# See https://hub.docker.com/_/nginx Environment variables
COPY defaults/artemis.conf.template /etc/nginx/templates/artemis.conf.template
COPY --from=build /build/Artemis/build/resources/main/static /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80