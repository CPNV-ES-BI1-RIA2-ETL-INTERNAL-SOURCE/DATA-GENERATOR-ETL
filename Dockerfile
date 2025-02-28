FROM ruby:3.3.5-alpine

RUN apk add --no-cache build-base libc-dev linux-headers

WORKDIR /app

COPY . .
RUN bundle install

ENV PORT=8088
EXPOSE ${PORT}

CMD ruby ./src/index.rb -p $PORT