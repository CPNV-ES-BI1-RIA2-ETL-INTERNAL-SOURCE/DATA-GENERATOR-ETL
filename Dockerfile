FROM ruby:3.3.5-alpine

RUN apk add --no-cache build-base libc-dev linux-headers

WORKDIR /app

COPY . .
RUN bundle install

EXPOSE 8000

CMD ruby ./src/index.rb