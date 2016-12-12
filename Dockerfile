FROM ruby:2.2.0-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
	apt-get install -y \
	build-essential \
	nodejs \
	libmysqlclient-dev \
	libsqlite3-dev \
	libqt4-dev \
	libqtwebkit-dev

# Copy project src to container
COPY . /app

# Set /app as workdir
WORKDIR /app

# Install dependencies
RUN bundle install
