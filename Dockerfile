FROM jekyll/jekyll:stable

COPY Gemfile* ./

RUN gem install bundler
RUN bundle install

ENTRYPOINT [ "jekyll" ]

CMD [ "build" ]
