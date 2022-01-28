FROM ruby:2.7.2

# パッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs less

# 作業ディレクトリを/smart-kitchen-apiに指定
WORKDIR /smart-kitchen-api

# ローカルのGemfileをDokcerにコピー
COPY Gemfile* /smart-kitchen-api/

# /smart-kitchen-apiディレクトリ上でbundle install
RUN bundle install
