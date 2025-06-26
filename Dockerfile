FROM php:8.2-cli

RUN apt-get update \
    && apt-get install -y git unzip libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# 1. Copie juste composer.json/lock au début
COPY composer.json composer.lock ./

RUN echo "===> CECI EST MON DOCKERFILE SYMFONY <==="

# 2. Installe les dépendances SANS exécuter les scripts auto (pas de post-install-cmd)
RUN composer install --ignore-platform-reqs --no-scripts --no-autoloader

# 3. Copie tout le reste du projet (y compris src/Entity, etc)
COPY . .

# 4. Re-génère l’autoload et exécute les scripts (cache:clear, etc)
RUN composer dump-autoload --no-scripts --optimize \
    && composer run-script post-install-cmd

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]
