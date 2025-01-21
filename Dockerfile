FROM ruby:3.3.5-alpine

WORKDIR /app

COPY . .
RUN bundle install

RUN rspec

EXPOSE 8088

CMD ["ruby", "./src/index.rb", "-p", "8088"]