FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

ARG secret_key_base
ENV RAILS_ROOT /var/www/app_name
ENV RAILS_MASTER_KEY=${secret_key_base}
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
ENV RAILS_ENV='production'
ENV RACK_ENV='production'
COPY Gemfile Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]