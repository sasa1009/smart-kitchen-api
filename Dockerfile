FROM ruby:2.7.2

ENV RAILS_ENV=production

# パッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs less sudo nginx

# 作業ディレクトリを/smart-kitchen-apiに指定
WORKDIR /smart-kitchen-api

# ローカルのGemfileをDokcerにコピー
COPY Gemfile* /smart-kitchen-api/

# /smart-kitchen-apiディレクトリ上でbundle install
RUN bundle install

COPY . /smart-kitchen-api

# entrypoint.shの設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# CMD bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
