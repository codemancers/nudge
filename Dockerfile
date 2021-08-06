FROM elixir:latest

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

RUN mix do compile

RUN mix release
ENV MIX_ENV=prod
CMD mix deps.get && cd assets && npm install && npm run deploy && cd ..