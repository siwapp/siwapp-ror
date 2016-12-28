FROM ruby:2.2.0-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
	apt-get install -y \
	build-essential \
	nodejs \
	libpq-dev \
	libsqlite3-dev \
	libqt5webkit5-dev \
	qt5-default \
	xvfb

# Copy project src to container
COPY . /app

# Set /app as workdir
WORKDIR /app

# Install dependencies
RUN bundle install
