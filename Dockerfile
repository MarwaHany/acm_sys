FROM ruby:3.1.2-alpine

ENV LANG C.UTF-8
ENV APP_ROOT /app
RUN apk update \
    && mkdir -p /myapp \
    && apk add --no-cache git \
    # # build-base for native extensions
    build-base \
    mysql-client \
    mysql-dev \
    gcompat \
    bash

# create working directory

WORKDIR /app
COPY Gemfile Gemfile

COPY init.sh init.sh
COPY . .
# install required packages
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]