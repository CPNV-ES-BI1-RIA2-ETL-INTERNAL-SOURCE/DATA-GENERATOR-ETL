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

# Copy application files
COPY --from=pre-runtime /app/app.rb ./app.rb
COPY --from=pre-runtime /app/config ./config
COPY --from=pre-runtime /app/bin ./bin
COPY --from=pre-runtime /app/src ./src
COPY --from=pre-runtime /app/assets ./assets

# Make scripts executable
RUN chmod +x ./bin/server
RUN chmod +x ./bin/console

# Create and set permissions for logs directory
RUN mkdir -p logs && chmod -R 755 logs

ENV PORT=8000
ENV RACK_ENV=production
EXPOSE ${PORT}

ENTRYPOINT ["ruby", "./bin/server"]
