FROM jekyll/jekyll:stable

COPY Gemfile* ./

RUN gem install bundler:2.4 && bundle install

ENTRYPOINT [ "jekyll" ]

CMD [ "build" ]