FROM elixir:1.6-alpine
MAINTAINER Marnen Laibow-Koser <marnen@marnen.org>

RUN apk update && apk add git inotify-tools
ARG workdir=hamlex
RUN mix local.hex --force
RUN mix local.rebar --force
COPY . ${workdir}/
WORKDIR ${workdir}
RUN mix deps.get
