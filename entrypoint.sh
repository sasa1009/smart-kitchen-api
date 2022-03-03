#!/bin/bash
set -e

# DB作成
# bundle exec rails db:create

# DBマイグレーション
# bundle exec rails db:migrate

# サンプルデータ投入
# bundle exec rails r db/seeds/recipe.rb

sudo service nginx start

# /smart-kitchen-api/tmp/sockets/puma.sockを出力させるためにこちらのコマンドを使用する
rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb

# Dockerfile内のCMDを実行する
# exec "$@"
