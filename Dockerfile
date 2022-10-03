# docker build -t chess .
# docker create -it --name chess --volume chess:/app chess

FROM ruby:3.1.2-alpine3.16
RUN apk add git
RUN git config --global core.autocrlf true
WORKDIR /app
COPY . .
RUN bundle install
CMD ["sh"]
