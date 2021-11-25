FROM ruby:3.0.3-alpine

RUN mkdir -p app
WORKDIR app

ADD Gemfile Gemfile.lock /app/
RUN bundle check | bundle install --without test development
ADD . /app

EXPOSE 4567
CMD bin/server -o 0.0.0.0
