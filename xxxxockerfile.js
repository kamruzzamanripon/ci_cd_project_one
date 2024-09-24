# Use an official PHP image as the base image
FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    nodejs \
    npm \
    supervisor

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql pdo_sqlite zip gd

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the current directory contents into the container
COPY . .

# Install PHP dependencies using Composer
RUN composer install

# Install NPM dependencies
RUN npm install

# Expose port 8000 for Laravel's dev server
EXPOSE 8000

# Add a command to start the development server and watch for changes (hot reloading)
CMD ["npm", "run", "dev"]
