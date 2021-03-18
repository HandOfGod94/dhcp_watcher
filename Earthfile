FROM --platform=linux/arm/v7 elixir:1.11

build:
  ENV MIX_ENV=prod
  COPY config config
  COPY lib lib
  COPY mix.exs mix.exs
  COPY mix.lock mix.lock
  RUN mix local.hex --force && mix local.rebar --force && mix do deps.get, deps.compile
  RUN mix release
  SAVE ARTIFACT _build/prod/pi_build-0.1.0.tar.gz AS LOCAL pi_build-0.1.0.tar.gz