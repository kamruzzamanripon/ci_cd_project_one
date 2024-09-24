FROM php:8.2-fpm-alpine as base

ARG user=developer
ARG uid=1000

# Install required packages
RUN apk update && apk add \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libzip-dev \
    zip \
    nodejs \
    npm \
    libxml2-dev \
    shadow

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql \
    && apk --no-cache add nodejs npm

# Set working directory
WORKDIR /var/www

# Copy only the composer.json and composer.lock first to leverage Docker layer caching
#COPY composer.json composer.lock /var/www/

# Install PHP dependencies using Composer
#RUN composer install --no-interaction --prefer-dist --optimize-autoloader
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy the rest of the application files
#COPY . /var/www

# Install Node.js dependencies
COPY package.json package-lock.json /var/www/
RUN npm install

RUN echo "User: $user, UID: $uid"

# Add the user for better permissions handling
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Switch to the non-root user
USER $user

# Expose port 8000 for Laravel's dev server
#EXPOSE 8000

FROM base as local_dev

#CMD ["sh", "-c", "php artisan serve & npm run dev"]
#CMD ["sh", "-c", "php artisan serve --host=0.0.0.0 --port=8000 & npm run dev"]
