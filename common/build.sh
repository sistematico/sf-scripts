#!/usr/bin/env bash

COMPOSER="/usr/local/bin/composer"
NPM="npm"

[ ! -f database/database.sqlite ] && touch database/database.sqlite
[ ! -f .env ] && cp .env.example .env 
[ -f .env ] && source .env

while [ ! -z "$1" ]; do
  case $1 in
    -p | --prune) prune=1 ;;
    -o | --optimize) optimize=1 ;;
  esac

  shift
done

if [ -z "$APP_KEY" ] || [ "$APP_KEY" == "" ]; then 
  php artisan key:generate
fi

if [ "$APP_ENV" == "local" ]; then
  $COMPOSER install
  php artisan migrate:fresh --seed
else
  $COMPOSER install --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist --optimize-autoloader --no-dev
  php artisan migrate:fresh --seed --force
fi

echo "Gerando links..."
php artisan storage:link

echo "Rodando npm install..."
$NPM install
[ "$APP_ENV" == "production" ] && $NPM run build

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