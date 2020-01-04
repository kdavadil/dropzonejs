#!/usr/bin/env bash
echo "[Deploying]"
#git pull origin master
composer install --no-interaction --prefer-dist --optimize-autoloader
if [ ! -f ".env" ]; then
    echo "  [Installing - .env missing]"
    yes | ./install.sh
else
    DB_DATABASE=$(grep DB_DATABASE .env | xargs)
    IFS='=' read -ra DB_DATABASE <<< "$DB_DATABASE"
    DB_DATABASE=${DB_DATABASE[1]}
    echo "    [DB_DATABASE: $DB_DATABASE]"
    echo "  [Installing - .env exists]"
    if [ "$DB_DATABASE" == 'forge' ] || [ "$DB_DATABASE" == \"\" ] || [ "$DB_DATABASE" == '' ]; then
        php artisan env:set db_database ""
#        DB_DATABASE=""
        yes | ./install.sh
    fi
fi
php artisan view:clear
php artisan cache:clear
php artisan migrate --force
php artisan db:seed
npm ci
npm run dev