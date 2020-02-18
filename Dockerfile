FROM elixir:1.10.1 as build

# install build dependencies

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release

# prepare release image
FROM elixir:1.10.1 as app

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/url_shortener ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
