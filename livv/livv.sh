#!/usr/bin/env bash

COMPOSER="/usr/local/bin/composer"
NPM="npm"

[ ! -f .env ] && cp .env.example .env
[ ! -f database/database.sqlite ] && touch database/database.sqlite
[ -f .env ] && source .env

while [ ! -z "$1" ]; do
  case $1 in
    -p | --prune) prune=1 ;;
    -o | --optimize) optimize=1 ;;
  esac

  shift
done

if [ "$APP_ENV" == "local" ]; then
  [ ! -L storage/app/musicas ] && ln -s /home/lucas/audio storage/app/musicas
  $COMPOSER install
  php artisan migrate:fresh --seed
  #[ "$NPM" == "npm" ] && npx @preset/cli apply laravel:inertia || pnpm dlx @preset/cli apply laravel:inertia
else
  #[ ! -L storage/app/musicas ] && ln -s /opt/liquidsoap/music storage/app/musicas
  $COMPOSER install --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist --optimize-autoloader --no-dev
  php artisan migrate --seed --force
  #[ "$NPM" == "npm" ] && npx @preset/cli apply laravel:inertia --force || pnpm dlx @preset/cli apply laravel:inertia --force
fi

php artisan key:generate 
php artisan storage:link

$NPM install
[ "$APP_ENV" == "local" ] || $NPM run build

# Prune
if [ ! -z "$prune" ]; then
  php artisan cache:clear
  php artisan config:clear
  php artisan route:clear
  php artisan view:clear
fi

# Optimize
if [ ! -z "$optimize" ]; then
  php artisan config:cache
  php artisan route:cache
  php artisan view:cache
fi