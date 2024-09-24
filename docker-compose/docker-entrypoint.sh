#!/bin/sh

# Check if the 'users' table exists
if ! mysql -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -h db -e "USE ${MYSQL_DATABASE}; SHOW TABLES LIKE 'users';" | grep -q 'users'; then
  echo "No tables found, running migrations..."
  php artisan migrate:fresh --seed
else
  echo "Tables already exist, skipping migrations..."
fi

# Run Laravel's dev server and npm dev server in the background
php artisan serve --host=0.0.0.0 --port=8000 & npm run dev
#php npm run dev