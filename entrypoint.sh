#!/bin/bash
set -e

# createとseedはfargateの初回のみ実行
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

sudo service nginx start

# /smart-kitchen-api/tmp/sockets/puma.sockを出力させるためにこちらのコマンドを使用する
rm -f tmp/pids/server.pid && bundle exec puma -C config/puma.rb

# Dockerfile内のCMDを実行する
# exec "$@"
