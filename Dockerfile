FROM hexpm/elixir:1.12.1-erlang-24.0.2-alpine-3.13.3 AS build

RUN apk add --update git nodejs=14.16.1-r1 npm
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod
ENV NODE_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
COPY .version ./
RUN mix deps.get --force --only prod

COPY assets/package.json assets/package-lock.json ./assets/
RUN cd assets && npm install

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release

FROM alpine:3.13.3 AS app
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/nudge ./

ENV MIX_ENV prod
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 4000

CMD ["bin/nudge", "start"]