########################################
# 1. Build elixir backend
########################################
FROM hexpm/elixir:1.12.1-erlang-24.0.2-alpine-3.13.3 AS build-elixir

# install build dependencies
RUN apk add --update git nodejs npm

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install dependencies
COPY mix.* ./
COPY .version .version
RUN mix deps.get --force --only prod

# install npm dependencies
COPY assets/package*.json ./assets/
RUN npm --prefix ./assets install --progress=false --no-audit --loglevel=error

# build assets
COPY assets assets
RUN npm run --prefix ./assets deploy

COPY config ./config/
COPY lib ./lib/
COPY priv ./priv/

# build release
RUN mix phx.digest && \
    mix release

########################################
# 2. Build release image
########################################
FROM alpine:3.13.3
RUN mkdir /nudge && \
    apk add --update --no-cache ncurses-libs

WORKDIR /nudge
RUN chown nobody:nobody /nudge
USER nobody:nobody

COPY --from=build-elixir --chown=nobody:nobody /app/_build/prod/rel/nudge/ .

ENV MIX_ENV prod
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
EXPOSE 4000
CMD ["/nudge/bin/nudge", "start"]