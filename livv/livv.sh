#!/usr/bin/env bash

composer install 1> /dev/null 2> /dev/null
php artisan migrate:fresh --seed --force -q
php artisan key:generate --force -q
php artisan storage:link --force -q
pnpm install 1> /dev/null 2> /dev/null 
pnpm run build
pnpm run dev