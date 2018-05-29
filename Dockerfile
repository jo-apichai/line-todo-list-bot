FROM ruby:2.5.1

RUN mkdir /line_bot
WORKDIR /line_bot

RUN apt-get update && apt-get install -y nodejs

COPY Gemfile Gemfile.lock /line_bot/
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /line_bot/

EXPOSE 3000
