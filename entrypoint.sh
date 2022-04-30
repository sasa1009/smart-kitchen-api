#!/bin/bash
set -e

# DB作成
# bundle exec rails db:create

# DBマイグレーション
# bundle exec rails db:migrate

# サンプルデータ投入
# bundle exec rails r db/seeds/recipe.rb
# bundle exec rails r db/seeds/favorite.rb
# bundle exec rails r db/seeds/relationship.rb

sudo service nginx start

# /smart-kitchen-api/tmp/sockets/puma.sockを出力させるためにこちらのコマンドを使用する
# rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb

# ターミナルにログを出力させたいのでrails s でrailsサーバーを起動する
rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'

# Dockerfile内のCMDを実行する
# exec "$@"
