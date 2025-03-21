FROM ruby:3.3.5-alpine AS build

WORKDIR /app

RUN apk add --no-cache build-base libc-dev linux-headers

COPY ./Gemfile* ./
RUN bundle install --no-cache

COPY . .


# Test
FROM build AS test

WORKDIR /app

RUN bundle exec rspec


# Pre-runtime
FROM build AS pre-runtime

WORKDIR /app

RUN rm -rf ./spec

RUN bundle config set deployment true

RUN bundle install

RUN rm -rf ./Gemfile*


# Runtime
FROM pre-runtime AS runtime

WORKDIR /app

COPY --from=pre-runtime /app/src ./src
COPY --from=pre-runtime /app/assets ./assets

ENV PORT=8088
EXPOSE ${PORT}

ENTRYPOINT ["ruby", "./src/index.rb", "-p", "$PORT"]
