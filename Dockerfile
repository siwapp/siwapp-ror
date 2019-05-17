FROM ruby:2.4.5-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && \
	apt-get install -y \
	build-essential \
	nodejs \
	libpq-dev \
	libqt5webkit5-dev \
	qt5-default \
	xvfb \
    libssl1.0-dev

# Copy project src to container
COPY ./Gemfile /app/
COPY ./Gemfile.lock /app/

# Set /app as workdir
WORKDIR /app

# Install dependencies
RUN bundle install
