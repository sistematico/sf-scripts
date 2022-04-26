#!/usr/bin/env bash

while [ ! -z "$1" ]; do
  case $1 in
    -p | --prune) prune=1 ;;
    -o | --optimize) optimize=1 ;;
  esac

  shift
done

[ ! -L storage/app/musicas ] && ln -s /opt/liquidsoap/music storage/app/musicas

# Install
[ ! -f .env ] && cp .env.example .env
[ ! -f database/database.sqlite ] && touch database/database.sqlite

composer install --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist --optimize-autoloader --no-dev -q

php artisan migrate:fresh --seed --force -q
php artisan key:generate --force -q
php artisan storage:link --force -q

pnpm install
pnpm build

# Prune
if [ -z "$prune" ]; then
  php artisan cache:clear
  php artisan config:clear
  php artisan route:clear
  php artisan view:clear
fi

# Optimize
if [ -z "$optimize" ]; then
  php artisan config:cache
  php artisan route:cache
  php artisan view:cache
fi
