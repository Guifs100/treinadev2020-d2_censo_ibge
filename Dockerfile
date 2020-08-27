FROM ruby:2.6.6

RUN gem install bundler
RUN git clone https://github.com/Guifs100/treinadev2020-d2_censo_ibge

WORKDIR /censo

COPY Gemfile.lock Gemfile ./
COPY bin/setup bin/setup
RUN bin/setup
COPY . /censo
