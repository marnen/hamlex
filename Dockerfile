FROM elixir:1.6-alpine
MAINTAINER Marnen Laibow-Koser <marnen@marnen.org>

ARG workdir=hamlex
RUN mix local.hex --force
RUN mix local.rebar --force
COPY . ${workdir}/
WORKDIR ${workdir}
RUN mix deps.get
