#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
composer install --no-progress --no-interaction --ignore-platform-reqs
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env $APP_ENV"
    cp .env.example .env
else
    echo "env file exists."
fi

npm install
npm run build

php artisan migrate --seed #change seeders to admin only, once app is in prod
php artisan key:generate
php artisan cache:clear

php artisan serve --port="$PORT" --host=0.0.0.0 --env=.env
exec docker-php-entrypoint "$@"
