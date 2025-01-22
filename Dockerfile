FROM ruby:3.3.5-alpine

RUN apk add --no-cache build-base libc-dev linux-headers

WORKDIR /app

COPY . .
RUN bundle install

RUN rspec

EXPOSE 8088

CMD ["ruby", "./src/index.rb", "-p", "8088"]