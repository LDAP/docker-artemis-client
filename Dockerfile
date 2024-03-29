ARG DEBIAN_FRONTEND=noninteractive
ARG ARTEMIS_GIT_REPOSITORY=https://github.com/ls1intum/Artemis
ARG ARTEMIS_VERSION=develop

####################
# Build stage      #
####################
FROM openjdk:17-jdk-buster AS build

ENV LC_ALL C

RUN echo "Installing prerequisites" \
  && apt-get update && apt-get install -y --no-install-recommends curl \
  && curl -sL https://deb.nodesource.com/setup_17.x | bash - \
  && apt-get update && apt-get install -y --no-install-recommends \
  git \
  nodejs \
  rsync

ARG ARTEMIS_VERSION
ARG ARTEMIS_GIT_REPOSITORY

RUN echo "Building frontend from $ARTEMIS_GIT_REPOSITORY" \
  && mkdir /build && cd /build \
  && git clone --depth 1 --branch $ARTEMIS_VERSION $ARTEMIS_GIT_REPOSITORY \
  && cd Artemis \
  && npm install \
  && APP_VERSION=$(./gradlew properties -q | grep "^version:" | awk '{print $2}') NODE_OPTIONS="--max_old_space_size=6144" npm run webapp:prod \
  && rm -f build/resources/main/static/stats.json build/resources/main/static/report.html \
  && rsync -a src/main/resources/public/ build/resources/main/static/public/

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
