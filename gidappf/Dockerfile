FROM ruby:2.5.3-alpine3.8

RUN apk update && apk add build-base nodejs postgresql-dev

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Daniel Rosatto <danielrosatto@gmail.com>"

CMD puma -C config/puma.rb
